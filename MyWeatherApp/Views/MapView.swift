//
//  MapView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var weatherVM: WeatherVM
    @EnvironmentObject var appSettings: AppSettingsManager
    
    @StateObject var mapVM = MapViewVM()
    
    var body: some View {
        
        let condition = weatherVM.weather?.weather?.first?.main ?? ""
        let currentTheme = appSettings.appTheme
        
        VStack(spacing: 0) {
            
            WrapperView(view: mapVM.mapView)
                .ignoresSafeArea(edges: .top)
            
            Rectangle()
                .fill(BGColorMapper.bgColor(for: condition, theme: currentTheme))
                .frame(width: UIScreen.main.bounds.width, height: 100)
                .padding(.bottom, -100)
            
        }
        .background {
            BGColorMapper.bgColor(for: condition, theme: currentTheme)
        }
    }
    
}

//#Preview {
//    MapView()
//}
