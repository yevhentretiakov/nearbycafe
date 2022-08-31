//
//  GoogleServicesManager.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 15.08.2022.
//

import GoogleMaps
import Foundation

// MARK: - Protocols

protocol GoogleServicesManager {
    func configure()
}

final class DefaultGoogleServicesManager: GoogleServicesManager {
    
    // MARK: - Life Cycle Methods
    
    init() {
        configure()
    }
    
    // MARK: - Methods
    
    func configure() {
        GMSServices.provideAPIKey(EnvironmentConfig.googleMapsApiKey)
    }
}
