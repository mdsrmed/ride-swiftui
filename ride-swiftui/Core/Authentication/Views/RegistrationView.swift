//
//  RegistrationView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/23/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            
            VStack(alignment: .leading,spacing: 20) {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                    
                }
               
                Text("Create new accout")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width: 250)
                
                Spacer()
                
                VStack {
                    VStack(spacing: 55) {
                        CustomInputField(text: $fullname, title: "Full Name", placeholder: "Enter you name")
                        CustomInputField(text: $email, title: "Email", placeholder: "name@example.com")
                        CustomInputField(text: $password, title: "Password", placeholder: "Enter password", isSecureField: true)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("SIGN UP")
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
                }
                
                Spacer()
            }
            .foregroundColor(.white)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
