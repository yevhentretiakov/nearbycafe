//
//  LocationManager.swift
//  NearbyCafe
//
//  Created by user on 12.08.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegateProtocol: AnyObject {
    func locationReceived(location: CLLocation)
}

class LocationManager: NSObject {
    
    private var locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegateProtocol?
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        locationManager.delegate = self
    }
    
    func start() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.locationReceived(location: location)
        }
    }
}
