//
//  Presenter.swift
//  NearbyCafe
//
//  Created by user on 23.08.2022.
//

import Foundation
import CoreLocation

// MARK: - Protocols

protocol MapViewProtocol: AnyObject {
    func updateMap(latitude: Double, longitude: Double)
    func showAlert(title: String, message: String)
}

protocol MapViewPresenterProtocol {
    var places: [PlaceModel] { get set }
    func setupLocationManager()
    func startUpdatingLocation()
    func showPlacesList()
}

class MapViewPresenter: MapViewPresenterProtocol {
    // MARK: - Properties
    
    weak var view: MapViewProtocol?
    private let router: RouterProtocol
    private let networkManager = NetworkManager()
    private let locationManager = LocationManager()
    var places = [PlaceModel]()
    private let placeTypes = ["cafe", "restaurant"]
    
    // MARK: - Life Cycle Method
    
    init(view: MapViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    // MARK: - Methods
    
    private func getPlaces(latitude: Double, longitude: Double, completion: @escaping EmptyBlock) {
        for type in placeTypes {
            networkManager.get(PlaceListResponse.self,
                               from: .getNearbyPlaces(latitude: latitude,
                                                      longitude: longitude,
                                                      type: type)) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let receivedPlaces):
                    self.places = receivedPlaces?.results ?? []
                    completion()
                case .failure(let error):
                    self.view?.showAlert(title: "Network Error", message: error.rawValue)
                }
            }
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func showPlacesList() {
        router.showPlacesList(places: places)
    }
}

// MARK: - LocationManagerDelegateProtocol

extension MapViewPresenter: LocationManagerDelegateProtocol {
    func didReceiveLocation(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        getPlaces(latitude: latitude,
                  longitude: longitude){
            self.view?.updateMap(latitude: latitude,
                                 longitude: longitude)
        }
    }
}
