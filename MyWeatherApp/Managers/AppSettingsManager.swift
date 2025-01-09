//
//  AppSettingsManager.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import SwiftUI

// MARK: - Units Enum

enum AppUnits: String {
    case imperial = "imperial"
    case metric = "metric"
}

// MARK: - AppTheme Enum

enum AppTheme: String {
    case forest = "FOREST"
    case sea = "SEA"
}

// MARK: - AppThemeManager

class AppSettingsManager: ObservableObject {
    
    // MARK: - Properties
    
    @AppStorage("WeatherAppTheme") private(set) var appTheme: AppTheme = .forest
    @AppStorage("WeatherAppUnits") private(set) var appUnits: AppUnits = .metric
    
    // MARK: - Methods
    
    func setTheme(_ theme: AppTheme) {
        appTheme = theme
    }
    
    func setUnits(_ units: AppUnits) {
        appUnits = units
    }
    
}

