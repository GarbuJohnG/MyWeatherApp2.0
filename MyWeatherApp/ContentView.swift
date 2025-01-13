//
//  ContentView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var appSettings: AppSettingsManager
    @EnvironmentObject var networkStatus: NetworkStatus
    @EnvironmentObject var weatherVM: WeatherVM
    
    @State var showLocationAlert: Bool = false
    
    var body: some View {
        
        ZStack {
            
            TabView {
                
                // MARK: - Home Tab
                
                HomeView(weatherVM: weatherVM, appSettings: appSettings)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                // MARK: - Maps Tab
                
                FavoritesView(weatherVM: weatherVM, appSettings: appSettings)
                    .tabItem {
                        Label("Favorites", systemImage: "star.fill")
                    }
                
                // MARK: - Settings Tab
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            
            if !networkStatus.isConnected {
                
                withAnimation(.easeInOut) {
                    VStack {
                        
                        ConnectivityBanner()
                            .frame(width: UIScreen.main.bounds.width, height: 40)
                        
                        Spacer()
                        
                    }
                }
                
            }
    
        }
        .tint(Color.white)
        .onChange(of: locationManager.showError ?? false) { show in
            if show {
                showLocationAlert = true
            }
        }
        .alert("Location Error", isPresented: $showLocationAlert) {
            Button("Settings", role: .destructive) {
                openAppSettings()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(locationManager.locationError ?? "")
        }
        
    }
    
    private func openAppSettings() {
        if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettingsURL) {
                UIApplication.shared.open(appSettingsURL)
            }
        }
    }
    
    
}

//#Preview {
//    ContentView()
//}
