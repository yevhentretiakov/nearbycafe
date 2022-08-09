//
//  MapViewController.swift
//  NearbyCafe
//
//  Created by user on 08.08.2022.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    private var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    let zoomLevel: Float = 12
    var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    private lazy var centerButton: UIButton = {
        let button = UIButton()
        let buttonSize: CGFloat = 60
        button.backgroundColor = .white
        button.layer.cornerRadius = buttonSize / 2
        button.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
        
        // Add shadow
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.masksToBounds = false
        
        // Specify button sizes
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        // Specify action for button
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMap()
        startLocationManager()
    }
    
    private func createMap() {
        let camera = GMSCameraPosition.camera(
            withLatitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude,
            zoom: zoomLevel
        )
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        view.addSubview(mapView)
        mapView.addSubview(centerButton)
        
        // Place center button on map
        centerButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        centerButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        
        mapView.isHidden = true
    }
    
    private func startLocationManager() {
        // Initialize the location manager.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Check if user denied access earlier
        let status = locationManager.authorizationStatus
        if isBadLocationStatus(status) {
            showAlert()
        }
    }
    
    private func isBadLocationStatus(_ status: CLAuthorizationStatus) -> Bool {
        if status == .denied || status == .restricted {
            return true
        } else {
            return false
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Can't get your location", message: "Share your location to fully use the app.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Later", style: UIAlertAction.Style.destructive) {_ in
            if self.mapView.isHidden {
                self.mapView.isHidden = false
            }
        })
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {_ in
            // Open app settings
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
               UIApplication.shared.open(settingsUrl)
             }
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func placeMarkers(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        mapView.clear()
        
        // Place user position marker
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.title = "Im Here"
        marker.map = mapView
    }
    
    @objc private func centerButtonTapped() {
        
        // Check if app have access to user locatin
        let status = locationManager.authorizationStatus
        if isBadLocationStatus(status) || status == .notDetermined {
            showAlert()
        } else {
            let camera = GMSCameraPosition.camera(
                withLatitude: defaultLocation.coordinate.latitude,
                longitude: defaultLocation.coordinate.longitude,
                zoom: zoomLevel
            )
            mapView.animate(to: camera)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Change default location
        defaultLocation = CLLocation(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        // Move map camera to new location
        let camera = GMSCameraPosition.camera(
            withLatitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude,
            zoom: zoomLevel
        )

        if mapView.isHidden {
            mapView.camera = camera
            mapView.isHidden = false
        } else {
            mapView.animate(to: camera)
        }
        
        placeMarkers(
            latitude: defaultLocation.coordinate.latitude,
            longitude: defaultLocation.coordinate.longitude
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if isBadLocationStatus(status) || status == .notDetermined {
            showAlert()
        }
    }
}
