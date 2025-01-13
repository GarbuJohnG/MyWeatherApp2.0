//
//  OpenStreetMapsService.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import Combine

class OpenStreetMapService {
    
    // MARK: - Search Location Name for Coordinates
    
    func searchLocation(named placeName: String)  -> AnyPublisher<[OSMLocation], any Error> {
        
        let urlStr = Constants.URLs.osmUrl + Constants.Endpoints.osmSearch + "?q=\(placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&format=json"

        return NetworkManager.shared.fetchData(urlStr: urlStr, responseType: [OSMLocation].self)
        
    }
    
}

