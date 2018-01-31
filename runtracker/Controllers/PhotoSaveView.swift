//
//  PhotoSaveView.swift
//  runtracker
//
//  Created by Integro on 4/05/17.
//  Copyright © 2017 nextu. All rights reserved.
//

import UIKit

class PhotoSaveView: UIView {
    //MARK: Outlets
    
    //Recorriste X metros en Y minutos
    @IBOutlet weak var distanceAndTimeLabel: UILabel!
    
    //Foto tomada por el usuario
    @IBOutlet weak var pictureImageView: UIImageView!
    
    //Desde XXº YY' ZZ" N, XXº YY' ZZ" S
    //Hasta XXº YY' ZZ" N, XXº YY' ZZ" S
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    
    //MARK: Class Methods
    
    class func loadFromNib() -> PhotoSaveView {
        var nibs = Bundle.main.loadNibNamed("PhotoSaveView", owner: self, options: nil)
        let photoView = nibs?[0] as! PhotoSaveView
        
        return photoView
    }
    
    class func convertTrackingToImage(withTracking tracking: RunTrack) -> UIImage {
        let viewToSave = PhotoSaveView.loadFromNib()
        viewToSave.setup(with: tracking)
        return viewToSave.getImage()
    }
    
    
    private func setup(with tracking: RunTrack){
        self.pictureImageView.image = tracking.userPicture!
        self.distanceAndTimeLabel.text = "Recorriste \(tracking.metersTraveled!) metros en \(tracking.minutesTraveled!) minutos"
        let startLatitudeString = tracking.startCoordinates!.dms.latitude
        let startLongitudeString = tracking.startCoordinates!.dms.longitude
        let endLatitudeString = tracking.endCoordinates!.dms.latitude
        let endLongitudeString = tracking.endCoordinates!.dms.longitude
        
        let formatedCoordinatesString = "Desde\(startLatitudeString),\(startLongitudeString) Hasta \(endLatitudeString),\(endLongitudeString)"
        
        self.coordinatesLabel.text = formatedCoordinatesString
    }
    
    private func getImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 1.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
