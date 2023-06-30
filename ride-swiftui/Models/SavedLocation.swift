//
//  SavedLocation.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/30/23.
//

import Foundation
import Firebase

struct SavedLocation: Codable {
    let title: String
    let address: String
    let coordinates: GeoPoint
}
