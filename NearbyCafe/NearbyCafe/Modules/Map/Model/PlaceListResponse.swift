//
//  Place.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 09.08.2022.
//

import Foundation

struct PlaceListResponse: Codable {
    let results: [PlaceModel]
}

struct PlaceModel: Codable {
    let name: String
    let geometry: GeometryModel
    let address: String
    let imageUrl: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case geometry
        case address = "vicinity"
        case imageUrl = "icon"
        case rating
    }
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
