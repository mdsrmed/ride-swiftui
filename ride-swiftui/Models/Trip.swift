//
//  Trip.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/6/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase


enum TripState: Int, Codable {
    case requested
    case rejected
    case accepted
}

struct Trip: Identifiable, Codable {
    @DocumentID var tripId: String?
    let passengerUid: String
    let driverUid: String
    let passengerName: String
    let driverName: String
    let passengerLocation: GeoPoint
    let driverLocation: GeoPoint
    let pickupLocationName: String
    let dropoffLocationName: String
    let pickupLocationAddress: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let tripCost: Double
    
    var distanceToPassenger: Double?
    var travelTimeToPassenger: Int?
    var state: TripState
    var id: String {
        return tripId ?? ""
    }
}
