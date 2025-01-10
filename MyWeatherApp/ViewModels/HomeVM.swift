//
//  HomeVM.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI

class HomeVM: ObservableObject {
    
    // MARK: - Properties
    
    @Published var temperatureText: String = "--°"
    @Published var minTempText: String = "--°"
    @Published var maxTempText: String = "--°"
    @Published var weatherConditionText: String = "Loading..."
    
    private var weatherVM: WeatherVM
    private var appSettings: AppSettingsManager
    
    // MARK: - Initializer
    
    init(weatherVM: WeatherVM, appSettings: AppSettingsManager) {
        
        self.weatherVM = weatherVM
        self.appSettings = appSettings
        setupBindings()
        
    }
    
    // MARK: - Setup Bindings
    
    private func setupBindings() {
        
        weatherVM.$weather
            .combineLatest(appSettings.$appUnits)
            .sink { [weak self] weather, units in
                guard let self = self else { return }
                self.updateTemperatureAndCondition(weather: weather, units: units)
            }
            .store(in: &weatherVM.cancellables)
        
    }
    
    // MARK: - Update Temperature and Condition
    
    private func updateTemperatureAndCondition(weather: WeatherModel?, units: AppUnits) {
        
        guard let weather = weather else {
            temperatureText = "--°"
            minTempText = "--°"
            maxTempText = "--°"
            weatherConditionText = "Loading..."
            return
        }
        
        // MARK: - Convert temperature based on the selected units
        
        let temperature = weather.main?.temp ?? 0.0
        let mintemp = weather.main?.tempMin ?? 0.0
        let maxtemp = weather.main?.tempMax ?? 0.0
        
        temperatureText = "\(convertTemperature(temperature, to: units))° \(units == .metric ? "C" : "F")"
        minTempText = "\(convertTemperature(mintemp, to: units))° \(units == .metric ? "C" : "F")"
        maxTempText = "\(convertTemperature(maxtemp, to: units))° \(units == .metric ? "C" : "F")"
        
        // MARK: - Update weather condition
        
        let condition = weather.weather?.first?.main ?? "Unknown"
        let location = weather.name ?? "Unknown Location"
        weatherConditionText = "\(condition) in \(location)"
        
    }
    
    private func convertTemperature(_ temperature: Double, to units: AppUnits) -> Int {
        
        switch units {
        case .metric:
            // MARK: - Convert Kelvin to Celsius
            return Int(temperature - 273.15)
        case .imperial:
            // MARK: - Convert Kelvin to Fahrenheit
            return Int((temperature - 273.15) * 9/5 + 32)
        }
        
    }

}
