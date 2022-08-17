//
//  MapViewController.swift
//  NearbyCafe
//
//  Created by user on 08.08.2022.
//

import UIKit
import GoogleMaps

final class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let locationManager = LocationManager()
    private let networkService = NetworkManager()
    private let googleServiceManager = GoogleServicesManager()
    
    private var places = [PlaceModel]()
    
    // This variable needs to prevent map auto update every time when location is received and allow this update only first time
    private var mapView: GMSMapView!
    private var mapLocationSetted = false
    private let placeTypes = ["cafe", "restaurant"]
    private let zoomLevel: Float = 12
    private let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    private lazy var centerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        button.cornerRadius = 60 / 2
        button.setShadow()
        return button
    }()
    
    private lazy var laterAction = UIAlertAction(title: "Later", style: UIAlertAction.Style.destructive, handler: nil)
    private lazy var settingsAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {_ in
        UIApplication.openAppSettings()
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupLocationManager()
    }
    
    // MARK: - View Methods
    
    private func setupLocationManager() {
        locationManager.startUpdateLocation()
        locationManager.delegate = self
    }
    
    private func setupMap() {
        // create map view
        mapView = GMSMapView.map(withFrame: view.frame, camera: GMSCameraPosition())
        setMapCamera(latitude: defaultLocation.coordinate.latitude,
                     longitude: defaultLocation.coordinate.longitude)
        
        mapView.isMyLocationEnabled = true
        
        layoutMap()
        layoutCenterButton()
    }
    
    private func showMapAlert() {
        showAlert(title: "Can't get your location",
                  message: "Share your location to fully use the app.",
                  actions: [laterAction,settingsAction])
    }
    
    private func getPlaces(latitude: Double, longitude: Double) {
        for type in placeTypes {
            networkService.get(PlaceListResponse.self,
                               from: .getNearbyPlaces(latitude: latitude,
                                                      longitude: longitude,
                                                      type: type)) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let receivedPlaces):
                    if let receivedPlaces = receivedPlaces {
                        self.places = receivedPlaces.results
                        self.addPlacesMarkers()
                    }
                case .failure(let error):
                    self.showAlert(title: "Network Error", message: error.rawValue)
                }
            }
        }
    }
    
    private func addPlacesMarkers() {
        mapView.clear()
        
        places.forEach { place in
            DispatchQueue.main.async {
                self.addMarker(latitude: place.geometry.location.latitude,
                          longitude: place.geometry.location.longitude,
                          title: place.name,
                          snippet: place.vicinity)
            }
        }
    }
    
    private func addMarker(latitude: Double, longitude: Double, title: String? = nil, snippet: String? = nil) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        
        marker.title = title
        marker.snippet = snippet
        
        marker.map = mapView
    }
    
    private func setMapCamera(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(
            withLatitude: latitude,
            longitude: longitude,
            zoom: zoomLevel
        )
        mapView.camera = camera
    }
    
    private func updateMap(latitude: Double, longitude: Double) {
        mapLocationSetted = true
        getPlaces(latitude: latitude, longitude: longitude)
        addPlacesMarkers()
        setMapCamera(latitude: latitude, longitude: longitude)
    }
    
    @objc private func centerButtonTapped() {
        if let location = locationManager.currentLocation {
            updateMap(latitude: location.coordinate.latitude,
                      longitude: location.coordinate.longitude)
        } else {
            showMapAlert()
        }
    }
    
    // MARK: - Layout Methods
    
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
}

// MARK: - LocationManagerDelegateProtocol

extension MapViewController: LocationManagerDelegateProtocol {
    func didReceivedLocation(location: CLLocation) {
        if let location = locationManager.currentLocation, mapLocationSetted == false {
            updateMap(latitude: location.coordinate.latitude,
                      longitude: location.coordinate.longitude)
        }
    }
}
