//
//  Router.swift
//  NearbyCafe
//
//  Created by user on 24.08.2022.
//

import UIKit

// MARK: - Protocols
protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showPlacesList(places: [PlaceModel])
}

class Router: RouterProtocol {
    // MARK: - Properties
    
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    // MARK: - Life Cycle Methods
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    // MARK: - Methods
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mapViewController = assemblyBuilder?.createMapModule(router: self) else { return }
            navigationController.viewControllers = [mapViewController]
        }
    }
    
    func showPlacesList(places: [PlaceModel]) {
        if let navigationController = navigationController {
            guard let detailViewController = assemblyBuilder?.createListModule(places: places, router: self) else { return }
            navigationController.pushViewController(detailViewController, animated: true)
        }
    }
}
