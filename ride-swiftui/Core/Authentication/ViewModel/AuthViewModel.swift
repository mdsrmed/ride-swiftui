//
//  AuthViewModel.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/26/23.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    init(){
        userSession = Auth.auth().currentUser
    }
}
