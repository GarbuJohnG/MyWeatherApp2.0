//
//  LocationManager.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 09/01/2025.
//

import Foundation
import CoreLocation

// MARK: - LocationManagerDelegate Protocol

protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidUpdateLocation(_ location: CLLocation)
}

// MARK: - LocationManager

final class LocationManager: NSObject, ObservableObject {
    
    // Published variable for the current location
    @Published private(set) var currentLocation: CLLocation?
    
    private let locationManager: CLLocationManager
    private let distanceFilter: CLLocationDistance
    private weak var delegate: LocationManagerDelegate?
    
    // MARK: - Initializer
    
    init(distanceFilter: CLLocationDistance = 500.0, delegate: LocationManagerDelegate? = nil) {
        self.locationManager = CLLocationManager()
        self.distanceFilter = distanceFilter
        self.delegate = delegate
        super.init()
        configureLocationManager()
    }
    
    // MARK: - Private Methods
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = distanceFilter
        locationManager.startUpdatingLocation()
    }
    
    private func shouldUpdateLocation(newLocation: CLLocation, oldLocation: CLLocation?) -> Bool {
        guard let oldLocation = oldLocation else {
            return true
        }
        return newLocation.distance(from: oldLocation) > distanceFilter
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        if shouldUpdateLocation(newLocation: newLocation, oldLocation: currentLocation) {
            currentLocation = newLocation
            delegate?.locationManagerDidUpdateLocation(newLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update location: \(error.localizedDescription)")
    }
    
}
