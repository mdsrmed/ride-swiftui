//
//  HomeViewModel.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/1/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine
import MapKit


class HomeViewModel:NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var drivers = [User]()
    private let service = UserService.shared
    
    private var cancellables = Set<AnyCancellable>()
    var currentUser: User?
    var routeToPickupLocation: MKRoute?
    
    // Location search properties
    
    @Published var results = [MKLocalSearchCompletion()]
    @Published var selectedRideLocation: RideLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    @Published var trip: Trip?
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    var queryFragment: String = ""{
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    
    override init(){
        super.init()
        self.fetchUser()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    

    // Mark: Helpers
    
    var tripCancelledMessage: String{
        guard let user = currentUser, let trip = trip else { return "" }
        
        if user.accountType == .passenger {
            if trip.state == .driverCancelled {
                return "Driver cancelled this trip"
            } else if trip.state == .passengerCancelled {
                return "Your trip has been cancelled"
            }
        } else {
            if user.accountType == .driver {
                if trip.state == .passengerCancelled {
                    return "Passenger cancelled this trip"
                } else if trip.state == .driverCancelled {
                    return "Your trip has been cancelled"
                }
            }
        }
            return ""
        }
        
        func viewForState( _ state: MapViewState, user: User) -> some View {
            switch state {
            case .polylineAdded, .locationSelected:
                return AnyView(TripRequestView())
                
            case .tripRequested:
                if user.accountType == .passenger {
                    return AnyView(TripLoadingView())
                } else {
                    if let trip = self.trip {
                        return AnyView(AcceptTripVIew(trip: trip))
                    }
                }
            case .tripAccepted:
                if user.accountType == .passenger {
                    return AnyView(TripLoadingView())
                } else {
                    if let trip = self.trip {
                        return AnyView(PickupPassengerView(trip: trip))
                    }
                    
                }
            case .tripCancelledByPassenger, .tripCancelledByDriver:
                return  AnyView(TripCancelledView())
                
                
            default:
                break
            }
            return AnyView(Text(""))
        }
        
        
        func fetchUser(){
            service.$user.sink { user in
                guard let user = user else {return}
                self.currentUser = user
                
                
                if user.accountType == .passenger {
                    self.fetchDrivers()
                    self.addTripObserverForPassenger()
                }else {
                    self.addTripObserverForDriver()
                }
            }
            .store(in: &cancellables)
        }
        
        private func updateTripState(state: TripState){
            
            guard let trip = trip else {return}
            var data = ["state": state.rawValue]
            if state == .accepted {
                data["travelTimeToPassenger"] = trip.travelTimeToPassenger
            }
            
            Firestore.firestore().collection("trips").document(trip.id).updateData(data) { _ in
                print("DEBUG: Did update trip with state \(state)")
                
            }
        }
        
        func deleteTrip(){
            
            guard let trip = trip else {return}
            Firestore.firestore().collection("trips").document(trip.id).delete{ _ in
                self.trip = nil
            }
            
        }
    
}

// Passenger Api
extension HomeViewModel {
    func addTripObserverForPassenger(){
        guard let currentUser = currentUser, currentUser.accountType == .passenger else {return}
        Firestore.firestore().collection("trips").whereField("passengerUid", isEqualTo: currentUser.uid)
            .addSnapshotListener{snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added || change.type == .modified
                else {return}
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                self.trip = trip
            }
        
    }
    
    func fetchDrivers(){
        Firestore.firestore().collection("users").whereField("accountType", isEqualTo: accoutType.driver.rawValue)
            .getDocuments { snapshot , _ in
                guard let documents = snapshot?.documents else {return}
                let drivers = documents.compactMap({try?  $0.data(as: User.self)})
                self.drivers = drivers
            }
    }
    
    func requestTrip() {
        guard let driver = drivers.first else {return}
        guard let currentUser = currentUser else {return}
        guard let dropoffLocation = selectedRideLocation else {return}
        let dropoffGeoPoint = GeoPoint(latitude: dropoffLocation.coordinate.latitude, longitude: dropoffLocation.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        
        getPlacemark(forLocation: userLocation) { placemark, _ in
            guard let placemark = placemark else {return}
            
            let tripCost = self.computeTripPrice(forType: .rideX)
            
            let trip = Trip(
                            passengerUid: currentUser.uid,
                            driverUid: driver.uid,
                            passengerName: currentUser.fullname,
                            driverName: driver.fullname,
                            passengerLocation: currentUser.coordinates,
                            driverLocation: driver.coordinates,
                            pickupLocationName: placemark.name ?? "",
                            dropoffLocationName: dropoffLocation.title,
                            pickupLocationAddress: self.addressFromPlacemark(placemark),
                            pickupLocation: currentUser.coordinates,
                            dropoffLocation: dropoffGeoPoint,
                            tripCost: tripCost,
                            distanceToPassenger: 0,
                            travelTimeToPassenger: 0,
                            state: .requested)
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else {return}
            Firestore.firestore().collection("trips").document().setData(encodedTrip){ _ in
                print("DEBUG: Did upload trip to firestore")
                
            }
            
        }
        
    }
    
    func cancellTripAsPassenger(){
        updateTripState(state: .passengerCancelled)
    }
}


// Driver Api

extension HomeViewModel {
    func addTripObserverForDriver(){
        guard let currentUser = currentUser, currentUser.accountType == .driver else {return}
        Firestore.firestore().collection("trips").whereField("driverUid", isEqualTo: currentUser.uid)
            .addSnapshotListener{snapshot, _ in
                guard let change = snapshot?.documentChanges.first,
                        change.type == .added || change.type == .modified
                else {return}
                
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                self.trip = trip
                
                self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.pickupLocation.toCoordinate()) { route in
                    self.routeToPickupLocation = route
                    self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime / 60)
                    self.trip?.distanceToPassenger = route.distance
                }
            }
    }
    
//    func fetchTrips(){
//        guard let currentUser = currentUser, currentUser.accountType == .driver else { return }
//        Firestore.firestore().collection("trips").whereField("driverUid", isEqualTo: currentUser.uid)
//            .getDocuments { snapshot, _ in
//                guard let documents = snapshot?.documents, let document = documents.first else {return}
//                guard let trip = try?document.data(as: Trip.self) else {return}
//                self.trip = trip
//
//                self.getDestinationRoute(from: trip.driverLocation.toCoordinate(), to: trip.pickupLocation.toCoordinate()) { route in
//                    self.trip?.travelTimeToPassenger = Int(route.expectedTravelTime / 60)
//                    self.trip?.distanceToPassenger = route.distance
//                }
//        }
//    }
    
    func rejectTrip(){
        updateTripState(state: .rejected)
    }
    
    
    func acceptTrip(){
        updateTripState( state: .accepted)
    }
    
    func cancellTripAsDriver(){
        updateTripState(state: .driverCancelled)
    }
    
    
}


