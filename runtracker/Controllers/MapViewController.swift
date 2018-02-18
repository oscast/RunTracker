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
    @IBOutlet weak var menuButton: UIButton!
    
    let locationManager = CLLocationManager()
    var points = [CLLocation]()
    var carPin: MKAnnotationView!
    var currentAnnotation: MKPointAnnotation?
    var settings = SettingsSingleton.instance
    var startTime = Date()
    var endTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        settings.requestMediaLibraryPermission()
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10
        mapView.camera.altitude = 500
        mapView.showsCompass = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if settings.applicationStarted {
            startTime = Date()
            points = [CLLocation]()
            if settings.isPlayingMusic {
                settings.playMusic()
            }
        }
        menuButton.setImage(UIImage(named: settings.applicationStarted ? "stop" : "menu"), for: .normal)
        
    }
    
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("New authorization: \(status.rawValue)")
        if (status.rawValue == 4) {
            self.locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            mapView.centerCoordinate = (locationManager.location?.coordinate)!
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            mapView.centerCoordinate = location.coordinate
            if settings.isRegisteringRoute {
                points.append(location)
            }
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
    
    //compass update
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let angle = CGFloat(Double.pi/180)*CGFloat(newHeading.trueHeading)
        mapView.camera.heading = 0
        carPin.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    //draw polyline route
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.cyan
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    //MARK: - IBACTIONS
    
    @IBAction func menuAction(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if settings.applicationStarted {
            settings.applicationStarted = false
            let minutes = Date().minutes(from: startTime)
            locationManager.stopUpdatingLocation()
            settings.playerController.pause()
            settings.playerController.stop()
            settings.playerController.setQueue(with: settings.query)
            var distance = 0.0
            if points.count > 1 {
                for i in 1...(points.count - 1) {
                    let previousPoint = points[i-1]
                    let currentPoint = points[i]
                    
                    distance += currentPoint.distance(from: previousPoint)
                }
            }
            let distanceText = distance == 0 ? "varios" : String(format: "Distancia: %.2f", distance)
            print(distanceText)
            let endTrack = mainStoryboard.instantiateViewController(withIdentifier: "endTrack") as! EndTrackViewController
            endTrack.meters = "Recorriste \(distanceText) metros"
            endTrack.minutes = "En \(minutes) minutos"
            endTrack.startCoordinate = points.first?.coordinate
            endTrack.endCoordinate = points.last?.coordinate
            endTrack.metersInt = Int(distance)
            endTrack.minutesInt = minutes
            self.present(endTrack, animated: true, completion: nil)
        } else {
            let routeTracker = mainStoryboard.instantiateViewController(withIdentifier: "routeTracker")
            self.present(routeTracker, animated: true, completion: nil)
        }
    }
}

extension Date {
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
}
