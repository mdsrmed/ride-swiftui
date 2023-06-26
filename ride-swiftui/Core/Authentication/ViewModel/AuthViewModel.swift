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
    
    func registerUser(withEmail email: String, password: String, fullname: String){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error {
                print("Failed to sign up with error \(error.localizedDescription)")
                return
            }
            
            //print("User id \(result?.user.uid)")
            self.userSession = result?.user
            
        }
    }
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password){ result,error in
            
            if let error = error {
                print("Failed to sign in with error \(error.localizedDescription)")
                return
            }
            
            //print("User id \(result?.user.uid)")
            self.userSession = result?.user
            
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch let error {
            print(" Failed to sign out with error: \(error.localizedDescription)")
        }
    }
}
