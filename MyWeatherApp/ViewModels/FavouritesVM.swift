//
//  FavouritesVM.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 13/01/2025.
//

import Foundation

class FavouritesVM: ObservableObject {
    
    private var weatherVM: WeatherVM
    private var appSettings: AppSettingsManager
    
    // MARK: - Initializer
    
    init(weatherVM: WeatherVM, appSettings: AppSettingsManager) {
        
        self.weatherVM = weatherVM
        self.appSettings = appSettings
        
    }
    
    // MARK: - Convert temperature from Kelvin
    
    func convertTemperature(_ temperature: Double, to units: AppUnits) -> Double {
        
        switch units {
        case .metric:
            // MARK: - Convert Kelvin to Celsius
            return Double(temperature - 273.15)
        case .imperial:
            // MARK: - Convert Kelvin to Fahrenheit
            return Double((temperature - 273.15) * 9/5 + 32)
        }
        
    }
    
    // MARK: - Convert temperature Function
    
    func convertTemperatureToText(temp: Double) -> String {
        return "\(convertTemperature(temp, to: appSettings.appUnits).roundDouble())° \(appSettings.appUnits == .metric ? "C" : "F")"
    }
    
}
