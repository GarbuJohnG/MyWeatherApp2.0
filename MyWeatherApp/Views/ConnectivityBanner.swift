//
//  ConnectivityBanner.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 13/01/2025.
//


import SwiftUI

struct ConnectivityBanner: View {

    var body: some View {
        
        ZStack {
            
            Color.red
                .frame(width: UIScreen.main.bounds.width, height: 40)
            
            HStack {
                
                Image(systemName: "globe")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                
                Text("You're are currently offline")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                
            }
            
        }
        
    }
    
}
