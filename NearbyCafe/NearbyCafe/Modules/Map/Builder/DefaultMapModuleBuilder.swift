//
//  MapAssembly.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 26.08.2022.
//

import UIKit

// MARK: - Protocol

protocol MapModuleBuilder {
    func createMapModule() -> UIViewController
}

final class DefaultMapModuleBuilder: MapModuleBuilder {
    // MARK: - Methods
    
    func createMapModule() -> UIViewController {
        let view = MapViewController()
        let router = DefaultMapModuleRouter(viewController: view)
        let networkManager = NetworkManager()
        let locationManager = LocationManager()
        let presenter = MapViewPresenter(view: view,
                                         router: router,
                                         networkManager: networkManager,
                                         locationManager: locationManager)
        view.presenter = presenter
        return UINavigationController(rootViewController: view)
    }
}

