//
//  LocationManager.swift
//  NearbyCafe
//
//  Created by user on 12.08.2022.
//

import UIKit
import CoreLocation

// MARK: - Protocols

protocol LocationManagerDelegateProtocol: AnyObject {
    func didReceiveLocation(location: CLLocation)
}

protocol LocationManagerProtocol {
    func startUpdatingLocation()
    func stopUpdatingLocation()
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
    
    private func configure() {
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                locationManager.startUpdatingLocation()
            default:
                LocationManager.showLocationAlert()
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private static func showLocationAlert() {
        let laterAction = UIAlertAction(title: "Later", style: UIAlertAction.Style.destructive, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {_ in
            UIApplication.openAppSettings()
        }
        UIApplication.rootViewController?.showAlert(title: "Can't get your location",
                                 message: "Share your location to fully use the app.",
                                 actions: [laterAction,settingsAction])
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            stopUpdatingLocation()
            currentLocation = location
            delegate?.didReceiveLocation(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startUpdatingLocation()
    }
}
