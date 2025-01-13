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

// MARK: - AppSettingsManager

class AppSettingsManager: ObservableObject {
    
    // MARK: - AppStorage Backing Properties
    
    @AppStorage("WeatherAppTheme") private var storedAppTheme: String = AppTheme.forest.rawValue
    @AppStorage("WeatherAppUnits") private var storedAppUnits: String = AppUnits.metric.rawValue
    
    // MARK: - Published Properties
    
    @Published private(set) var appTheme: AppTheme = .forest
    @Published private(set) var appUnits: AppUnits = .metric
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init() {
        
        setupPublishedVars()
        setupBindings()
        
    }
    
    // MARK: - Private Methods
    
    private func setupPublishedVars() {
        
        self.appTheme = AppTheme(rawValue: storedAppTheme) ?? .forest
        self.appUnits = AppUnits(rawValue: storedAppUnits) ?? .metric
        
    }
    
    private func setupBindings() {
        $appTheme
            .map { $0.rawValue }
            .sink { [weak self] newValue in
                self?.storedAppTheme = newValue
            }
            .store(in: &cancellables)
        
        $appUnits
            .map { $0.rawValue }
            .sink { [weak self] newValue in
                self?.storedAppUnits = newValue
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Methods
    
    func setTheme(_ theme: AppTheme) {
        appTheme = theme
    }
    
    func setUnits(_ units: AppUnits) {
        appUnits = units
    }
}
