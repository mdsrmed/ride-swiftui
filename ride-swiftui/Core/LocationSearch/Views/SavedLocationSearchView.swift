//
//  SavedLocationSearchView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/29/23.
//

import SwiftUI

struct SavedLocationSearchView: View {
    @StateObject var viewModel = HomeViewModel()
    @State private var text = ""
    let config: SavedLocationViewModel
    
    var body: some View {
        VStack {
//            HStack(spacing: 16){
//                Image(systemName: "arrow.left")
//                    .font(.title2)
//                    .imageScale(.medium)
//                    .padding(.leading)
                
                TextField("Search for a location..", text: $viewModel.queryFragment)
                    .frame(height: 32)
                    .padding(.leading)
                    .background(Color(.systemGray5))
                    .cornerRadius(15)
                    .padding()
                    
//            }
//            .padding(.top)
            
            Spacer()
            
            LocationSearchResultsView(viewModel: viewModel, config: .saveLocation(config))
        }
        .padding(.top)
        .navigationTitle(config.subtitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SavedLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SavedLocationSearchView(config: .home)
        }
    
    }
}
