//
//  ApiEndpoint.swift
//  NearbyCafe
//
//  Created by user on 17.08.2022.
//

import Foundation

enum ApiEndpoint {
    case getNearbyPlaces(latitude: Double, longitude: Double, type: String)
}

// MARK: - HTTPRequest

extension ApiEndpoint: HTTPRequest {
    var url: String {
        switch self {
        case .getNearbyPlaces(let latitude, let longitude, let type):
            let baseURL = "https://maps.googleapis.com/maps/api/place"
            let path = "/nearbysearch/json?location=\(latitude),\(longitude)&radius=5000&type=\(type)&key=\(EnvironmentConfig.googleMapsApiKey)"
            return baseURL + path
        }
    }
}
