//
//  MyWeatherAppApp.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import SwiftUI

@main
struct MyWeatherAppApp: App {
    
    @StateObject var networkStatus = NetworkStatus()
    @StateObject var locationManager = LocationManager()
    @StateObject var appSettingsManager = AppSettingsManager()
    @StateObject var weatherVM = WeatherVM(weatherService: WeatherService())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkStatus)
                .environmentObject(locationManager)
                .environmentObject(appSettingsManager)
                .environmentObject(weatherVM)
        }
    }
    
}
