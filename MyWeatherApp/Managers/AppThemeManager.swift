//
//  AppThemeManager.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import SwiftUI

enum AppTheme: String {
    case forest = "FOREST"
    case sea = "SEA"
}

class AppThemeManager: ObservableObject {
    
    @AppStorage("WeatherAppTheme") private(set) var appTheme: AppTheme = .forest
    
    func setTheme(theme: AppTheme) {
        appTheme = theme
    }
    
}
