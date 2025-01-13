//
//  FavoritesView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 12/01/2025.
//

import SwiftUI
import CoreLocation

struct FavoritesView: View {
    
    @EnvironmentObject var weatherVM: WeatherVM
    @EnvironmentObject var appSettings: AppSettingsManager
    
    @State private var hasAppeared: Bool = false
    @State private var showSearch: Bool = false
    @State private var showLoading: Bool = false
    @State private var favLocations: [CityWeather]?
    
    @StateObject private var favouritesVM: FavouritesVM
    
    init(weatherVM: WeatherVM, appSettings: AppSettingsManager) {
        _favouritesVM = StateObject(wrappedValue: FavouritesVM(weatherVM: weatherVM, appSettings: appSettings))
    }
    
    var body: some View {
        
        let condition = weatherVM.weather?.weather?.first?.main ?? ""
        let currentTheme = appSettings.appTheme
        
        NavigationView {
            
            VStack {
                
                VStack(spacing: 0) {
                    
                    VStack{
                        
                        HStack {
                            
                            Text("Favorites")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .shadow(radius: 3)
                            
                            Button {
                                showSearch.toggle()
                            } label: {
                                Text("Add +")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .disabled(showLoading)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing)
                            
                            Spacer()
                            
                        }
                        .padding([.leading,.top], 30)
                        
                    }
                    
                    if showLoading {
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.top, 50)
                        
                    } else {
                        favCitiesWeatherView(condition, currentTheme)
                            .refreshable {
                                fetchMultipleCityWeather()
                            }
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(BGColorMapper.bgColor(for: condition, theme: currentTheme))
                        .frame(width: UIScreen.main.bounds.width, height: 100)
                        .padding(.bottom, -100)
                    
                }
                .background {
                    BGColorMapper.bgColor(for: condition, theme: currentTheme)
                        .ignoresSafeArea()
                }
                .fullScreenCover(isPresented: $showSearch) {
                    PopupSearchView(isPresented: $showSearch, selectedAction: { location in
                        processLocation(location: location)
                    })
                }
                .onChange(of: weatherVM.isLoading) { loading in
                    showLoading = loading
                }
                .onChange(of: weatherVM.citySpecificFetched) { fetched in
                    if fetched {
                        if let cityWeather = weatherVM.citySpecificWeather {
                            favLocations?.append(CityWeather(city: cityWeather.name ?? "", weather: cityWeather))
                            UserDefaultsManager.shared.saveCityWeather(favLocations ?? [])
                        }
                    }
                }
                .onChange(of: weatherVM.cityMultipleFetched) { fetched in
                    if fetched {
                        favLocations?.removeAll()
                        for each in weatherVM.multipleCityWeather {
                            favLocations?.append(CityWeather(city: each.name ?? "", weather: each))
                        }
                        UserDefaultsManager.shared.saveCityWeather(favLocations ?? [])
                    }
                }
                .onAppear {
                    guard !hasAppeared else { return }
                    hasAppeared = true
                    fetchMultipleCityWeather()
                }
                
            }
        }
    
    }
    
    // MARK: - Favorite Cities Weather View
    
    func favCitiesWeatherView(_ condition: String, _ currentTheme: AppTheme) -> some View {
        return ScrollView {
            
            Color.clear
                .frame(height: 30)
            
            if let locations = favLocations, locations.count > 0 {
                
                ForEach(locations, id: \.city) { location in
                    
                    NavigationLink(destination: MapView(cityWeather: location)) {
                        
                        HStack {
                            
                            Text(location.city)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.leading, 10)
                            
                            Spacer()
                            
                            WeatherIconMapper.icon(for: location.weather.weather?.first?.main ?? "")
                                .foregroundStyle(Color.white)
                            
                            Spacer()
                            
                            Text(formatTemperature(temperature: location.weather.main?.temp ?? 0.0))
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)
                                .padding(.trailing, 10)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width - 60, height: 60)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)
                        .padding(.horizontal, 30)
                        
                    }
                
                }
                
            } else {
                
                Text("No favorite locations.\nTap Add to save some.")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.top, 50)
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background {
            BGColorMapper.bgColor(for: condition, theme: currentTheme)
        }
    }
    
    private func formatTemperature(temperature: Double) -> String {
        return favouritesVM.convertTemperatureToText(temp: temperature)
    }
    
    private func processLocation(location: OSMLocation) {
        
        let lat = Double(location.lat) ?? 0.0
        let long = Double(location.lon) ?? 0.0
        let coords = CLLocation(latitude: lat, longitude: long)
        
        weatherVM.fetchWeather(for: coords, specific: true)
        
    }
    
    private func fetchMultipleCityWeather() {
        
        favLocations = UserDefaultsManager.shared.fetchCityWeather()
        
        var locations: [CLLocation] = []
        
        for location in (favLocations ?? []) {
            let lat = Double(location.weather.coord?.lat ?? 0.0)
            let long = Double(location.weather.coord?.lon ?? 0.0)
            let coords = CLLocation(latitude: lat, longitude: long)
            locations.append(coords)
        }
        
        if locations.count > 0 {
            weatherVM.fetchWeatherForLocations(locations)
        }
        
    }
    
}

//#Preview {
//    FavoritesView()
//}
