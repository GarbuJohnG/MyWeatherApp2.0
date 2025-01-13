//
//  LocSearchVMTests.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import XCTest
import Combine
@testable import MyWeatherApp

final class LocSearchVMTests: XCTestCase {
    
    // MARK: - Mock OpenStreetMapService
    
    class MockOpenStreetMapService: OpenStreetMapServiceProtocol {
        var mockLocations: [OSMLocation] = []
        var shouldFail = false
        
        func searchLocation(named name: String) -> AnyPublisher<[OSMLocation], Error> {
            if shouldFail {
                return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
            }
            return Just(mockLocations)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Properties
    
    var viewModel: LocSearchVM!
    var mockService: MockOpenStreetMapService!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockService = MockOpenStreetMapService()
        viewModel = LocSearchVM(osmService: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testLocationSearchSuccess() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Search for locations successfully")
        let mockLocations = [
            OSMLocation(lat: "-1.1054509", lon: "37.0126648", display_name: "Juja, Kiambu, Central Kenya, 01001, Kenya"),
            OSMLocation(lat: "-1.1015227", lon: "37.0158765", display_name: "Juja, Kiambu, Central Kenya, Kenya")
        ]
        mockService.mockLocations = mockLocations
        
        // Act
        viewModel.locationSearch(searchName: "Juja")
        
        // Assert
        viewModel.$locations
            .dropFirst()
            .sink { locations in
                XCTAssertEqual(locations?.count, 2)
                XCTAssertEqual(locations?.first?.display_name, "Juja, Kiambu, Central Kenya, 01001, Kenya")
                XCTAssertEqual(locations?.first?.lat, "-1.1054509")
                XCTAssertEqual(locations?.first?.lon, "37.0126648")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLocationSearchFailure() throws {
        // Arrange
        let expectation = XCTestExpectation(description: "Handle location search failure")
        mockService.shouldFail = true
        
        // Act
        viewModel.locationSearch(searchName: "InvalidLocation")
        
        // Assert
        viewModel.$toastError
            .dropFirst()
            .sink { error in
                XCTAssertNotNil(error)
                XCTAssertTrue(error?.contains("Failed to fetch locations") ?? false)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
    }
}
