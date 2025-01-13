//
//  WeatherBgImageMapper.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI

// MARK: - WeatherImageMapper

struct WeatherImageMapper {
    
    static func image(for condition: String, theme: AppTheme) -> Image {
        
        // MARK: - Match the weather condition to a WeatherType
        guard let weatherType = WeatherType(rawValue: condition) else {
            return Image("blank")
        }
        
        // MARK: - Map the weather condition to an image based on the selected theme
        
        switch theme {
        case .forest:
            return forestThemeImage(for: weatherType)
        case .sea:
            return seaThemeImage(for: weatherType)
        }
    }
    
    private static func forestThemeImage(for type: WeatherType) -> Image {
        switch type {
        case .clear:
            return Image("forest_sunny")
        case .clouds:
            return Image("forest_cloudy")
        case .rain:
            return Image("forest_rainy")
        case .snow:
            return Image("forest_rainy")
        }
    }
    
    private static func seaThemeImage(for type: WeatherType) -> Image {
        switch type {
        case .clear:
            return Image("sea_sunny")
        case .clouds:
            return Image("sea_cloudy")
        case .rain:
            return Image("sea_rainy")
        case .snow:
            return Image("sea_rainy")
        }
    }
}
