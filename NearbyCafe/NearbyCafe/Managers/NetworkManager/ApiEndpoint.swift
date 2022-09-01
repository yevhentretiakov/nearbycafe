//
//  ApiEndpoint.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 17.08.2022.
//

import Foundation

enum ApiEndpoint {
    case getNearbyPlaces(location: Location, type: String)
}

// MARK: - HTTPRequest

extension ApiEndpoint: HTTPRequest {
    var url: String {
        switch self {
        case .getNearbyPlaces(let location, let type):
            let baseURL = "https://maps.googleapis.com/maps/api/place"
            let path = "/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=5000&type=\(type)&key=\(EnvironmentConfig.googleMapsApiKey)"
            return baseURL + path
        }
    }
}
