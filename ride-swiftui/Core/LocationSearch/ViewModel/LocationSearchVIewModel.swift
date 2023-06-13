//
//  LocationSearchVIewModel.swift
//  ride-swiftui
//
//  Created by Md Shohidur Rahman on 6/12/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion()]
    @Published var selectedLocation: String?
    
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = ""{
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycles
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
        
    }
    
    //MARK: - Helpers
    
    func selectLocation(_ location: String){
        self.selectedLocation = location
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
