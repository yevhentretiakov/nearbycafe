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

protocol LocationManagerProtocol {
    func configure()
    func start()
    func getAddress(latitude: Double, longitude: Double, completion: @escaping (String) -> Void)
}

class LocationManager: NSObject, LocationManagerProtocol {
    
    private var locationManager = CLLocationManager()
    public private(set) var currentLocation: CLLocation?
    weak var delegate: LocationManagerDelegateProtocol?
    
    override init() {
        super.init()
        configure()
    }
    
    func configure() {
        locationManager.delegate = self
    }
    
    func start() {
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

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            delegate?.locationReceived(location: location)
        }
    }
}
