//
//  MapViewPresenter.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 24.08.2022.
//

import Foundation

// MARK: - Protocols
protocol ListViewProtocol: AnyObject {
    func updateView()
}

protocol ListViewPresenterProtocol {
    func close()
    func viewDidLoad()
    func getItem(at index: Int) -> PlaceModel
    func getItemsCount() -> Int
}

final class ListViewPresenter: ListViewPresenterProtocol {
    // MARK: - Properties
    private weak var view: ListViewProtocol?
    private var places = [PlaceModel]()
    private let router: ListModuleRouter
    
    // MARK: - Life Cycle Methods
    init(view: ListViewProtocol, places: [PlaceModel], router: ListModuleRouter) {
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
        router.close(animated: true, completion: nil)
    }
}
