//
//  AssemblyModuleBuilder.swift
//  NearbyCafe
//
//  Created by user on 23.08.2022.
//

import UIKit

// MARK: - Protocols

protocol AssemblyBuilderProtocol {
    func createMapModule(router: RouterProtocol) -> UIViewController
    func createListModule(places: [PlaceModel], router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    // MARK: - Methods
    
    func createMapModule(router: RouterProtocol) -> UIViewController {
        let view = MapViewController()
        let presenter = MapViewPresenter(view: view, router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createListModule(places: [PlaceModel], router: RouterProtocol) -> UIViewController {
        let view = ListViewController()
        let presenter = ListViewPresenter(view: view, places: places, router: router)
        view.presenter = presenter
        
        return view
    }
}
