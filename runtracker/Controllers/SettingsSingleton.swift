//
//  SettingsSingleton.swift
//  runtracker
//
//  Created by Oscar Castillo Villacorta on 2/5/18.
//  Copyright © 2018 nextu. All rights reserved.
//

import Foundation
import MediaPlayer

class SettingsSingleton {
    
    static let instance = SettingsSingleton()
    
    var isPlayingMusic = true
    var isRegisteringRoute = true
    var isDrawingRoute = true
    var playerController = MPMusicPlayerController.applicationMusicPlayer()
    var query : MPMediaQuery!
    var applicationStarted = false
    private init() { }
    
    
    func requestMediaLibraryPermission() {
        MPMediaLibrary.requestAuthorization { (status) in
            self.query = MPMediaQuery.songs()
            self.query.groupingType = .title
            
            self.playerController.setQueue(with: self.query)
        }
    }
    
    func playMusic() {
        playerController.play()
    }
    
}
