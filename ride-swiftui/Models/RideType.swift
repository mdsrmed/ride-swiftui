//
//  RideType.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/18/23.
//

import Foundation


enum RideType: Int,Identifiable,CaseIterable {
    
case rideX
case rideXL
case black
    
    var id: Int {
        return rawValue
    }
    
    var description: String {
        
        switch self {
        case .rideX: return "RideX"
        case .rideXL: return "RideXL"
        case .black: return "RideBlack"
        }
        
    }
    
    var imageName: String {
        
        switch self {
        case .rideX: return "ride-x"
        case .rideXL: return "ride-xl"
        case .black: return "ride-black"
        }
        
    }
    
    var baseFare: Double {
        switch self {
        case .rideX: return 5
        case .rideXL:  return 10
        case .black: return 20
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let  distanceInMiles = distanceInMeters/1609
        
        switch self {
        case .rideX: return distanceInMiles * 1.5 + baseFare
        case .rideXL:  return distanceInMiles * 1.75 + baseFare
        case .black: return distanceInMiles * 2.0 + baseFare
        }
        
    }
}
