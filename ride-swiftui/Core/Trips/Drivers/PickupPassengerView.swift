//
//  PickupPassengerView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/17/23.
//

import SwiftUI

struct PickupPassengerView: View {
    
    let trip: Trip
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            VStack {
                HStack {
                    Text("Pickup \(trip.passengerName) at \(trip.pickupLocationName)")
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 44)
                    
                    Spacer()
                    
                    VStack {
                        Text("10")
                            .bold()
                        
                        Text("min")
                            .bold()
                    }
                    .frame(width: 56, height: 56)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    
                    
                }
                .padding()
                
                Divider()
            }
            
            VStack {
                HStack {
                    Image("profile-image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading,spacing: 4) {
                        Text(trip.passengerName)
                            .fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(.systemYellow))
                                .imageScale(.small)
                            
                            Text("4.9")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 6) {
                        Text("Earnings")
                            .foregroundColor(.gray)
                        
                        Text("\(trip.tripCost.toCurrency())")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    
                }
            
                Divider()
            }
            .padding()
            
            
            Button {
                viewModel.cancellTripAsDriver()
                
            } label: {
                Text("CANCEL TRIP")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width-32,height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }

        }
        .padding(.bottom,24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct PickupPassengerView_Previews: PreviewProvider {
    static var previews: some View {
        PickupPassengerView(trip: dev.mockTrip)
    }
}
