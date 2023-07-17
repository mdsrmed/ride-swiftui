//
//  TripRequestView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/15/23.
//

import SwiftUI

struct TripRequestView: View {
    
    @State private var selectedRideType: RideType = .rideX
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    
                    Image(systemName: "chevron.down")
                        .frame(width: 8, height: 8)
                    
                }
                
                VStack (alignment: .leading, spacing:  24){
                    HStack{
                        Text("Current location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(homeViewModel.pickupTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom,10)
                    
                    HStack{
                        if let location = homeViewModel.selectedRideLocation {
                            Text(location.title)
                                .font(.system(size: 16, weight:  .semibold))
                        }
                            
                        
                        Spacer()
                        
                        Text(homeViewModel.dropOffTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }.padding(.leading, 8)
            }.padding()
            
            Divider()
            
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            ScrollView(.horizontal){
                HStack(spacing: 15){
                    ForEach(RideType.allCases){ type in
                        VStack(alignment: .leading,spacing: 1){
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(type.description)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text(homeViewModel.computeTripPrice(forType: type).toCurrency())
                                    .font(.system(size: 14, weight: .semibold))
                            }.padding(10)
                            
                        }
                        .frame(width: 112, height: 140)
                        .foregroundColor(type == selectedRideType ? .white :
                                            Color.theme.primaryTextColor)
                        .background(type == selectedRideType ? .blue :
                                        Color.theme.secondaryBackgroundColor)
                        .scaleEffect(type == selectedRideType ? 1.1 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture{withAnimation(.spring()) {
                            selectedRideType = type
                        }
                        }
                    }
                }
                
            }.padding(.horizontal)
            
            Divider()
                .padding(.horizontal)
            
            HStack(spacing: 12){
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Text("**** 1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName:  "chevron.right")
                    .imageScale(.medium)
                    .padding()
                        
            }
            .frame(height: 50)
            .background(Color.theme.secondaryBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Button {
                homeViewModel.requestTrip()
            } label: {
                Text("CONFIRM TRIP")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width-32,height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }

        }
        .padding(.bottom,24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
    }
}

struct TripRequestView_Previews: PreviewProvider {
    static var previews: some View {
        TripRequestView()
    }
}
