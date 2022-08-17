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
