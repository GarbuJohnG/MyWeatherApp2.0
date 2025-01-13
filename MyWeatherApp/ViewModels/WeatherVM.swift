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
    @Published var citySpecificWeather: WeatherModel?
    @Published var forecast: ForecastModel?
    @Published var fiveDayForecast: [DailyForecastItem]?
    @Published var multipleCityWeather: [WeatherModel] = []
    @Published var toastError: String?
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var citySpecificFetched: Bool = false
    @Published private(set) var cityMultipleFetched: Bool = false
    
    private var currentLocation: CLLocation?
    
    private lazy var locationManager: LocationManager = {
        LocationManager(delegate: self)
    }()
    
    private let weatherService: WeatherServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
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
                makeAllWeatherCalls(location: location)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Make Network Calls
    
    func makeAllWeatherCalls(location: CLLocation) {
        fetchWeather(for: location)
        fetchForecast(for: location)
    }
    
    func refreshAllWeatherData() {
        if let location = currentLocation {
            makeAllWeatherCalls(location: location)
        }
    }
    
    // MARK: - Load Offline Content
    
    func loadOfflineData() {
        if let offlineWeather = UserDefaultsManager.shared.fetchWeather() {
            weather = offlineWeather
        }
        if let offlineForecast = UserDefaultsManager.shared.fetchForecast() {
            forecast = offlineForecast
            fiveDayForecast = getMiddayWeather(from: offlineForecast)
        }
        
    }
    
    // MARK: - LocationManagerDelegate
    
    func locationManagerDidUpdateLocation(_ location: CLLocation) {
        print("Delegate received new location: \(location.coordinate)")
        currentLocation = location
    }
    
    // MARK: - Get Current Location Weather
    
    func fetchWeather(for location: CLLocation, specific: Bool? = false) {
        
        isLoading = true
        citySpecificFetched = false
        
        weatherService.fetchWeather(for: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch weather: \(error)")
                    self?.toastError = "Failed to fetch weather: \(error)"
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] weather in
                self?.isLoading = false
                if specific! {
                    self?.citySpecificWeather = weather
                    self?.citySpecificFetched = true
                } else {
                    var datedWeather = weather
                    datedWeather.date = Date()
                    self?.weather = datedWeather
                    UserDefaultsManager.shared.saveWeather(weather)
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Get Multiple Location Weather
    
    func fetchWeatherForLocations(_ locations: [CLLocation]) {
        
        isLoading = true
        cityMultipleFetched = false
        
        guard !locations.isEmpty else { return }
        
        let weatherPublishers = locations.map { location in
            weatherService.fetchWeather(for: location)
        }
        
        Publishers.MergeMany(weatherPublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch weather data: \(error)")
                }
            }, receiveValue: { [weak self] weatherModels in
                self?.isLoading = false
                self?.cityMultipleFetched = true
                self?.multipleCityWeather = weatherModels
                print("Fetched Weather Results: \(weatherModels)")
            })
            .store(in: &cancellables)
        
    }
    
    // MARK: - Get Current Location 5 Day Forecast (Returns forecast for every 3 hours)
    
    func fetchForecast(for location: CLLocation) {
        
        isLoading = true
        
        weatherService.fetchForecast(for: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch forecast: \(error)")
                    self?.toastError = "Failed to fetch forecast: \(error)"
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] forecast in
                self?.isLoading = false
                var datedforecast = forecast
                datedforecast.date = Date()
                self?.forecast = datedforecast
                UserDefaultsManager.shared.saveForecast(forecast)
                if let fiveDayForecast = self?.getMiddayWeather(from: forecast) {
                    self?.fiveDayForecast = fiveDayForecast
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Convert the 40 3 hour records to 5 days of weather at noon
    
    func getMiddayWeather(from forecastResponse: ForecastModel) -> [DailyForecastItem] {
        
        var middayWeather: [DailyForecastItem] = []
        let middayHour = "12:00:00"
        for forecastInfo in forecastResponse.list ?? [] {
            if let forecastDate = forecastInfo.dtTxt, forecastDate.contains(middayHour) {
                let main = forecastInfo.weather?.first?.main ?? "Unknown"
                let description = forecastInfo.weather?.first?.description ?? "Unknown"
                let temperature = forecastInfo.main?.temp ?? 0.0
                middayWeather.append(DailyForecastItem(date: forecastDate, main: main, description: description, temperature: temperature))
            }
        }
        return middayWeather
    }
    
}
