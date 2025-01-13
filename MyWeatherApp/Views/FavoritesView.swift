//
//  FavoritesView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 12/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var weatherVM: WeatherVM
    @EnvironmentObject var appSettings: AppSettingsManager
    
    var body: some View {
        
        let condition = weatherVM.weather?.weather?.first?.main ?? ""
        let currentTheme = appSettings.appTheme
        
        VStack(spacing: 0) {
            
            VStack{
                
                HStack {
                    
                    Text("Favorites")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(radius: 3)
                    
                    Spacer()
                    
                }
                .padding([.leading,.top], 30)
                
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
    }
    
}

//#Preview {
//    FavoritesView()
//}
