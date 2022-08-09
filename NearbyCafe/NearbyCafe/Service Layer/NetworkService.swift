//
//  NetworkService.swift
//  NearbyCafe
//
//  Created by user on 09.08.2022.
//

import UIKit

protocol NetworkServiceProtocol {
    func getNearbyPlaces(latitude: Double, longitude: Double, radius: Int, type: String, completion: @escaping (Result<[Place]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func getNearbyPlaces(latitude: Double, longitude: Double, radius: Int, type: String, completion: @escaping (Result<[Place]?, Error>) -> Void) {
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude)%2C\(longitude)&radius=\(radius)&type=\(type)&key=\(APIKeys.gmap)"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let obj = try decoder.decode(NearbyPlaces.self, from: data)
                completion(.success(obj.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
