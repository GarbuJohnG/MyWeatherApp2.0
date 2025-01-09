//
//  WeatherServiceProtocol.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import CoreLocation
import Combine

protocol WeatherServiceProtocol {
    func fetchWeather(for location: CLLocation) -> AnyPublisher<WeatherModel, Error>
    func fetchForecast(for location: CLLocation) -> AnyPublisher<ForecastModel, Error>
}
