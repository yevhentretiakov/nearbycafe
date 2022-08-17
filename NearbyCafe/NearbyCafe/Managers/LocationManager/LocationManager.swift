//
//  LocationManager.swift
//  NearbyCafe
//
//  Created by user on 12.08.2022.
//

import Foundation
import CoreLocation

// MARK: - Protocols

protocol LocationManagerDelegateProtocol: AnyObject {
    func didReceivedLocation(location: CLLocation)
}

protocol LocationManagerProtocol {
    func configure()
    func startUpdateLocation()
    func getAddress(latitude: Double, longitude: Double, completion: @escaping (String) -> Void)
}

class LocationManager: NSObject, LocationManagerProtocol {
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    weak var delegate: LocationManagerDelegateProtocol?
    
    // MARK: - Life Cycle Methods
    
    override init() {
        super.init()
        configure()
    }
    
    // MARK: - Methods
    
    func configure() {
        locationManager.delegate = self
    }
    
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func getAddress(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        var address = [String]()
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            guard error == nil else {
                completion("")
                return
            }
            
            let placeMark = placemarks?[0]
            
            if let street = placeMark?.thoroughfare {
                address.append(street)
            }
            
            if let city = placeMark?.locality {
                address.append(city)
            }
            
            if let country = placeMark?.country {
                address.append(country)
            }
            
            completion(address.joined(separator: ", "))
        })
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            delegate?.didReceivedLocation(location: location)
        }
    }
}
