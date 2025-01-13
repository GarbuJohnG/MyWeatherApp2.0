//
//  HomeVM.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import Foundation

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
    
    // MARK: - Convert temperature from Kelvin
    
    func convertTemperature(_ temperature: Double, to units: AppUnits) -> Int {
        
        switch units {
        case .metric:
            // MARK: - Convert Kelvin to Celsius
            return Int(temperature - 273.15)
        case .imperial:
            // MARK: - Convert Kelvin to Fahrenheit
            return Int((temperature - 273.15) * 9/5 + 32)
        }
        
    }
    
    // MARK: - Convert temperature Function
    
    func convertTemperatureToText(temp: Double) -> String {
        return "\(convertTemperature(temp, to: appSettings.appUnits))° \(appSettings.appUnits == .metric ? "C" : "F")"
    }
    
    // MARK: - Date Convert Function
    
    // MARK: - Date Convert Function

    func formatDate(dateStr: String) -> String {
        
        let inputDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter
        }()
        
        let outputDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM, yyyy"
            return formatter
        }()
        
        guard let date = inputDateFormatter.date(from: dateStr) else {
            return dateStr
        }
        
        return outputDateFormatter.string(from: date)
        
    }

    
}
