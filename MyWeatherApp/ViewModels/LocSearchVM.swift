//
//  LocSearchVM.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import Combine

class LocSearchVM: ObservableObject {
    
    @Published private(set) var locations: [OSMLocation]?
    @Published private(set) var toastError: String?
    
    private let osmService: OpenStreetMapServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(osmService: OpenStreetMapServiceProtocol) {
        self.osmService = osmService
    }
    
    // MARK: - Search for a Location Name
    
    func locationSearch(searchName: String) {
        
        osmService.searchLocation(named: searchName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch locations: \(error)")
                    self?.toastError = "Failed to fetch locations: \(error)"
                }
            }, receiveValue: { [weak self] locations in
                self?.locations = locations
            })
            .store(in: &cancellables)
        
    }
    
}
