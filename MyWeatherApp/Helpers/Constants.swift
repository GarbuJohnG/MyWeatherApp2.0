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
    }
    
    // MARK: - Endpoints
    
    struct Endpoints {
        static let weather = "/weather"
        static let forecast = "/forecast"
    }
    
    // MARK: - App Keys
    
    struct Keys {
        static let openWeatherApiKey = "b93acb48084dea0784aff508ca1846fb"
    }
    
}
