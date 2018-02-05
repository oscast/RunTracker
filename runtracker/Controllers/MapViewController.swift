//
//  MapViewController.swift
//  runtracker
//
//  Created by Oscar Castillo Villacorta on 1/31/18.
//  Copyright © 2018 nextu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var points = [CLLocation]()
    var carPin: MKAnnotationView!
    var currentAnnotation: MKPointAnnotation?
    var settings = SettingsSingleton.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        settings.requestMediaLibraryPermission()
        
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        mapView.camera.altitude = 500
        mapView.showsCompass = false
        locationManager.startUpdatingHeading()
        
        //music
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if settings.applicationStarted {
            if settings.isPlayingMusic {
                settings.playMusic()
            }
        }
    }
    
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("New authorization: \(status.rawValue)")
        if (status.rawValue == 4) {
            mapView.centerCoordinate = (locationManager.location?.coordinate)!
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView.centerCoordinate = location.coordinate
            points.append(location)
            if self.currentAnnotation == nil {
                self.currentAnnotation = MKPointAnnotation()
                self.currentAnnotation?.coordinate = location.coordinate
                self.mapView.addAnnotation(self.currentAnnotation!)
                self.mapView.camera.centerCoordinate = location.coordinate
            }
            if settings.applicationStarted {
                if settings.isDrawingRoute {
                    if points.count > 0 {
                        var locations = points.map { $0.coordinate }
                        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
                        mapView?.add(polyline)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if self.carPin == nil {
            carPin =   MKAnnotationView(annotation: annotation, reuseIdentifier: "here")
            carPin.image = UIImage(named: "flecha")
        }
        carPin.annotation = annotation
        return carPin
    }
    
    //added in video for compass
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let angle = CGFloat(Double.pi/180)*CGFloat(newHeading.trueHeading)
        mapView.camera.heading = 0
        //   compassButton.transform = CGAffineTransform(rotationAngle: angle)
        carPin.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    //draw oplyline route

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.cyan
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    //IBACTIONS
    
    @IBAction func menuAction(_ sender: UIButton) {
        if settings.applicationStarted {
            locationManager.stopUpdatingLocation()
            
            var distance = 0.0
            
            if points.count > 1 {
                for i in 1...(points.count - 1) {
                    let previousPoint = points[i-1]
                    let currentPoint = points[i]
                    
                    distance += currentPoint.distance(from: previousPoint)
                }
            }
            
           let distanceText = String(format: "Distancia: %.2fm", distance)

        }
    }
    
}
