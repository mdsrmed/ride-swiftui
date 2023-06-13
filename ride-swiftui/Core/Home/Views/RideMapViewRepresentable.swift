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
    let locationManager = LocationManager()
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let coordinate = locationViewModel.selectedLocationCoordinate {
            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
            context.coordinator.configurePolyline(withDestionCoordinate: coordinate)
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
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline .strokeColor = .systemBlue
            polyline .lineWidth = 6
            return polyline
        }
        
        //MARK: - Helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let ann = MKPointAnnotation()
            ann.coordinate = coordinate
            parent.mapView.addAnnotation(ann)
            parent.mapView.selectAnnotation(ann, animated: true)
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        func configurePolyline(withDestionCoordinate coordinate: CLLocationCoordinate2D){
            
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            getDestinationRoute(from: userLocationCoordinate, to: coordinate) { [weak self] route in
                self?.parent.mapView.addOverlay(route.polyline)
            }
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
                completion(route)
                
                
            }
        }
    }
}
