//
//  WeatherIconMapper.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import SwiftUI

// MARK: - WeatherCondition Protocol

protocol WeatherCondition {
    var icon: Image { get }
}

// MARK: - Weather Conditions Enum

enum WeatherType: String, WeatherCondition {
    
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
    
    var icon: Image {
        switch self {
        case .clear:
            return Image(systemName: "sun.max.fill")
        case .clouds:
            return Image(systemName: "cloud.fill")
        case .rain:
            return Image(systemName: "cloud.rain.fill")
        case .snow:
            return Image(systemName: "cloud.snow.fill")
        }
    }
    
}

// MARK: - WeatherIconMapper

struct WeatherIconMapper {
    
    static func icon(for condition: String) -> Image {
        if let weatherType = WeatherType(rawValue: condition) {
            return weatherType.icon
        } else {
            return Image(systemName: "questionmark")
        }
    }
    
}


/*
 
 let condition = "Clear"
 let icon = WeatherIconMapper.icon(for: condition)
 
 */
