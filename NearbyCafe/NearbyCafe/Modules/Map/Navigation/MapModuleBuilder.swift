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
        let router = MapModuleRouter(view: view)
        let presenter = MapViewPresenter(view: view, router: router)
        view.presenter = presenter
        
        return view
    }
}

