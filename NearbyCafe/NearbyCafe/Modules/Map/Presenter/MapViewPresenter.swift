//
//  Presenter.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 23.08.2022.
//

import UIKit
import CoreLocation

// MARK: - Protocols

protocol MapView: AnyObject {
    func updateMap(with places: [PlaceModel], location: Location)
    func presentAlert(title: String, message: String)
}

protocol MapViewPresenter {
    func viewDidLoad()
    func checkLocationManagerAuthorization()
    func showPlacesList()
}

final class DefaultMapViewPresenter: MapViewPresenter {
    // MARK: - Properties
    
    private weak var view: MapView?
    private let router: MapModuleRouter
    private let googleServiceManager = DefaultGoogleServicesManager()
    private let networkManager: NetworkManager
    private var locationManager: LocationManager
    private var places = [PlaceModel]()
    private let placeTypes = ["cafe", "restaurant"]
    
    // MARK: - Life Cycle Method
    
    init(view: MapView,
         router: MapModuleRouter,
         networkManager: NetworkManager,
         locationManager: LocationManager
    ) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
        self.locationManager = locationManager
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
        locationManager.setDelegate(self)
        locationManager.checkLocationManagerAuthorization()
    }
    
    func checkLocationManagerAuthorization() {
        locationManager.checkLocationManagerAuthorization()
    }
    
    func showPlacesList() {
        router.showPlacesList(with: places)
    }
}

// MARK: - LocationManagerDelegateProtocol

extension DefaultMapViewPresenter: LocationManagerDelegate {
    func didReceiveLocation(location: CLLocation) {
        getPlaces(location: Location(latitude: location.coordinate.latitude,
                                     longitude: location.coordinate.longitude))
    }
}
