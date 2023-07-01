//
//  SavedLocatonVeiwModel.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/29/23.
//

import Foundation


enum SavedLocationViewModel: Int,CaseIterable,Identifiable {
    case home
    case work
     
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .work: return "Work"
            
        }
    }
    
    var subtitle: String {
        switch self {
        case .home: return "Add Home"
        case .work: return "Add Work"
            
        }
    }
    
    
    var imageName: String {
        switch self {
        case .home: return "house.circle.fill"
        case .work: return "archivebox.circle.fill"
        }
    }
    
    
    var databaseKey: String {
        switch self {
        case .home: return "homeLocation"
        case .work: return "workLocation"
        }
    }
    
    var id: Int {
        return self.rawValue
    }
    
    func subtitle(for user: User) -> String {
        switch self {
        case .home:
            if let homeLocation = user.homeLocation{
                return homeLocation.title
            } else {
                return "Add Home"
            }
            
        case .work:
            if let workLocation = user.workLocation{
                return workLocation.title
            } else {
                return "Add Work"
            }
        
        }
        
      
        
    
    }
}
