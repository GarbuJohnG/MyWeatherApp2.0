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
    
    // MARK: - Published variable for the current location
    
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var locationError: String?
    @Published var showError: Bool?
    
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
        checkLocationAuthorization()
    }
    
    // MARK: - Private Methods
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = distanceFilter
    }
    
    // MARK: - Update only new location (> than 500m)
    
    private func shouldUpdateLocation(newLocation: CLLocation, oldLocation: CLLocation?) -> Bool {
        guard let oldLocation = oldLocation else {
            return true
        }
        return newLocation.distance(from: oldLocation) > distanceFilter
    }
    
    // MARK: - Check Location Authorization
    
    private func checkLocationAuthorization() {
        let authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access is restricted or denied. Inform the user to enable it in settings.")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("Unknown location authorization status.")
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: - Detect any changes to CLLocation Authorization
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("Location access was denied or restricted.")
            locationError = "LLocation access was denied or restricted."
            showError = true
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown location authorization status.")
            locationError = "Unknown location authorization status."
            showError = true
        }
    }
    
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
