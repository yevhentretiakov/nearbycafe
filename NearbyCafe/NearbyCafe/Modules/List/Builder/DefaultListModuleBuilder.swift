//
//  ListModuleBuilder.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 26.08.2022.
//

import UIKit

// MARK: - Protocol
protocol ListModuleBuilder {
    func createListModule(with places: [PlaceModel]) -> UIViewController
}

final class DefaultListModuleBuilder: ListModuleBuilder {
    // MARK: - Methods
    func createListModule(with places: [PlaceModel]) -> UIViewController {
        let view = ListViewController()
        let router = DefaultListModuleRouter(viewController: view)
        let presenter = DefaultListViewPresenter(view: view, places: places, router: router)
        view.presenter = presenter
        return view
    }
}
