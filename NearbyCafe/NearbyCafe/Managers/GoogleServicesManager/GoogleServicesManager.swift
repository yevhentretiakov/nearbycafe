//
//  GoogleServicesManager.swift
//  NearbyCafe
//
//  Created by user on 15.08.2022.
//

import GoogleMaps
import Foundation

// MARK: - Protocols

protocol GoogleServicesManagerProtocol {
    func configure()
}

class GoogleServicesManager {
    
    // MARK: - Life Cycle Methods
    
    init() {
        configure()
    }
    
    // MARK: - Methods
    
    func configure() {
        GMSServices.provideAPIKey(EnvironmentConfig.googleMapsApiKey)
    }
}
