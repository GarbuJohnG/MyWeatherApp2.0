//
//  SettingsView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var weatherVM: WeatherVM
    @EnvironmentObject var appSettings: AppSettingsManager
    
    var body: some View {
        
        let condition = weatherVM.weather?.weather?.first?.main ?? ""
        let currentTheme = appSettings.appTheme
        
        VStack(spacing: 0) {
            
            VStack(alignment: .leading) {
                
                Text("Settings")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                    .padding(.top, 30)
                
                // MARK: - Theme Selection
                
                Text("Select Theme")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                    .shadow(radius: 3)
                
                Picker("Theme", selection: Binding(
                    get: { appSettings.appTheme },
                    set: { newTheme in
                        appSettings.setTheme(newTheme)
                    }
                )) {
                    Text("Forest")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .tag(AppTheme.forest)
                    
                    Text("Sea")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .tag(AppTheme.sea)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // MARK: - Units Selection
                
                Text("Select Units")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                    .shadow(radius: 3)
                
                Picker("Units", selection: Binding(
                    get: { appSettings.appUnits },
                    set: { newUnits in
                        appSettings.setUnits(newUnits)
                    }
                )) {
                    Text("Metric (° C)")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .tag(AppUnits.metric)
                    
                    Text("Imperial (° F)")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .tag(AppUnits.imperial)
                }
                .pickerStyle(SegmentedPickerStyle())
                
            }
            .padding(.horizontal, 30)
            
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
        .animation(.easeInOut, value: appSettings.appTheme)
        
    }
    
}

//#Preview {
//    SettingsView()
//}
