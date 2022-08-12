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

final class MapViewController: UIViewController {
    
    private var locationManager = CLLocationManager()
    private var networkService = NetworkManager()
    
    private var mapView: GMSMapView!
    private var mapNeedUpdation = false
    
    private var typesOfPlaces = ["cafe", "restaurant"]
    private let zoomLevel: Float = 12
    private var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
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
        
        // create map view
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        
        // Place map on screen
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Place center button on map
        mapView.addSubview(centerButton)
        centerButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        centerButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        mapView.isHidden = true
    }
    
    private func startLocationManager() {
        // Initialize the location manager.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let status = locationManager.authorizationStatus
        
        // Check if user denied acces
        if status == .denied {
            showAlert()
        // Check if user have restricted access it mean he cant change location status in settings.
        // So just show map with default coordinates for him and hide center button.
        // Without this check user with restricted status will not see anything.
        } else if status == .restricted {
            centerButton.isHidden = true
            mapView.isHidden = false
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
        marker.title = "I'm Here"
        marker.map = mapView
        
        // Get list of places for each type
        for type in typesOfPlaces {
            
            networkService.fetch(NearbyPlacesResults.self, from: .getNearbyPlaces(
                latitude: defaultLocation.coordinate.latitude,
                longitude: defaultLocation.coordinate.longitude,
                type: type)) {  [weak self] result in
                    guard let self = self else { return }
                        switch result {
                        case .success(let receivedPlaces):
                            
                            if let receivedPlaces = receivedPlaces?.results {
                                
                                    // Place markers for places
                                    for place in receivedPlaces {
                                        DispatchQueue.main.async {
                                            let position = CLLocationCoordinate2D(latitude: place.geometry.location.lat, longitude:  place.geometry.location.lng)
                                            let marker = GMSMarker(position: position)
                                            
                                            marker.title = place.name
                                            
                                            // Get and set address for place
                                            self.networkService.fetch(PlaceDetailsResult.self, from: .getPlaceDetails(placeID: place.place_id)) { result in
                                                switch result {
                                                case .success(let placeDetails):
                                                    if let placeDetails = placeDetails?.result {
                                                        DispatchQueue.main.async {
                                                            marker.snippet = placeDetails.formatted_address
                                                        }
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                }
                                            }
                                            
                                            // Place marker on map
                                            marker.map = self.mapView
                                        
                                        }
                                    }
                            }
                        case .failure(let error):
                            print(error)
                        }
            }
        }
    }
    
    @objc private func centerButtonTapped() {
        
        // Check if app have access to user location
        let status = locationManager.authorizationStatus
        if status == .denied || status == .notDetermined {
            showAlert()
        } else {
            placeMarkers(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
            let camera = GMSCameraPosition.camera(
                withLatitude: defaultLocation.coordinate.latitude,
                longitude: defaultLocation .coordinate.longitude,
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
        
        if mapView.isHidden || mapNeedUpdation {
            // Move map camera to user location
            let camera = GMSCameraPosition.camera(
                withLatitude: defaultLocation.coordinate.latitude,
                longitude: defaultLocation.coordinate.longitude,
                zoom: zoomLevel
            )
            mapView.camera = camera
            
            placeMarkers(
                latitude: defaultLocation.coordinate.latitude,
                longitude: defaultLocation.coordinate.longitude
            )
            
            mapNeedUpdation = false
            mapView.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .notDetermined {
            showAlert()
        } else if !mapView.isHidden && (status == .authorizedWhenInUse || status == .authorizedAlways) {
            // To automaticaly update already showed map with default coordinates on to map base on user coordinates.
            // Basically after user changed location access in settings and come back to app.
            mapNeedUpdation = true
        }
    }
}
