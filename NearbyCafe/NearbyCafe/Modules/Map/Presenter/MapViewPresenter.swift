//
//  Presenter.swift
//  NearbyCafe
//
//  Created by user on 23.08.2022.
//

import UIKit
import CoreLocation

// MARK: - Protocols

protocol MapViewProtocol: AnyObject {
    func updateMap(with places: [PlaceModel], location: Location)
    func presentAlert(title: String, message: String)
}

protocol MapViewPresenterProtocol {
    func viewDidLoad()
    func startUpdatingLocation()
    func showPlacesList()
}

class MapViewPresenter: MapViewPresenterProtocol {
    // MARK: - Properties
    
    private weak var view: MapViewProtocol?
    private let googleServiceManager = GoogleServicesManager()
    private let router: MapModuleRouterProtocol
    private let networkManager = NetworkManager()
    private let locationManager = LocationManager()
    private var places = [PlaceModel]()
    private let placeTypes = ["cafe", "restaurant"]
    
    // MARK: - Life Cycle Method
    
    init(view: MapViewProtocol, router: MapModuleRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    // MARK: - Methods
    
    private func getPlaces(location: Location) {
        for type in placeTypes {
            networkManager.get(PlaceListResponse.self,
                               from: .getNearbyPlaces(location: location,
                                                      type: type)) {  [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let receivedPlaces):
                    self.places = receivedPlaces?.results ?? []
                    DispatchQueue.main.async {
                        self.view?.updateMap(with: self.places, location: location)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.view?.presentAlert(title: "Network Error", message: error.rawValue)
                    }
                }
            }
        }
    }
    
    func viewDidLoad() {
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
        getPlaces(location: Location(latitude: location.coordinate.latitude,
                                     longitude: location.coordinate.longitude))
    }
}
