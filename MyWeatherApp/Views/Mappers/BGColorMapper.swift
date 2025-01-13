//
//  BGColorMapper.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI

// MARK: - BGColorMapper

struct BGColorMapper {
    
    static func bgColor(for condition: String, theme: AppTheme) -> Color {
        
        // MARK: - Match the weather condition to a WeatherType
        guard let weatherType = WeatherType(rawValue: condition) else {
            return Color.cloudy
        }
        
        return backgroundColor(for: weatherType, theme: theme)
        
    }
    
    private static func backgroundColor(for type: WeatherType, theme: AppTheme) -> Color {
        switch type {
        case .clear:
            return theme == .forest ? Color.sunny : Color.sea
        case .clouds:
            return Color.cloudy
        case .rain:
            return Color.rainy
        case .snow:
            return Color.rainy
        }
    }
    
}

