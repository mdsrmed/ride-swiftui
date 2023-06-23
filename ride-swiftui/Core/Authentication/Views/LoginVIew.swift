//
//  LoginVIew.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/23/23.
//

import SwiftUI

struct LoginVIew: View {
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack {
                
                // image and title
                
                VStack {
                    // image
                    Image("ride-image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(10)
                        .padding(.top,20)
                    
                    Text("Ride")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                
                //input fields
                
                VStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Email Address")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.footnote)
                        
                        TextField("name@example.com", text: $email)
                            .foregroundColor(.green)
                        
                        Rectangle()
                            .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Password")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.footnote)
                        
                        TextField("Enter your password", text: $password)
                            .foregroundColor(.green)
                            
                        
                        Rectangle()
                            .foregroundColor(Color(.init(white: 1, alpha: 0.3)))
                            .frame(width: UIScreen.main.bounds.width - 32, height: 0.7)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                Button {
                    
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 13,weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        
                       
                       
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical)

                
                //social signin view
                
                //sign in button
                
                Button {
                    
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                            .font(.headline)
                        
                        
                    }
                    .frame(width: UIScreen.main.bounds.width-32,height: 50)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.vertical)
                    .shadow(color: .gray,radius: 5)
                }

                Spacer()
                //sign up button
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Don't have an account")
                            .font(.system(size: 14))
                        
                        Text("Sign Up")
                            .font(.system(size:14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                }
               

            }
        }
    }
}

struct LoginVIew_Previews: PreviewProvider {
    static var previews: some View {
        LoginVIew()
    }
}
