//
//  ErrorMessage.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import Foundation

enum ErrorMessage: String, Error {
    case badURL = "Bad url."
    case unableToComplete = "Unable to complete."
    case invalidResponse = "Invalid response."
    case invalidData = "Invalid data."
}
