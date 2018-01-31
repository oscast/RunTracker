//
//  CLLocationCoordinate2D+DMS.swift
//  runtracker
//
//  Created by Integro on 4/05/17.
//  Copyright © 2017 nextu. All rights reserved.
//

import MapKit
extension CLLocationCoordinate2D {
    var latitudeMinutes:  Double {
        return latitude.multiplied(by: 3600)
            .truncatingRemainder(dividingBy: 3600)
            .divided(by: 60)
    }
    var latitudeSeconds:  Double {
        return latitude.multiplied(by: 3600)
            .truncatingRemainder(dividingBy: 3600)
            .truncatingRemainder(dividingBy: 60)
    }
    
    var longitudeMinutes: Double {
        return longitude.multiplied(by: 3600)
            .truncatingRemainder(dividingBy: 3600)
            .divided(by: 60)
    }
    var longitudeSeconds: Double {
        return longitude.multiplied(by: 3600)
            .truncatingRemainder(dividingBy: 3600)
            .truncatingRemainder(dividingBy: 60)
    }
    
    var dms:(latitude: String, longitude: String) {
        return (String(format:"%d° %d' %.4f\" %@",
                       Int(abs(latitude)),
                       Int(abs(latitudeMinutes)),
                       abs(latitudeSeconds),
                       latitude >= 0 ? "N" : "S"),
                String(format:"%d° %d' %.4f\" %@",
                       Int(abs(longitude)),
                       Int(abs(longitudeMinutes)),
                       abs(longitudeSeconds),
                       longitude >= 0 ? "E" : "W"))
    }
}
