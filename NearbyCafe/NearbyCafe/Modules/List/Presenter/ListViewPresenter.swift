//
//  MapViewPresenter.swift
//  NearbyCafe
//
//  Created by user on 24.08.2022.
//

import Foundation

// MARK: - Protocols

protocol ListViewPresenterProtocol {
    var places: [PlaceModel] { get set }
}

class ListViewPresenter: ListViewPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: ListViewController?
    var places = [PlaceModel]()
    private let router: RouterProtocol
    
    // MARK: - Life Cycle Methods
    
    init(view: ListViewController, places: [PlaceModel], router: RouterProtocol) {
        self.view = view
        self.places = places
        self.router = router
    }
}
