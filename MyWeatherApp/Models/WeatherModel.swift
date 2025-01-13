//
//  WeatherModel.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let coord: Coords?
    let weather: [Weather]?
    let main: MainTemps?
    let dt: Int?
    let name: String?
    var date: Date?
}

// MARK: - Main
struct MainTemps: Codable {
    let temp, tempMin, tempMax: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Coords
struct Coords: Codable {
    let lat, lon: Double
}

// MARK: - Weather
struct Weather: Codable {
    let main, description: String?
}

// MARK: - City Weather

struct CityWeather: Codable {
    let city: String
    let weather: WeatherModel
}
