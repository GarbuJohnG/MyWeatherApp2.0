//
//  HomeView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var weatherVM: WeatherVM
    @EnvironmentObject var appSettings: AppSettingsManager
    
    @StateObject private var homeVM: HomeVM
    
    init(weatherVM: WeatherVM, appSettings: AppSettingsManager) {
        _homeVM = StateObject(wrappedValue: HomeVM(weatherVM: weatherVM, appSettings: appSettings))
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            let condition = weatherVM.weather?.weather?.first?.main ?? ""
            let currentTheme = appSettings.appTheme
            
            cityWeatherView(condition, currentTheme)
            
            offlineDataDateView(condition, currentTheme)
            
            minMaxTempView(condition, currentTheme)
            
            weatherForecastView(condition, currentTheme)
            
        }
        .ignoresSafeArea()
        
    }
    
    // MARK: - Top Weather View
    
    func cityWeatherView(_ condition: String, _ currentTheme: AppTheme) -> some View {
        return ZStack {
            
            WeatherImageMapper.image(for: condition, theme: currentTheme)
                .resizable()
            
            VStack {
                
                Text(homeVM.temperatureText)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
                Text(homeVM.weatherConditionText)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
            }
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 8/9)
    }
    
    // MARK: - Offline Data Date View
    
    func offlineDataDateView(_ condition: String, _ currentTheme: AppTheme) -> some View {
        
        return VStack {
            if !homeVM.dataLastFetchedText.isEmpty {
                Text(homeVM.dataLastFetchedText)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding()
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background {
            BGColorMapper.bgColor(for: condition, theme: currentTheme)
        }
        
    }
    
    // MARK: - Min Max Temperature View
    
    func minMaxTempView(_ condition: String, _ currentTheme: AppTheme) -> some View {
        return HStack {
            
            VStack {
                
                Text("Min Temp")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
                Text(homeVM.minTempText)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
            }
            
            Spacer()
            
            VStack {
                
                Text("Max Temp")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
                Text(homeVM.maxTempText)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
            }
            
        }
        .padding(.horizontal, 30)
        .frame(width: UIScreen.main.bounds.width, height: 50)
        .background {
            BGColorMapper.bgColor(for: condition, theme: currentTheme)
        }
    }
    
    // MARK: - Weather Forecast View
    
    func weatherForecastView(_ condition: String, _ currentTheme: AppTheme) -> some View {
        return ScrollView {
            
            Color.clear
                .frame(height: 30)
            
            if let forecasts = weatherVM.fiveDayForecast {
                
                ForEach(forecasts) { forecast in
                    
                    HStack {
                        
                        Text(formatDate(dateStr: forecast.date))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                        
                        Spacer()
                        
                        WeatherIconMapper.icon(for: forecast.main)
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        Text(formatTemperature(temperature: forecast.temperature))
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                        
                    }
                    .padding(.horizontal, 30)
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    
                }
            }
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background {
            BGColorMapper.bgColor(for: condition, theme: currentTheme)
        }
    }
    
    private func formatTemperature(temperature: Double) -> String {
        return homeVM.convertTemperatureToText(temp: temperature)
    }
    
    private func formatDate(dateStr: String) -> String {
        return homeVM.formatDate(dateStr: dateStr)
    }
    
}

//#Preview {
//    ContentView()
//        .environmentObject(AppSettingsManager())
//}
