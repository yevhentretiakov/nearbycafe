//
//  NetworkService.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 09.08.2022.
//

import UIKit

// MARK: - Protocols

protocol HTTPRequest {
    var url: String { get }
}

protocol NetworkManager {
    func get<T: Decodable>(_ returnType: T.Type, from endpoint: ApiEndpoint, completion: @escaping (Result<T?, NetworkError>) -> Void)
}

final class DefaultNetworkManager: NetworkManager {
    
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
                let decodedData = try DefaultNetworkManager.decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
