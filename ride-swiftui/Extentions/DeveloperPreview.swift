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
    
    let mockUser = User(uid: NSUUID().uuidString, fullname:"Ms Rahman", email: "msrs@gmail.com", coordinates: GeoPoint(latitude: 40.75, longitude: 73.99), homeLocation: nil, workLocation: nil, accounttype: .passenger)
}
