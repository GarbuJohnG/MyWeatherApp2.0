//
//  WeatherVM.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import CoreLocation
import Combine

class WeatherVM: LocationManagerDelegate, ObservableObject {
    
    // MARK: - Properties
    
    @Published var weather: WeatherModel?
    @Published var forecast: [DailyForecastItem]?
    @Published var toastError: String?
    
    private lazy var locationManager: LocationManager = {
        LocationManager(delegate: self)
    }()
    
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        setupBindings()
        loadOfflineData()
    }
    
    private func setupBindings() {
        locationManager.$currentLocation
            .sink { [weak self] location in
                guard let self = self, let location = location else { return }
                print("New location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Load Offline Content
    
    func loadOfflineData() {
        if let offlineWeather = UserDefaultsManager.shared.fetchWeather() {
            weather = offlineWeather
        }
        if let offlineForecast = UserDefaultsManager.shared.fetchForecast() {
            forecast = offlineForecast
        }
    }
    
    // MARK: - LocationManagerDelegate
    
    func locationManagerDidUpdateLocation(_ location: CLLocation) {
        print("Delegate received new location: \(location.coordinate)")
    }
    
    // MARK: - Get Current Location Weather
    
    private func fetchWeather(for location: CLLocation) {
        weatherService.fetchWeather(for: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch weather: \(error)")
                    self?.toastError = "Failed to fetch weather: \(error)"
                }
            }, receiveValue: { [weak self] weather in
                self?.weather = weather
                UserDefaultsManager.shared.saveWeather(weather)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Get Current Location 5 Day Forecast (Returns forecast for every 3 hours)
    
    private func fetchForecast(for location: CLLocation) {
        weatherService.fetchForecast(for: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch forecast: \(error)")
                    self?.toastError = "Failed to fetch forecast: \(error)"
                }
            }, receiveValue: { [weak self] forecast in
                self?.forecast = forecast
                UserDefaultsManager.shared.saveForecast(forecast)
            })
            .store(in: &cancellables)
    }
    
}
