//
//  ContentView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appSettings: AppSettingsManager
    @StateObject private var weatherVM = WeatherVM(weatherService: WeatherService())
    
    var body: some View {
        
        TabView {
            
            // MARK: - Home Tab
            
            HomeView(weatherVM: weatherVM, appSettings: appSettings)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            // MARK: - Maps Tab
            
            MapView()
                .tabItem {
                    Label("Maps", systemImage: "map")
                }
            
            // MARK: - Settings Tab
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .tint(Color.white)
        .environmentObject(weatherVM)
        
    }
    
    
}

//#Preview {
//    ContentView()
//}
