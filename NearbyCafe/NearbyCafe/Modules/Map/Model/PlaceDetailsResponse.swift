//
//  PlaceDetails.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import Foundation

struct PlaceDetailsResponse: Codable {
    let result: PlaceDetailModel
}

struct PlaceDetailModel: Codable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case address = "formatted_address"
    }
}
