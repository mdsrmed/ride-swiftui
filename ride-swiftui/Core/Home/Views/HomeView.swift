//
//  HomeView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/11/23.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchView = false
    @State private var mapState = MapViewState.noInput
    
    var body: some View {
        ZStack(alignment: .top){
            RideMapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()
            
            if mapState == .searchingForLocation {
                LocationSearchView(mapState: $mapState)
            }else if mapState == .noInput {
                LocationSearchActivationView()
                    .padding(.top, 72)
                    .onTapGesture {
                        withAnimation(.spring()){
                            mapState = .searchingForLocation
                        }
                    }
            }
            
            MapViewActionButton(mapState: $mapState)
                .padding(.leading)
                .padding(.top, 4)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
