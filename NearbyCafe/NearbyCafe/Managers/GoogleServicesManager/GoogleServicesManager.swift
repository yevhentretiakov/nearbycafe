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
    
}

class GoogleServicesManager: GoogleServicesManagerProtocol {
    
    // MARK: - Life Cycle Methods
    
    init() {
        configure()
    }
    
    // MARK: - Methods
    
    private func configure() {
        GMSServices.provideAPIKey(EnvironmentConfig.googleMapsApiKey)
    }
}
