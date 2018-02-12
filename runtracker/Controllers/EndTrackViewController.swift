//
//  EndTrackViewController.swift
//  runtracker
//
//  Created by Oscar Castillo Villacorta on 2/5/18.
//  Copyright © 2018 nextu. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import MobileCoreServices

class EndTrackViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var totalMetersResultLabel: UILabel!
    @IBOutlet weak var totalTimeResultLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    public var cameraIsAvailable = false
    
    var meters = ""
    var minutes = ""
    var metersInt = 0
    var minutesInt = 0
    var startLongitude = ""
    var endLongitude = ""
    var startCoordinate : CLLocationCoordinate2D!
    var endCoordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalMetersResultLabel.text = meters
        totalTimeResultLabel.text = minutes
        configureCamera()
    }
    
    @IBAction func closeResults(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePictureAction(_ sender: UIButton) {
        
        if cameraIsAvailable {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            let mediaPermission = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            switch mediaPermission {
            case .authorized:
                self.present(self.imagePicker, animated: true, completion: nil)
                break
            default:
                // present(REAlertCenter.noMediaPermissionAlert(String.localize(key: "re.profile.cameraAlertTitle"), String.localize(key: "re.profile.cameraPermissionError")), animated: true, completion: nil)
                break
            }
        } else {
            //    present(REAlertCenter.showErrorMessage(String.localize(key: "re.profile.cameraDeviceError")), animated: true, completion: nil)
        }
        
    }
    
    public func configureCamera() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            cameraIsAvailable = true
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
        }
        PHPhotoLibrary.requestAuthorization({ (status) in })
    }
    
    //MARK: UIPickerControlleDelegate
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeImage as String {
           if let imageTaken = info[UIImagePickerControllerOriginalImage] as? UIImage {
                let runTrack = RunTrack(userPicture: imageTaken, metersTraveled: metersInt, minutesTraveled: minutesInt, startCoordinates: startCoordinate, endCoordinates: endCoordinate)
            let nib = PhotoSaveView.loadFromNib()
            nib.pictureImageView.image = PhotoSaveView.convertTrackingToImage(withTracking: runTrack)
            //let editedImage = PhotoSaveView.convertTrackingToImage(withTracking: runTrack)
            UIImageWriteToSavedPhotosAlbum(nib.pictureImageView.image!, nil, nil, nil)
            }
        }
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
