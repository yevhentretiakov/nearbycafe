//
//  LocationManager.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 12.08.2022.
//

import UIKit
import CoreLocation

// MARK: - Protocols

protocol LocationManagerDelegate: AnyObject {
    func didReceiveLocation(location: CLLocation)
}

protocol LocationManager {
    func setDelegate(_ delegate: LocationManagerDelegate)
    func checkLocationManagerAuthorization()
    func stopUpdatingLocation()
}

final class DefaultLocationManager: NSObject, LocationManager {
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private(set) var currentLocation: CLLocation?
    private weak var delegate: LocationManagerDelegate?
    
    // MARK: - Life Cycle Methods
    
    override init() {
        super.init()
        configure()
    }
    
    // MARK: - Methods
    
    private func configure() {
        locationManager.delegate = self
    }
    
    func checkLocationManagerAuthorization() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                locationManager.startUpdatingLocation()
            default:
                DefaultLocationManager.showLocationAlert()
            }
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func setDelegate(_ delegate: LocationManagerDelegate) {
        self.delegate = delegate
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

extension DefaultLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            stopUpdatingLocation()
            currentLocation = location
            delegate?.didReceiveLocation(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationManagerAuthorization()
    }
}
