//
//  RideMapViewRepresentable.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/11/23.
//

import SwiftUI
import MapKit

struct RideMapViewRepresentable: UIViewRepresentable {
    
    let mapView = MKMapView()
   
    @Binding var mapState: MapViewState
    //@EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenter()
            context.coordinator.addDriversToMap(homeViewModel.drivers)
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            if let coordinate = homeViewModel.selectedRideLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestionCoordinate: coordinate)
        }
            break
            
        case .polylineAdded:
            break
        
        case .tripAccepted:
            guard let trip = homeViewModel.trip else { return }
            guard let driver = homeViewModel.currentUser, driver.accountType == .driver else { return }
            guard let route = homeViewModel.routeToPickupLocation else { return }
            context.coordinator.configurePolylineToPickupLocation(route)
            context.coordinator.addAndSelectAnnotation(withCoordinate: trip.pickupLocation.toCoordinate())
            
            
        default :
            break
       }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension RideMapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: RideMapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        init(parent: RideMapViewRepresentable) {
           
            self.parent = parent
            super.init()
            
        }
        //MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.currentRegion = region
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline .strokeColor = .systemBlue
            polyline .lineWidth = 6
            return polyline
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(named: "car.circle")
                return view
            } else {
                return nil
            }
        
        }
        
        //MARK: - Helpers
        
        func configurePolylineToPickupLocation( _ route: MKRoute){
            self.parent.mapView.addOverlay(route.polyline)
            let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 90, left: 32, bottom: 400, right: 32))
            self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let ann = MKPointAnnotation()
            ann.coordinate = coordinate
            parent.mapView.addAnnotation(ann)
            parent.mapView.selectAnnotation(ann, animated: true)
            
        }
        
        func configurePolyline(withDestionCoordinate coordinate: CLLocationCoordinate2D){
            
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            parent.homeViewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { [weak self] route in
                self?.parent.mapView.addOverlay(route.polyline)
                self?.parent.mapState = .polylineAdded
                let rect = self?.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self?.parent.mapView.setRegion(MKCoordinateRegion(rect!), animated: true)
            }
        }
        
      
        
        func clearMapViewAndRecenter(){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
            
        }
        
        func addDriversToMap( _ drivers: [User]){
            let annotations = drivers.map({DriverAnnotation(driver: $0)})
            self.parent.mapView.addAnnotations(annotations)

        }
    }
}
