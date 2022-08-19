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
    
    private var mapView: GMSMapView!
    private let placeTypes = ["cafe", "restaurant"]
    private let zoomLevel: Float = 12
    private let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    
    private lazy var centerButton: RoundButton = {
        let button = RoundButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var listButton: RoundButton = {
        let button = RoundButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupLocationManager()
    }
    
    // MARK: - View Methods
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func setupMap() {
        // create map view
        mapView = GMSMapView.map(withFrame: view.frame, camera: GMSCameraPosition())
        setMapCamera(latitude: defaultLocation.coordinate.latitude,
                     longitude: defaultLocation.coordinate.longitude)
        
        mapView.isMyLocationEnabled = true
        
        layoutMap()
        layoutCenterButton()
        layoutListButton()
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
                    self.places = receivedPlaces?.results ?? []
                    DispatchQueue.main.async {
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
            self.addMarker(place: place)
        }
    }
    
    private func addMarker(place: PlaceModel) {
        let position = CLLocationCoordinate2D(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude)
        let marker = GMSMarker(position: position)
        
        marker.title = place.name
        marker.snippet = place.vicinity
        
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
        getPlaces(latitude: latitude, longitude: longitude)
        addPlacesMarkers()
        setMapCamera(latitude: latitude, longitude: longitude)
    }
    
    @objc private func centerButtonTapped() {
        locationManager.startUpdatingLocation()
    }
    
    @objc private func listButtonTapped() {
        let viewController = ListViewController()
        viewController.places = places
        navigationController?.pushViewController(viewController, animated: true)
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
    
    private func layoutListButton() {
        mapView.addSubview(listButton)
        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listButton.heightAnchor.constraint(equalToConstant: 60),
            listButton.widthAnchor.constraint(equalToConstant: 60),
            listButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            listButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
}

// MARK: - LocationManagerDelegateProtocol

extension MapViewController: LocationManagerDelegateProtocol {
    func didReceiveLocation(location: CLLocation) {
        if let location = locationManager.currentLocation {
            updateMap(latitude: location.coordinate.latitude,
                      longitude: location.coordinate.longitude)
        }
    }
}
