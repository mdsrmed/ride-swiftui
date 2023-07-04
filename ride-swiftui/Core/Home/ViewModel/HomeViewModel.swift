//
//  HomeViewModel.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/1/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine


class HomeViewModel: ObservableObject {
    
    @Published var drivers = [User]()
    private let service = UserService.shared
    var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        fetchDrivers()
    }
    
    func fetchDrivers(){
        Firestore.firestore().collection("users").whereField("accountType", isEqualTo: accoutType.driver.rawValue)
            .getDocuments { snapshot , _ in
                guard let documents = snapshot?.documents else {return}
                let drivers = documents.compactMap({try?  $0.data(as: User.self)})
                self.drivers = drivers
            }
    }
    
    func fetchUser(){
        service.$user.sink { user in
            guard let user = user else {return}
            self.currentUser = user
            guard user.accounttype == .passenger else {return}
            self.fetchDrivers()
        }
        .store(in: &cancellables)
   
    }
    
}
