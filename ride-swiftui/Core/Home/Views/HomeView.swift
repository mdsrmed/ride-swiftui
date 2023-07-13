//
//  HomeView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/11/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showSideMenu = false
    @State private var showLocationSearchView = false
    @State private var mapState = MapViewState.noInput
    //@EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
                
            } else if let user = authViewModel.currentUser {
                
                NavigationStack {
                    ZStack {
                        if showSideMenu {
                            SideMenuView(user: user)
                        }
                        mapView
                            .offset(x: showSideMenu ? 316 : 0)
                            .shadow(color: showSideMenu ? .black : .clear, radius: 10)
                    }
                    .onAppear {
                        showSideMenu = false
                    }
                }
                
                
            }
        }
    }
}

extension HomeView {
    var mapView: some View {
        ZStack (alignment: .bottom){
            ZStack(alignment: .top){
                RideMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation {
                    LocationSearchView()
                }else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()){
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                MapViewActionButton(mapState: $mapState,
                                    showSideMenu: $showSideMenu)
                .padding(.leading)
                .padding(.top, 4)
            }
            
            if let user = authViewModel.currentUser {
                if user.accountType == .passenger {
                    if mapState == .locationSelected || mapState == .polylineAdded {
                        TripRequestView()
                            .transition(.move(edge: .bottom))
                            
                    } else if mapState == .tripRequested {
                        TripLoadingView()
                    } else if mapState == .tripRejected {
                        
                    } else if mapState == .tripAccepted {
                        TripAcceptedView()
                            .transition(.move(edge: .bottom))
                    }
                } else {
                    if let trip = homeViewModel.trip {
                        AcceptTripVIew(trip: trip)
                            .transition(.move(edge: .bottom))
                }
            }

            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$selectedRideLocation) { location in
            if location != nil {
                self.mapState = .locationSelected
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else { return }
            
            withAnimation(.spring()){
                switch trip.state {
                case .requested:
                    self.mapState = .tripRequested
                case .rejected:
                    self.mapState = .tripRejected
                case .accepted:
                    self.mapState = .tripAccepted
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthViewModel())
    }
}
