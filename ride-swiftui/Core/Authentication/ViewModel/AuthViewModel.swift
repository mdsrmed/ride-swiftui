//
//  AuthViewModel.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func registerUser(withEmail email: String, password: String, fullname: String){
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error {
                print("Failed to sign up with error \(error.localizedDescription)")
                return
            }
            
            //print("User id \(result?.user.uid)")
            guard let firebaseUser = result?.user else {return}
            self.userSession = firebaseUser
            
            let user = User(uid: firebaseUser.uid, fullname: fullname , email: email)
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
        //guard let uid = self.userSession?.uid else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else {return}
            
            guard let user = try? snapshot.data(as:User.self) else { return }
            
            //print("DEBUG: User is \(user.fullname)")
            //print("DEBUG: Email is \(user.email)")
            
            self.currentUser = user
        }
    }
}
