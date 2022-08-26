//
//  MapRouter.swift
//  NearbyCafe
//
//  Created by user on 26.08.2022.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol MapModuleRouterProtocol {
    func showPlacesList(places: [PlaceModel])
}

class MapModuleRouter: MapModuleRouterProtocol {
    // MARK: - Properties
    
    private weak var view: MapViewProtocol?
    
    // MARK: - Life Cycle Methods
    
    init(view: MapViewProtocol) {
        self.view = view
    }
    
    // MARK: - Methods

    func showPlacesList(places: [PlaceModel]) {
        if let navigationController = (view as? UIViewController)?.navigationController {
            let listViewController = ListModuleBuilder().createListModule(places: places)
            navigationController.pushViewController(listViewController, animated: true)
        }
    }
}
