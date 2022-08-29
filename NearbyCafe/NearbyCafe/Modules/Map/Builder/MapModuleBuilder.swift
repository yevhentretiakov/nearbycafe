//
//  MapAssembly.swift
//  NearbyCafe
//
//  Created by user on 26.08.2022.
//

import UIKit

// MARK: - Protocol

protocol MapModuleBuilderProtocol {
    func createMapModule() -> UIViewController
}

class MapModuleBuilder: MapModuleBuilderProtocol {
    // MARK: - Methods
    
    func createMapModule() -> UIViewController {
        let view = MapViewController()
        let router = MapModuleRouter(viewController: view)
        let googleServiceManager = GoogleServicesManager()
        let networkManager = NetworkManager()
        let locationManager = LocationManager()
        let presenter = MapViewPresenter(view: view,
                                         router: router,
                                         googleServiceManager: googleServiceManager,
                                         networkManager: networkManager,
                                         locationManager: locationManager)
        view.presenter = presenter
        return view
    }
}

