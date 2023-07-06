//
//  LocationSearchResultsView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/29/23.
//

import SwiftUI


struct LocationSearchResultsView: View {
        @StateObject var viewModel: HomeViewModel
        let config: LocationResultsViewConfig
        var body: some View {
            ScrollView{
                VStack{
                    ForEach(viewModel.results, id: \.self){ result in
                        
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    viewModel.selectLocation(result, config: config)
                                    //mapState = .locationSelected
                                }
                                
                            }
                    }
                }
            }
        }
    }



