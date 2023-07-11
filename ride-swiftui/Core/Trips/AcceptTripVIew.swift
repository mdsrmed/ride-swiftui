//
//  AcceptTripVIew.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 7/6/23.
//

import SwiftUI
import MapKit

struct AcceptTripVIew: View {
    @State private var region: MKCoordinateRegion
    @EnvironmentObject var viewModel: HomeViewModel
    let trip: Trip
    let annotationItem: RideLocation
    
    init(trip: Trip){
        let center = CLLocationCoordinate2D(latitude: trip.pickupLocation.latitude,
                                            longitude: trip.pickupLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        self.region = MKCoordinateRegion(center: center, span: span)
        self.trip = trip
        self.annotationItem = RideLocation(title: trip.pickupLocationName, coordinate: trip.pickupLocation.toCoordinate())
    }
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            VStack {
                HStack {
                    Text("Would you like to pickup this passenger?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 44)
                    
                    Spacer()
                    
                    VStack {
                        Text("\trip.travelTimeToPassenger")
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
                        
                        Text(trip.tripCost.toCurrency())
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    
                }
            
                Divider()
            }
            .padding()
            
            
            VStack {
                HStack{
                    VStack(alignment: .leading,spacing: 6){
                        Text(trip.pickupLocationName)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(trip.pickupLocationAddress)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    
                    VStack(spacing: 6){
                        Text(trip.distanceToPassenger?.distanceInMilesString() ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("mi")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    
                }
                .padding(.horizontal)
                
                Map(coordinateRegion: $region, annotationItems: [annotationItem]){ item in
                    MapMarker(coordinate: item.coordinate)
                }
                .frame(height: 220)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.5), radius: 10)
                .padding()
                
                Divider()
            }
            
            HStack {
                Button {
                    viewModel.rejectTrip()
                } label: {
                    Text("Reject")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 32, height:  55)
                        .background(Color(.systemRed))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button {
                    viewModel.acceptTrip()
                } label: {
                    Text("Accept")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: (UIScreen.main.bounds.width/2) - 32, height:  55)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                }

            }
            .padding(.top)
            .padding(.horizontal)
            .padding(.bottom,20)
        }
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct AcceptTripVIew_Previews: PreviewProvider {
    static var previews: some View {
        AcceptTripVIew(trip: dev.mockTrip)
    }
}
