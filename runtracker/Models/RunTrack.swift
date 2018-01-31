//
//  RunTrack.swift
//  runtracker
//
//  Created by Integro on 4/05/17.
//  Copyright © 2017 nextu. All rights reserved.
//

import UIKit
import CoreLocation
struct RunTrack {
    var userPicture: UIImage?
    var metersTraveled: Int?
    var minutesTraveled: Int?
    var startCoordinates: CLLocationCoordinate2D?
    var endCoordinates: CLLocationCoordinate2D?
    
    init(userPicture: UIImage, metersTraveled: Int, minutesTraveled: Int, startCoordinates: CLLocationCoordinate2D, endCoordinates: CLLocationCoordinate2D) {
        self.userPicture = userPicture
        self.metersTraveled = metersTraveled
        self.minutesTraveled = minutesTraveled
        self.startCoordinates = startCoordinates
        self.endCoordinates = endCoordinates
    }
}
