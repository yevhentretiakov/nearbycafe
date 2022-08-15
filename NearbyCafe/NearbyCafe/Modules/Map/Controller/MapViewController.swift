//
//  MapViewController.swift
//  NearbyCafe
//
//  Created by user on 08.08.2022.
//

import UIKit
import GoogleMaps
import GooglePlaces

final class MapViewController: UIViewController {
    
    private var locationManager = CLLocationManager()
    private let networkService = NetworkManager()
    
    private var mapView: GMSMapView!
    private var mapNeedUpdation = false
    
    private var typesOfPlaces = ["cafe", "restaurant"]
    private let zoomLevel: Float = 12
    private var defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    private lazy var centerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
        
        button.addCornerRadius(60 / 2)
        button.addShadow()
        
        // Specify action for button
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var laterAction = UIAlertAction(title: "Later", style: UIAlertAction.Style.destructive) {_ in
        if self.mapView.isHidden {
            self.mapView.isHidden = false
        }
    }
    
    private lazy var settingsAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {_ in
        UIApplication.openAppSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        startLocationManager()
    }
    
    private func setupMap() {
        // create map view
        mapView = GMSMapView.map(withFrame: view.frame, camera: GMSCameraPosition())
        setMapCamera(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        
        mapView.isHidden = true
        
        layoutMap()
        layoutCenterButton()
    }
    
    private func layoutMap() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func layoutCenterButton() {
        mapView.addSubview(centerButton)
        
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerButton.heightAnchor.constraint(equalToConstant: 60),
            centerButton.widthAnchor.constraint(equalToConstant: 60),
            centerButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            centerButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func startLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Initialize the location manager.
        let status = locationManager.authorizationStatus
        
        // Check if user denied acces
        if status == .denied {
            showMapAlert()
        // Check if user have restricted access it mean he cant change location status in settings.
        // So just show map with default coordinates for him and hide center button.
        // Without this check user with restricted status will not see anything.
        } else if status == .restricted {
            centerButton.isHidden = true
            mapView.isHidden = false
        }
    }
    
    private func showMapAlert() {
        showAlert(title: "Can't get your location", message: "Share your location to fully use the app.", actions: [laterAction,settingsAction])
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
            
            networkService.fetch(PlaceListResponse.self, from: .getNearbyPlaces(
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
                                            let position = CLLocationCoordinate2D(latitude: place.geometry.location.latitude, longitude:  place.geometry.location.longitude)
                                            let marker = GMSMarker(position: position)
                                            
                                            marker.title = place.name
                                            
                                            // Get and set address for place
                                            self.networkService.fetch(PlaceDetailsResponse.self, from: .getPlaceDetails(placeID: place.place_id)) { result in
                                                switch result {
                                                case .success(let placeDetails):
                                                    if let placeDetails = placeDetails?.result {
                                                        DispatchQueue.main.async {
                                                            marker.snippet = placeDetails.address
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
    
    private func setMapCamera(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(
            withLatitude: latitude,
            longitude: longitude,
            zoom: zoomLevel
        )
        mapView.camera = camera
    }
   
    @objc private func centerButtonTapped() {
        // Check if app have access to user location
        let status = locationManager.authorizationStatus
        if status == .denied || status == .notDetermined {
            showMapAlert()
        } else {
            placeMarkers(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
            setMapCamera(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
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
            setMapCamera(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
            
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
            showMapAlert()
        } else if !mapView.isHidden && (status == .authorizedWhenInUse || status == .authorizedAlways) {
            // To automaticaly update already showed map with default coordinates on to map base on user coordinates.
            // Basically after user changed location access in settings and come back to app.
            mapNeedUpdation = true
        }
    }
}
