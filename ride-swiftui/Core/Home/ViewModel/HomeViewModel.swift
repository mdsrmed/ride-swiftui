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


class HomeViewModel:NSObject, ObservableObject {
    
    @Published var drivers = [User]()
    private let service = UserService.shared
    var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    
    // Location search properties
    
    @Published var results = [MKLocalSearchCompletion()]
    @Published var selectedRideLocation: RideLocation?
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    private let searchCompleter = MKLocalSearchCompleter()
    var userLocation: CLLocationCoordinate2D?
    var queryFragment: String = ""{
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
   
    
    override init(){
        super.init()
        self.fetchDrivers()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    func fetchDrivers(){
        Firestore.firestore().collection("users").whereField("accountType", isEqualTo: accoutType.driver.rawValue)
            .getDocuments { snapshot , _ in
                guard let documents = snapshot?.documents else {return}
                let drivers = documents.compactMap({try?  $0.data(as: User.self)})
                self.drivers = drivers
            }
    }
    
    func fetchUser(){
        service.$user.sink { user in
            guard let user = user else {return}
            self.currentUser = user
            guard user.accounttype == .passenger else {return}
            self.fetchDrivers()
        }
        .store(in: &cancellables)
    }
}


extension HomeViewModel {
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

extension HomeViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}

