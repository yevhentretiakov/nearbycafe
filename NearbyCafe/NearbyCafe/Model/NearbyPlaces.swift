//
//  Place.swift
//  NearbyCafe
//
//  Created by user on 09.08.2022.
//

import Foundation

struct NearbyPlacesResults: Codable {
    let results: [Place]
}

struct Place: Codable {
    let place_id: String
    let name: String
    let rating: Double
    let icon: String
    let geometry: Geometry
    var address: String?
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}
