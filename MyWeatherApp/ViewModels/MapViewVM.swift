//
//  MapViewVM.swift
//  MyWeatherApp
//
//  Created by John Gachuhi on 10/01/2025.
//

import MapKit

final class MapViewVM: NSObject, ObservableObject, MKMapViewDelegate {
    
    let mapView = MKMapView()
    
    override init() {
        super.init()
        mapView.delegate = self
        addGestureRecognizer()
    }
    
    // MARK: - Add Gesture Recognizer
    
    private func addGestureRecognizer() {
        let longTapgesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        mapView.addGestureRecognizer(longTapgesture)
    }
    
    @objc func handleLongPress(gestureReconizer: UITapGestureRecognizer) {
        let locationOnMap = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(locationOnMap, toCoordinateFrom: mapView)
        print("On long tap coordinates: \(coordinate)")
        setAnnotation(coordinate: coordinate)
    }
    
    // MARK: - MKMapViewDelegate method
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("The map is loaded")
    }
    
    // MARK: - Add Annotation
    
    func setAnnotation(coordinate: CLLocationCoordinate2D) {
        let coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
       let annotation = MKPointAnnotation()
       annotation.title = "Custom"
       annotation.coordinate = coordinate
       mapView.addAnnotation(annotation)
       setRegion(coordinate)
    }
    
    // MARK: - Zoom Out to specified Region
        
    func setRegion(_ coordinate: CLLocationCoordinate2D) {
        mapView.setRegion(MKCoordinateRegion(center: coordinate,
                                             latitudinalMeters: 1000,
                                             longitudinalMeters: 1000),
                          animated: true)
    }
    
}
