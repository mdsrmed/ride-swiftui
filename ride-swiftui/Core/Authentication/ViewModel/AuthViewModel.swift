//
//  AuthViewModel.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private let service = UserService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func registerUser(withEmail email: String, password: String, fullname: String){
        guard let location = LocationManager.shared.userLocation else {return}
        
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error {
                print("Failed to sign up with error \(error.localizedDescription)")
                return
            }
            
            //print("User id \(result?.user.uid)")
            guard let firebaseUser = result?.user else {return}
            self.userSession = firebaseUser
            
            let user = User(uid: firebaseUser.uid,
                            fullname: fullname ,
                            email: email,
                            coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                            accounttype: .driver)
            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            
            Firestore.firestore().collection("Users").document(firebaseUser.uid).setData(encodedUser)
            
        }
    }
    
    func signIn(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password){ result,error in
            
            if let error = error {
                print("Failed to sign in with error \(error.localizedDescription)")
                return
            }
            
            //print("User id \(result?.user.uid)")
            guard let firebaseUser = result?.user else {return}
            self.userSession = firebaseUser
            self.fetchUser()
            
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
    
    func fetchUser(){
        service.$user.sink { user in
            guard let user = user else {return}
            self.currentUser = user
        }
        .store(in: &cancellables)

    }
}
