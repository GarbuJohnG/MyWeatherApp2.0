//
//  Constants.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation

struct Constants {
    
    // MARK: - URLs
    
    struct URLs {
        static let baseUrl = "https://api.openweathermap.org/data/2.5"
        static let osmUrl = "https://nominatim.openstreetmap.org"
    }
    
    // MARK: - Endpoints
    
    struct Endpoints {
        static let weather = "/weather"
        static let forecast = "/forecast"
        
        static let osmSearch = "/search"
    }
    
    // MARK: - App Keys
    
    struct Keys {
        static let openWeatherApiKey = "b93acb48084dea0784aff508ca1846fb"
    }
    
}
