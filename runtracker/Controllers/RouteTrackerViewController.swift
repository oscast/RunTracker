//
//  RouteTrackerViewController.swift
//  runtracker
//
//  Created by Oscar Castillo Villacorta on 1/31/18.
//  Copyright © 2018 nextu. All rights reserved.
//

import UIKit

class RouteTrackerViewController: UIViewController {

    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var routeRegisterButton: UIButton!
    @IBOutlet weak var routeDrawButton: UIButton!
    @IBOutlet weak var musicStatusLabel: UILabel!
    @IBOutlet weak var routeRegisterStatusLabel: UILabel!
    @IBOutlet weak var routeDrawStatusLabel: UILabel!
    
    @IBOutlet weak var routeStartButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    lazy var settings = SettingsSingleton.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func CloseAction(_ sender: UIButton) {
        
    }
    
    @IBAction func musicAction(_ sender: UIButton) {
       settings.isPlayingMusic = !settings.isPlayingMusic
    }
   
    @IBAction func routeRegisterAction(_ sender: UIButton) {
        settings.isRegisteringRoute = !settings.isRegisteringRoute
    }
    
    @IBAction func routeDrawAction(_ sender: UIButton) {
        settings.isDrawingRoute = !settings.isDrawingRoute
    }
    
    @IBAction func startAction(_ sender: UIButton) {
            settings.applicationStarted = true
        self.dismiss(animated: true, completion: nil)
    }

}
