//
//  MyWeatherAppApp.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import SwiftUI

@main
struct MyWeatherAppApp: App {
    
    @StateObject var locationManager = LocationManager()
    @StateObject var appSettingsManager = AppSettingsManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(appSettingsManager)
        }
    }
    
}
