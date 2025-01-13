//
//  MapView.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var weatherVM: WeatherVM
    @EnvironmentObject var appSettings: AppSettingsManager
    
    var cityWeather: CityWeather?
    var allCitiesWeather: [CityWeather]?
    
    @StateObject var mapVM = MapViewVM()
    
    var body: some View {
        
        let condition = weatherVM.weather?.weather?.first?.main ?? ""
        let currentTheme = appSettings.appTheme
        
        VStack(spacing: 0) {
            
            WrapperView(view: mapVM.mapView)
                .ignoresSafeArea(edges: .top)
                .onAppear {
                    if let _ = allCitiesWeather {
                        setAllAnnotations()
                    } else if let _ = cityWeather {
                        setAnnotation()
                    }
                }
            
            Rectangle()
                .fill(BGColorMapper.bgColor(for: condition, theme: currentTheme))
                .frame(width: UIScreen.main.bounds.width, height: 100)
                .padding(.bottom, -100)
            
        }
        .background {
            BGColorMapper.bgColor(for: condition, theme: currentTheme)
        }
        
    }
    
    // MARK: - Set Single Annotation
    
    private func setAnnotation() {
        
        if let cityWeather = cityWeather {
            
            let lat = Double(cityWeather.weather.coord?.lat ?? 0.0)
            let long = Double(cityWeather.weather.coord?.lon ?? 0.0)
            let coords = CLLocation(latitude: lat, longitude: long)
            
            let coordinate = CLLocationCoordinate2D(latitude: coords.coordinate.latitude, longitude: coords.coordinate.longitude)
            let annotation = MKPointAnnotation()
            annotation.title = cityWeather.city
            annotation.subtitle = cityWeather.weather.weather?.first?.description ?? ""
            annotation.coordinate = coordinate
            mapVM.mapView.addAnnotation(annotation)
            setRegion(coordinate)
            
        }
        
    }
    
    // MARK: - Set Multiple Annotation
    
    private func setAllAnnotations() {
        
        var allLocations: [CLLocationCoordinate2D] = []
        
        for each in (allCitiesWeather ?? []) {
            
            let lat = Double(each.weather.coord?.lat ?? 0.0)
            let long = Double(each.weather.coord?.lon ?? 0.0)
            let coords = CLLocation(latitude: lat, longitude: long)
            
            let coordinate = CLLocationCoordinate2D(latitude: coords.coordinate.latitude, longitude: coords.coordinate.longitude)
            let annotation = MKPointAnnotation()
            annotation.title = each.city
            annotation.subtitle = each.weather.weather?.first?.description ?? ""
            annotation.coordinate = coordinate
            mapVM.mapView.addAnnotation(annotation)
            
            allLocations.append(coordinate)
            
        }

        setAllRegion(allLocations)
        
    }
    
    // MARK: - Set Region around Single Annotation
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        
        mapVM.mapView.setRegion(MKCoordinateRegion(center: coordinate,
                                                   latitudinalMeters: 1000,
                                                   longitudinalMeters: 1000),
                                animated: true)
        openAnnotation(annotation: mapVM.mapView.annotations.first)
        
    }
    
    // MARK: - Set Region around All Annotation
    
    private func setAllRegion(_ allLocations: [CLLocationCoordinate2D]) {
        
        let poly: MKPolygon = MKPolygon(coordinates: allLocations, count: allLocations.count)

        mapVM.mapView.setVisibleMapRect(poly.boundingMapRect,
                                        edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0),
                                        animated: true)
        
        openAnnotation(annotation: mapVM.mapView.annotations.first)
        
    }
    
    // MARK: - Open Annotations
    
    func openAnnotation(annotation: MKAnnotation?) {
        if let annotation = annotation {
            _ = [mapVM.mapView.selectAnnotation(annotation, animated: true)]
        }
    }
    
    
    
}

//#Preview {
//    MapView()
//}
