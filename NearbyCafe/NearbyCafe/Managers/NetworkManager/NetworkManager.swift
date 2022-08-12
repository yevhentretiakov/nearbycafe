//
//  NetworkService.swift
//  NearbyCafe
//
//  Created by user on 09.08.2022.
//

import UIKit

enum ApiEndpoint {
    case getNearbyPlaces(latitude: Double, longitude: Double, type: String)
    case getPlaceDetails(placeID: String)
}

protocol HTTPRequest {
    var url: String { get }
}

extension ApiEndpoint: HTTPRequest {
    var url: String {
        switch self {
        case .getNearbyPlaces(let latitude, let longitude, let type):
            let baseURL = "https://maps.googleapis.com/maps/api/place"
            let path = "/nearbysearch/json?location=\(latitude),\(longitude)&radius=5000&type=\(type)&key=\(APIKeys.gmap)"
            return baseURL + path
        case .getPlaceDetails(let placeID):
            let baseURL = "https://maps.googleapis.com/maps/api/place"
            let path = "/details/json?place_id=\(placeID)&fields=formatted_address&key=\(APIKeys.gmap)"
            return baseURL + path
        }
    }
}

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(_ returnType: T.Type, from endpoint: ApiEndpoint, completion: @escaping (Result<T?, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    func fetch<T: Decodable>(_ returnType: T.Type, from endpoint: ApiEndpoint, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let obj = try decoder.decode(T.self, from: data)
                completion(.success(obj))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
