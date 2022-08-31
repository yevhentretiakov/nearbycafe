//
//  MapRouter.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 26.08.2022.
//

import UIKit

// MARK: - Protocol
protocol MapModuleRouter {
    func showPlacesList(with places: [PlaceModel])
}

final class DefaultMapModuleRouter: BaseRouter, MapModuleRouter {
    // MARK: - Methods
    func showPlacesList(with places: [PlaceModel]) {
        let listViewController = DefaultListModuleBuilder().createListModule(with: places)
        show(viewController: listViewController,
                isModal: false,
                animated: true)
    }
}
