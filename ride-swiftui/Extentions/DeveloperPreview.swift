//
//  DeveloperPreview.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/1/23.
//

import Foundation
import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let mockTrip = Trip(
                        passengerUid: NSUUID().uuidString,
                        driverUid: NSUUID().uuidString,
                        passengerName: "Shahid",
                        driverName: "John Smith",
                        passengerLocation: .init(latitude: 37.5, longitude: -122.5),
                        driverLocation: .init(latitude: 37.5, longitude: -125.5),
                        pickupLocationName: "Bronx",
                        dropoffLocationName: "Empire State Building",
                        pickupLocationAddress: "34 street",
                        pickupLocation: .init(latitude: 37.5, longitude: -127.5),
                        dropoffLocation: .init(latitude: 37.5, longitude: -124.5),
                        tripCost: 50.55,
                        distanceToPassenger: 500,
                        travelTimeToPassenger: 30,
                        state: .rejected)
    
    let mockUser = User(uid: NSUUID().uuidString,
                        fullname:"Ms Rahman",
                        email: "msrs@gmail.com",
                        coordinates: GeoPoint(latitude: 40.75,
                                              longitude: 73.99),
                        homeLocation: nil,
                        workLocation: nil,
                        accountType: .passenger)
}
