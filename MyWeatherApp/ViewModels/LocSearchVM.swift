//
//  LocSearchVM.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation

class LocSearchVM: ObservableObject {
    
    @Published private(set) var locations: [OSMLocation]?
    @Published private(set) var toastError: String?
    
    private let osmService = OpenStreetMapService()
    
    // MARK: - Search for a Location Name
    
    func locationSearch(searchName: String) {
        
        osmService.searchLocation(named: searchName) { [weak self] result in
            switch result {
            case .success(let locations):
                for location in locations {
                    print("Coordinates for \(location.display_name):")
                    print("Latitude: \(location.lat), Longitude: \(location.lon)")
                }
                self?.locations = locations
            case .failure(let error):
                print("Error fetching location: \(error.localizedDescription)")
                self?.toastError = "Error fetching location: \(error.localizedDescription)"
            }
        }
        
    }
    
}
