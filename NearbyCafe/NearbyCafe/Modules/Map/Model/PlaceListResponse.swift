//
//  Place.swift
//  NearbyCafe
//
//  Created by user on 09.08.2022.
//

import Foundation

struct PlaceListResponse: Codable {
    let results: [Place]
}

struct Place: Codable {
    let name: String
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let latitude, longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
