//
//  Place.swift
//  NearbyCafe
//
//  Created by user on 09.08.2022.
//

import Foundation

struct PlaceListResponse: Codable {
    let results: [PlaceModel]
}

struct PlaceModel: Codable {
    let name: String
    let geometry: GeometryModel
    let vicinity: String
    let icon: String
    let rating: Double
}

struct GeometryModel: Codable {
    let location: LocationModel
}

struct LocationModel: Codable {
    let latitude, longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
