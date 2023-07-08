//
//  GeoPoint.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/8/23.
//

import Foundation
import Firebase
import CoreLocation

extension GeoPoint {
    func toCoordinate() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
