//
//  LocationManager.swift
//  NearbyCafe
//
//  Created by user on 12.08.2022.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegateProtocol: AnyObject {
    func statusDenied()
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
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("Auth: notDetermined")
        case .restricted:
            print("Auth: restricted")
        case .denied:
            print("Auth: denied")
        case .authorizedAlways:
            print("Auth: authorizedAlways")
        case .authorizedWhenInUse:
            print("Auth: authorizedWhenInUse")
        case .authorized:
            print("Auth: authorized")
        default:
            print("Auth: default")
        }
    }
}
