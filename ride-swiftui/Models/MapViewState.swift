//
//  MapViewState.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/13/23.
//

import Foundation

enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case tripRequested
    case tripRejected
    case tripAccepted
    case tripCancelledByPassenger
    case tripCancelledByDriver
}
