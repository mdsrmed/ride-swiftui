//
//  DriverAnnotation.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/3/23.
//

import Foundation
import MapKit
import Firebase


class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let uid: String
    
    init(driver: User) {
        self.coordinate = CLLocationCoordinate2D(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
        self.uid = driver.uid
    }
    
    
}
