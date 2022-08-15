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
    
    private let locationManager = LocationManager()
    private let networkService = NetworkManager()
    
    private var mapLocationSetted = false
    
    private var mapView: GMSMapView!
    
    private let placeTypes = ["cafe", "restaurant"]
    private let zoomLevel: Float = 12
    private let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    private lazy var centerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        button.addCornerRadius(60 / 2)
        button.addShadow()
        return button
    }()
    
    private lazy var laterAction = UIAlertAction(title: "Later", style: UIAlertAction.Style.destructive, handler: nil)
    private lazy var settingsAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {_ in
        UIApplication.openAppSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        locationManager.start()
        locationManager.delegate = self
    }
    
    private func setupMap() {
        // create map view
        mapView = GMSMapView.map(withFrame: view.frame, camera: GMSCameraPosition())
        setMapCamera(latitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude)
        
        mapView.isMyLocationEnabled = true
        
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
    
    private func showMapAlert() {
        showAlert(title: "Can't get your location", message: "Share your location to fully use the app.", actions: [laterAction,settingsAction])
    }
    
    private func setMarkers(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        mapView.clear()
        
        guard let location = mapView.myLocation else { return }
        
        // Get list of places for each type
        for type in placeTypes {
            networkService.fetch(PlaceListResponse.self, from: .getNearbyPlaces(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                type: type)) {  [weak self] result in
                    guard let self = self else { return }
                        switch result {
                        case .success(let receivedPlaces):
                            if let receivedPlaces = receivedPlaces?.results {
                                    // Place markers for places
                                    for place in receivedPlaces {
                                        DispatchQueue.main.async {
                                            // Get and set address for place
                                            self.networkService.fetch(PlaceDetailsResponse.self, from: .getPlaceDetails(placeID: place.place_id)) { result in
                                                switch result {
                                                case .success(let placeDetails):
                                                    if let placeDetails = placeDetails?.result {
                                                        DispatchQueue.main.async {
                                                            self.setMarker(latitude: place.geometry.location.latitude,
                                                                           longitude: place.geometry.location.longitude,
                                                                           title: place.name,
                                                                           snippet: placeDetails.address)
                                                        }
                                                    } else {
                                                        DispatchQueue.main.async {
                                                            self.setMarker(latitude: place.geometry.location.latitude,
                                                                           longitude: place.geometry.location.longitude,
                                                                           title: place.name)
                                                        }
                                                    }
                                                case .failure(let error):
                                                    print(error)
                                                }
                                            }
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
    
    private func setMarker(latitude: Double, longitude: Double, title: String? = nil, snippet: String? = nil) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        if let title = title {
            marker.title = title
        }
        if let snippet = snippet {
            marker.snippet = snippet
        }
        marker.map = mapView
    }
    
    private func updateMap(latitude: Double, longitude: Double) {
        mapLocationSetted = true
        setMarkers(latitude: latitude, longitude: longitude)
        setMapCamera(latitude: latitude, longitude: longitude)
    }
    
    @objc private func centerButtonTapped() {
        if let location = mapView.myLocation {
            updateMap(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        } else {
            showMapAlert()
        }
    }
}

extension MapViewController: LocationManagerDelegateProtocol {
    func locationReceived(location: CLLocation) {
        if let location = mapView.myLocation, mapLocationSetted == false {
            updateMap(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}
