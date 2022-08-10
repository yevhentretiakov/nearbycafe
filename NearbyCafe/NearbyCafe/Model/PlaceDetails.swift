//
//  PlaceDetails.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import Foundation

struct PlaceDetailsResult: Codable {
    let result: PlaceDetails
}

struct PlaceDetails: Codable {
    let formatted_address: String
}
