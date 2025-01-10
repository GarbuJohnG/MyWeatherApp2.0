//
//  UserDefaultsManager.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    private init() {}

    private let weatherKey = "offlineWeather"
    private let forecastKey = "offlineForecast"

    // MARK: - Save Weather Data
    
    func saveWeather(_ weather: WeatherModel) {
        do {
            let data = try JSONEncoder().encode(weather)
            UserDefaults.standard.set(data, forKey: weatherKey)
        } catch {
            print("Failed to encode WeatherModel: \(error)")
        }
    }

    // MARK: - Fetch Weather Data
    
    func fetchWeather() -> WeatherModel? {
        guard let data = UserDefaults.standard.data(forKey: weatherKey) else { return nil }
        do {
            return try JSONDecoder().decode(WeatherModel.self, from: data)
        } catch {
            print("Failed to decode WeatherModel: \(error)")
            return nil
        }
    }

    // MARK: - Save Forecast Data
    
    func saveForecast(_ forecast: ForecastModel) {
        do {
            let data = try JSONEncoder().encode(forecast)
            UserDefaults.standard.set(data, forKey: forecastKey)
        } catch {
            print("Failed to encode forecast data: \(error)")
        }
    }

    // MARK: - Fetch Forecast Data
    
    func fetchForecast() -> ForecastModel? {
        guard let data = UserDefaults.standard.data(forKey: forecastKey) else { return nil }
        do {
            return try JSONDecoder().decode(ForecastModel.self, from: data)
        } catch {
            print("Failed to decode forecast data: \(error)")
            return nil
        }
    }
    
}
