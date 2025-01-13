//
//  ForecastModel.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation

// MARK: - ForecastModel
struct ForecastModel: Codable {
    let list: [ForecastList]?
    let city: City?
    var date: Date?
}

// MARK: - City
struct City: Codable {
    let name, country: String?
}

// MARK: - ForecastList
struct ForecastList: Codable {
    let dt: Int?
    let main: MainTemps?
    let weather: [Weather]?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - DailyForecastItem
struct DailyForecastItem: Identifiable {
    let id = UUID()
    let date, main, description: String
    let temperature: Double
}
