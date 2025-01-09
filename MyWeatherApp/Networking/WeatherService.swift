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
    
    // MARK: - Fetch the weather for specific location
    
    func fetchWeather(for location: CLLocation) -> AnyPublisher<WeatherModel, any Error> {
        
        guard let url = URL(string: Constants.URLs.baseUrl +
                            Constants.Endpoints.weather +
                            "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)") else {
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
    
    func fetchForecast(for location: CLLocation) -> AnyPublisher<ForecastModel, any Error> {
        
        guard let url = URL(string: Constants.URLs.baseUrl +
                            Constants.Endpoints.forecast +
                            "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                // Decode ForecastModel from JSON
                return try JSONDecoder().decode(ForecastModel.self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
}
