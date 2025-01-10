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
            
            ZStack {
                
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
            
            HStack {
                
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
            
            
            ScrollView {
                
                Color.clear
                    .frame(height: 30)
                
                ForEach(0..<5) { _ in
                    
                    HStack {
                        
                        Text("--")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                        
                        Spacer()
                        
                        WeatherIconMapper.icon(for: "Clear")
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        Text("--")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                            .shadow(radius: 3)
                        
                    }
                    .padding(.horizontal, 30)
                    .frame(width: UIScreen.main.bounds.width, height: 50)
                    
                }
                
            }
            .frame(width: UIScreen.main.bounds.width)
            .background {
                BGColorMapper.bgColor(for: condition, theme: currentTheme)
            }
            
        }
        .ignoresSafeArea()
        
    }
    
}

//#Preview {
//    ContentView()
//        .environmentObject(AppSettingsManager())
//}
