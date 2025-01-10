//
//  AppSettingsManager.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import Combine
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
    
    // MARK: - AppStorage Backing Properties
    
    @AppStorage("WeatherAppTheme") private var storedAppTheme: String = AppTheme.forest.rawValue
    @AppStorage("WeatherAppUnits") private var storedAppUnits: String = AppUnits.metric.rawValue
    
    // MARK: - Published Properties
    
    @Published private(set) var appTheme: AppTheme
    @Published private(set) var appUnits: AppUnits
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init() {
        
        self.appTheme = .forest
        self.appUnits = .metric
        
        $appTheme
            .map { $0.rawValue }
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.storedAppTheme = newValue
            }
            .store(in: &cancellables)
        
        $appUnits
            .map { $0.rawValue }
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.storedAppUnits = newValue
            }
            .store(in: &cancellables)
        
        setSavedValues()
        
    }
    
    private func setSavedValues() {
        
        let initialTheme = AppTheme(rawValue: storedAppTheme) ?? .forest
        let initialUnits = AppUnits(rawValue: storedAppUnits) ?? .metric
        self.appTheme = initialTheme
        self.appUnits = initialUnits
        
    }
    
    // MARK: - Methods
    
    func setTheme(_ theme: AppTheme) {
        appTheme = theme
    }
    
    func setUnits(_ units: AppUnits) {
        appUnits = units
    }
}
