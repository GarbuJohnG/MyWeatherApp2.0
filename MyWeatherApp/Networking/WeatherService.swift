//
//  WeatherService.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

final class WeatherService: WeatherServiceProtocol {
    
    // MARK: - Fetch the weather for specific location
    
    func fetchWeather(for location: CLLocation) -> AnyPublisher<WeatherModel, any Error> {
    
        let urlStr = Constants.URLs.baseUrl +
        Constants.Endpoints.weather +
        "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)" +
        "&appid=\(Constants.Keys.openWeatherApiKey)"
        
        return NetworkManager.shared.fetchData(urlStr: urlStr, responseType: WeatherModel.self)
        
    }
    
    // MARK: - Fetch the forecast for specific location
    
    func fetchForecast(for location: CLLocation) -> AnyPublisher<ForecastModel, any Error> {
        
        let urlStr = Constants.URLs.baseUrl +
        Constants.Endpoints.forecast +
        "?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)" +
        "&appid=\(Constants.Keys.openWeatherApiKey)"
        
        return NetworkManager.shared.fetchData(urlStr: urlStr, responseType: ForecastModel.self)
        
    }
    
}
