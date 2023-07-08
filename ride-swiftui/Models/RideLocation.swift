//
//  RideLocation.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/22/23.
//

import Foundation
import CoreLocation


struct RideLocation: Identifiable {
    let id = NSUUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
