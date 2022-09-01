//
//  MapViewPresenter.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 24.08.2022.
//

import Foundation

// MARK: - Protocols
protocol ListView: AnyObject {
    func updateView()
}

protocol ListViewPresenter {
    func close()
    func viewDidLoad()
    func getItem(at index: Int) -> PlaceModel
    func getItemsCount() -> Int
}

final class DefaultListViewPresenter: ListViewPresenter {
    // MARK: - Properties
    private weak var view: ListView?
    private var places = [PlaceModel]()
    private let router: ListModuleRouter
    
    // MARK: - Life Cycle Methods
    init(view: ListView, places: [PlaceModel], router: ListModuleRouter) {
        self.view = view
        self.places = places
        self.router = router
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        view?.updateView()
    }
    
    func getItem(at index: Int) -> PlaceModel {
        return places[index]
    }
    
    func getItemsCount() -> Int {
        return places.count
    }
    
    func close() {
        router.close()
    }
}
