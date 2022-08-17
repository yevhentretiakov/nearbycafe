//
//  NetworkService.swift
//  NearbyCafe
//
//  Created by user on 09.08.2022.
//

import UIKit

protocol HTTPRequest {
    var url: String { get }
}

enum ApiEndpoint {
    case getNearbyPlaces(latitude: Double, longitude: Double, type: String)
}

extension ApiEndpoint: HTTPRequest {
    var url: String {
        switch self {
        case .getNearbyPlaces(let latitude, let longitude, let type):
            let baseURL = "https://maps.googleapis.com/maps/api/place"
            let path = "/nearbysearch/json?location=\(latitude),\(longitude)&radius=5000&type=\(type)&key=\(EnvironmentConfig.googleMapsApiKey)"
            return baseURL + path
        }
    }
}

// MARK: - Protocols

protocol NetworkManagerProtocol {
    func get<T: Decodable>(_ returnType: T.Type, from endpoint: ApiEndpoint, completion: @escaping (Result<T?, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    
    private static let decoder = JSONDecoder()
    
    // MARK: - Methods
    
    func get<T: Decodable>(_ returnType: T.Type, from endpoint: ApiEndpoint, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        
        guard let url = URL(string: endpoint.url) else {
            completion(.failure(.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                if let error = error as? NetworkError {
                    completion(.failure(error))
                } else {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            do {
                let decodedData = try NetworkManager.decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
