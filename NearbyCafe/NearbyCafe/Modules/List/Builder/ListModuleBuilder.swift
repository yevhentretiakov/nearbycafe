//
//  ListModuleBuilder.swift
//  NearbyCafe
//
//  Created by user on 26.08.2022.
//

import UIKit

// MARK: - Protocol
protocol ListModuleBuilderProtocol {
    func createListModule(places: [PlaceModel]) -> UIViewController
}

class ListModuleBuilder: ListModuleBuilderProtocol {
    // MARK: - Methods
    func createListModule(places: [PlaceModel]) -> UIViewController {
        let view = ListViewController()
        let router = ListModuleRouter(viewController: view)
        let presenter = ListViewPresenter(view: view, places: places, router: router)
        view.presenter = presenter
        return view
    }
}
