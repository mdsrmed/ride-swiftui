//
//  SideMenuOptionView.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/27/23.
//

import SwiftUI

struct SideMenuOptionView: View {
    let viewModel: SideMenuOptionViewModel
    var body: some View {
        VStack(spacing: 32) {
            ForEach(SideMenuOptionViewModel.allCases){ menu in
                HStack(spacing: 16){
                    Image(systemName: menu.imageName)
                        .font(.title2)
                        .imageScale(.medium)
                  
                    
                    Text(menu.title)
                        .font(.system(size:16, weight: .semibold))
                    
                    Spacer()
                    
                }
            }
        }
        .padding(.leading)
    }
}

struct SideMenuOptionView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionView(viewModel: .trips)
    }
}
