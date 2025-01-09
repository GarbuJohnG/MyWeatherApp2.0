//
//  WeatherService.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import CoreLocation
import Combine

final class WeatherService: WeatherServiceProtocol {
    
    // MARK: - Properties
    private let appSettingsManager: AppSettingsManager
    
    // MARK: - Initializer
    init(appSettingsManager: AppSettingsManager) {
        self.appSettingsManager = appSettingsManager
    }
    
    // MARK: - Fetch the weather for specific location
    
    func fetchWeather(for location: CLLocation) -> AnyPublisher<WeatherModel, any Error> {
        
        let units = appSettingsManager.appUnits.rawValue.lowercased()
        
        guard let url = URL(string: Constants.URLs.baseUrl +
                            Constants.Endpoints.weather +
                            "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)" +
                            "&units=\(units)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                // Decode WeatherModel from JSON
                return try JSONDecoder().decode(WeatherModel.self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    // MARK: - Fetch the forecast for specific location
    
    func fetchForecast(for location: CLLocation) -> AnyPublisher<[DailyForecastItem], any Error> {
        
        let units = appSettingsManager.appUnits.rawValue.lowercased()
        
        guard let url = URL(string: Constants.URLs.baseUrl +
                            Constants.Endpoints.forecast +
                            "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)" +
                            "&units=\(units)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                return self.getMiddayWeather(from: data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    // MARK: - Convert the 40 3 hour records to 5 days of weather at noon
    
    private func getMiddayWeather(from jsonData: Data) -> [DailyForecastItem] {
        
        var middayWeather: [DailyForecastItem] = []
        let middayHour = "12:00:00"
        do {
            let forecastResponse = try JSONDecoder().decode(ForecastModel.self, from: jsonData)
            for forecastInfo in forecastResponse.list ?? [] {
                if let forecastDate = forecastInfo.dtTxt, forecastDate.contains(middayHour) {
                    if let date = forecastInfo.dtTxt?.split(separator: " ").first {
                        let main = forecastInfo.weather?.first?.main ?? "Unknown"
                        let description = forecastInfo.weather?.first?.description ?? "Unknown"
                        let temperature = forecastInfo.main?.temp ?? 0.0
                        middayWeather.append(DailyForecastItem(date: forecastDate, main: main, description: description, temperature: temperature))
                    }
                }
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }

        return middayWeather
    }
    
}
