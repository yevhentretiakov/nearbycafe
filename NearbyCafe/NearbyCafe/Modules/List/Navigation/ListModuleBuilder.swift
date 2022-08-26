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
        let presenter = ListViewPresenter(view: view, places: places)
        view.presenter = presenter
        
        return view
    }
}
