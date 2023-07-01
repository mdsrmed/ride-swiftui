//
//  User.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/27/23.
//

import Foundation
import Firebase

enum accoutType: Int,Codable {
    case passenger
    case driver
}

struct User: Codable {
    let uid: String
    let fullname: String
    let email: String
    var coordinates: GeoPoint
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
    var accounttype: accoutType
    
    
}
