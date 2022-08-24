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
    
    var presenter: MapViewPresenterProtocol!
    
    private let googleServiceManager = GoogleServicesManager()
    private let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)
    private let zoomLevel: Float = 12
    
    private var mapView: GMSMapView!
    
    private let roundButtonDiameter: CGFloat = 60
    private lazy var centerButton: RoundButton = {
        let button = RoundButton(frame: CGRect(x: 0, y: 0, width: roundButtonDiameter, height: roundButtonDiameter))
        button.setImage(UIImage(systemName: "location.north.fill"), for: .normal)
        button.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var listButton: RoundButton = {
        let button = RoundButton(frame: CGRect(x: 0, y: 0, width: roundButtonDiameter, height: roundButtonDiameter))
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        presenter.setupLocationManager()
    }
    
    // MARK: - View Methods
    
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
    
    private func addMarker(place: PlaceModel) {
        let position = CLLocationCoordinate2D(latitude: place.geometry.location.latitude, longitude: place.geometry.location.longitude)
        let marker = GMSMarker(position: position)
        
        marker.title = place.name
        marker.snippet = place.address
        
        marker.map = mapView
    }
    
    private func setMapCamera(latitude: Double, longitude: Double) {
        let camera = GMSCameraPosition.camera(
            withLatitude: latitude,
            longitude: longitude,
            zoom: self.zoomLevel
        )
        self.mapView.camera = camera
    }
    
    private func addPlacesMarkers(places: [PlaceModel]) {
        self.mapView.clear()
        places.forEach { place in
            self.addMarker(place: place)
        }
    }
    
    @objc private func centerButtonTapped() {
        presenter.startUpdatingLocation()
    }
    
    @objc private func listButtonTapped() {
        presenter.showPlacesList()
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
            centerButton.heightAnchor.constraint(equalToConstant: roundButtonDiameter),
            centerButton.widthAnchor.constraint(equalToConstant: roundButtonDiameter),
            centerButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            centerButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func layoutListButton() {
        mapView.addSubview(listButton)
        
        listButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listButton.heightAnchor.constraint(equalToConstant: roundButtonDiameter),
            listButton.widthAnchor.constraint(equalToConstant: roundButtonDiameter),
            listButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            listButton.bottomAnchor.constraint(equalTo: centerButton.topAnchor, constant: -10)
        ])
    }
}

// MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
    func updateMap(latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            self.addPlacesMarkers(places: self.presenter.places)
            self.setMapCamera(latitude: latitude, longitude: longitude)
        }
    }
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.showAlert(title: title, message: message)
        }
    }
}
