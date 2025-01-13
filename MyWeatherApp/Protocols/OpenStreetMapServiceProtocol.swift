//
//  OpenStreetMapServiceProtocol.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import Foundation
import Combine

protocol OpenStreetMapServiceProtocol {
    func searchLocation(named name: String) -> AnyPublisher<[OSMLocation], Error>
}
