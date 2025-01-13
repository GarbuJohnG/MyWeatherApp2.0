//
//  PopupSearchView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 13/01/2025.
//

import SwiftUI

// MARK: - PopupSearchView
struct PopupSearchView: View {
    
    @EnvironmentObject var weatherVM: WeatherVM
    @EnvironmentObject var appSettings: AppSettingsManager
    @EnvironmentObject var locSearchVM: LocSearchVM
    
    @Binding var isPresented: Bool
    @State private var searchQuery: String = ""
    @FocusState private var isSearchFocused: Bool
    
    let selectedAction: (OSMLocation) -> Void
    
    var body: some View {
        
        ZStack {
            
            let condition = weatherVM.weather?.weather?.first?.main ?? ""
            let currentTheme = appSettings.appTheme
            
            BGColorMapper.bgColor(for: condition, theme: currentTheme)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                
                // MARK: - Search Bar
                
                HStack {
                    
                    TextField("Search locations...", text: $searchQuery)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(8)
                        .focused($isSearchFocused)
                    
                    Button {
                        
                        if !searchQuery.isEmpty {
                            locSearchVM.locationSearch(searchName: searchQuery)
                        }
                        
                    } label: {
                        Text("Search")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 8)
                    
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.leading, 8)
                    
                }
                .padding()
                .background(.clear)
                
                // MARK: - List of Searched Locations
                
                scrollViewContents()
                
                Spacer()
                
            }
        
            if locSearchVM.isLoading {
                VStack {
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                }
            }
        }
        .onAppear {
            isSearchFocused = true
        }
    }
    
    func scrollViewContents() -> some View {
        
        return ScrollView {
            
            VStack(alignment: .leading, spacing: 8) {
                
                if (locSearchVM.locations ?? []).isEmpty {
                    
                    Text("No locations found")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 30)
                    
                } else {
                    
                    ForEach(locSearchVM.locations ?? [], id: \.display_name) { location in
                        
                        Button(action: {
                            
                            print("Selected location: \(location.display_name)")
                            selectedAction(location)
                            isPresented = false
                            
                        }) {
                            HStack {
                                
                                Text(location.display_name)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(Color(.systemGray))
                                
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    
                }
            }
            .padding(.top, 8)
            
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
        
    }
    
}

