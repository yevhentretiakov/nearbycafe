//
//  GoogleServicesManager.swift
//  NearbyCafe
//
//  Created by user on 15.08.2022.
//

import GoogleMaps
import Foundation

protocol GoogleServicesManagerProtocol {
    func configure()
}

class GoogleServicesManager: GoogleServicesManagerProtocol {
    
    init() {
        configure()
    }
    
    func configure() {
        GMSServices.provideAPIKey(EnvironmentConfig.googleMapsApiKey)
    }
}
