//
//  WeatherVMTests.swift
//  MyWeatherAppTests
//
//  Created by John Gachuhi on 09/01/2025.
//

import XCTest
import Combine
import CoreLocation
@testable import MyWeatherApp

final class WeatherVMTests: XCTestCase {
    
    // Mock WeatherService
    class MockWeatherService: WeatherServiceProtocol {
        var mockWeather: WeatherModel?
        var mockForecast: ForecastModel?
        var shouldFail = false
        
        func fetchWeather(for location: CLLocation) -> AnyPublisher<WeatherModel, Error> {
            if let mockWeather = mockWeather {
                return Just(mockWeather)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        func fetchForecast(for location: CLLocation) -> AnyPublisher<ForecastModel, Error> {
            if shouldFail {
                return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
            }
            if let mockForecast = mockForecast {
                return Just(mockForecast)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
            }
        }
    }
    
    // MARK: - Properties
    
    var viewModel: WeatherVM!
    var weatherService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        weatherService = MockWeatherService()
        viewModel = WeatherVM(weatherService: weatherService)
        cancellables = []
    }
    
    override func tearDown() {
        weatherService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    // MARK: - Test for Offline Data
    
    func testLoadOfflineData() throws {
        // Arrange
        let mockWeather = WeatherModel(
            weather: [Weather(main: "Clear", description: "Sunny")],
            main: MainTemps(temp: 20.0, tempMin: 18.0, tempMax: 22.0),
            dt: 1234567890,
            name: "TestCity"
        )
        
        let mockForecast = ForecastModel(
            list: [
                ForecastList(
                    dt: 1234567891,
                    main: MainTemps(temp: 25.0, tempMin: 24.0, tempMax: 26.0),
                    weather: [Weather(main: "Clouds", description: "Partly Cloudy")],
                    dtTxt: "2025-01-10 12:00:00"
                )
            ],
            city: City(name: "TestCity", country: "TC")
        )
        
        UserDefaultsManager.shared.saveWeather(mockWeather)
        UserDefaultsManager.shared.saveForecast(mockForecast)
        
        // Act
        viewModel.loadOfflineData()
        
        // Assert
        XCTAssertEqual(viewModel.weather?.name, "TestCity")
        XCTAssertEqual(viewModel.fiveDayForecast?.count, 1)
        XCTAssertEqual(viewModel.fiveDayForecast?.first?.main, "Clouds")
    }
    
    // MARK: - Test for Fetch Weather Success
    
    func testFetchWeatherSuccess() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Weather Success")
        let mockWeather = WeatherModel(
            weather: [Weather(main: "Rain", description: "Light Rain")],
            main: MainTemps(temp: 15.0, tempMin: 14.0, tempMax: 16.0),
            dt: 1234567890,
            name: "TestCity"
        )
        
        weatherService.mockWeather = mockWeather
        
        // Act
        viewModel.fetchWeather(for: CLLocation(latitude: -1.1054, longitude: 37.0126))
        
        // Assert
        viewModel.$weather
            .dropFirst()
            .sink { weather in
                XCTAssertEqual(weather?.name, "TestCity")
                XCTAssertEqual(UserDefaultsManager.shared.fetchWeather()?.name, "TestCity")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchMultipleLocationsWeatherSuccess() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Weather for Multiple Locations Success")
        expectation.expectedFulfillmentCount = 5 // Expect 5 locations to succeed

        let mockWeather = WeatherModel(
            weather: [Weather(main: "Rain", description: "Light Rain")],
            main: MainTemps(temp: 15.0, tempMin: 14.0, tempMax: 16.0),
            dt: 1234567890,
            name: "TestCity"
        )
        
        let locations = [
            CLLocation(latitude: -1.1054, longitude: 37.0126),
            CLLocation(latitude: -1.2863, longitude: 36.8172),
            CLLocation(latitude: -0.7171, longitude: 36.4310),
            CLLocation(latitude: -1.2543, longitude: 36.6816),
            CLLocation(latitude: -4.0437, longitude: 39.6588)
        ]

        weatherService.mockWeather = mockWeather

        // Act
        viewModel.fetchWeatherForLocations(locations)

        // Assert multiple
        let expectations = locations.map { _ in XCTestExpectation(description: "Fetch Weather for a Location") }

        for (index, location) in locations.enumerated() {
            weatherService.fetchWeather(for: location)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        XCTFail("Fetch failed for location \(index): \(error)")
                    }
                }, receiveValue: { weather in
                    XCTAssertEqual(weather.name, "TestCity")
                    expectations[index].fulfill()
                })
                .store(in: &cancellables)
        }

        wait(for: expectations, timeout: 20.0)
        
    }

    
    // MARK: - Test for Fetch Weather Failure
    
    func testFetchWeatherFailure() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Weather Failure")
        weatherService.shouldFail = true
        
        // Act
        viewModel.fetchWeather(for: CLLocation(latitude: -1.1054, longitude: 37.0126))
        
        // Assert
        viewModel.$toastError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                XCTAssertTrue(error?.contains("Failed to fetch weather") ?? false)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Test for Fetch Forecast Success
    
    func testFetchForecastSuccess() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Forecast Success")
        let mockForecast = ForecastModel(
            list: [
                ForecastList(
                    dt: 1234567890,
                    main: MainTemps(temp: 20.0, tempMin: 18.0, tempMax: 22.0),
                    weather: [Weather(main: "Clear", description: "Sunny")],
                    dtTxt: "2025-01-10 12:00:00"
                ),
                ForecastList(
                    dt: 1234567891,
                    main: MainTemps(temp: 22.0, tempMin: 21.0, tempMax: 23.0),
                    weather: [Weather(main: "Clouds", description: "Partly Cloudy")],
                    dtTxt: "2025-01-11 12:00:00"
                )
            ],
            city: City(name: "TestCity", country: "FC")
        )
        
        weatherService.mockForecast = mockForecast
        
        // Act
        viewModel.fetchForecast(for: CLLocation(latitude: -1.1054, longitude: 37.0126))
        
        // Assert
        viewModel.$fiveDayForecast
            .dropFirst()
            .sink { forecast in
                XCTAssertEqual(forecast?.count, 2)
                XCTAssertEqual(forecast?.first?.main, "Clear")
                XCTAssertEqual(UserDefaultsManager.shared.fetchForecast()?.city?.name, "TestCity")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // MARK: - Test for Fetch Forecast Failure
    
    func testFetchForecastFailure() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Fetch Forecast Failure")
        weatherService.shouldFail = true
        
        // Act
        viewModel.fetchForecast(for: CLLocation(latitude: -1.1054, longitude: 37.0126))
        
        // Assert
        viewModel.$toastError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                XCTAssertTrue(error?.contains("Failed to fetch forecast") ?? false)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
