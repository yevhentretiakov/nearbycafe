//
//  Place.swift
//  NearbyCafe
//
//  Created by user on 09.08.2022.
//

import Foundation

struct NearbyPlaces: Codable {
    let results: [Place]
}

struct Place: Codable {
    let name: String
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}
