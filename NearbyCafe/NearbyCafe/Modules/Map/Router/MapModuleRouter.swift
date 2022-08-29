//
//  MapRouter.swift
//  NearbyCafe
//
//  Created by user on 26.08.2022.
//

import UIKit

// MARK: - Protocol
protocol MapModuleRouterProtocol {
    func showPlacesList(places: [PlaceModel])
}

class MapModuleRouter: MainRouter, MapModuleRouterProtocol {
    // MARK: - Methods
    func showPlacesList(places: [PlaceModel]) {
        let listViewController = ListModuleBuilder().createListModule(places: places)
        present(viewController: listViewController,
                isModal: false,
                animated: true)
    }
}