extension HomeViewModel {
    
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var result = ""
        
        if let thoroughfare = placemark.thoroughfare {
            result += thoroughfare
        }
        
        if let subthoroughfare = placemark.subThoroughfare {
            result += " \(subthoroughfare)"
            
        }
        
        if let subadministrativeArea = placemark.subThoroughfare {
            result += ", \(subadministrativeArea)"
        }
        
        return result
    }
    
    
    func getPlacemark(forLocation location: CLLocation, completion: @escaping(CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error{
                completion(nil,error)
                return
            }
            guard let placemark = placemarks?.first else {return}
            completion(placemark, nil)
        }
    }
    
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config: LocationResultsViewConfig){
        locationSearch(forLocalSearchCompletion: localSearch) {[weak self] response, error  in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let item = response?.mapItems.first else{return}
            let coordinate = item.placemark.coordinate
            
            switch config {
            case .ride:
                self?.selectedRideLocation = RideLocation(title: localSearch.title, coordinate: coordinate)
                
            case .saveLocation(let viewModel):
                guard let uid = Auth.auth().currentUser?.uid else{return}
                let savedLocation = SavedLocation(title: localSearch.title, address: localSearch.subtitle, coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                guard let encodedLocation = try? Firestore.Encoder().encode(savedLocation) else {return}
                Firestore.firestore().collection("users").document(uid).updateData([
                    viewModel.databaseKey: encodedLocation])        
            }
        }
     }
            
       
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler ){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    func computeTripPrice(forType type: RideType) -> Double {
        guard let coordinate =  selectedRideLocation?.coordinate else {return 0.0}
        guard let userLocation = self.userLocation else {return 0.0}
        
        let pickupLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeters = pickupLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceInMeters)
    }
    
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destination: CLLocationCoordinate2D,
                             completion: @escaping(MKRoute) -> Void){
        
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: destination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destPlacemark)
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let route = response?.routes.first else {return}
            self.configurePickupAndDropOffTimes(with: route.expectedTravelTime)
            completion(route)
        }
    }
    
    func configurePickupAndDropOffTimes(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        pickupTime = formatter.string(from: Date())
        dropOffTime = formatter.string(from: Date() + expectedTravelTime)
    }
}

extension HomeViewModel {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

