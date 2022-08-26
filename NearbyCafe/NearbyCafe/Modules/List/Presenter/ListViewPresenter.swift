//
//  MapViewPresenter.swift
//  NearbyCafe
//
//  Created by user on 24.08.2022.
//

import Foundation

// MARK: - Protocols

protocol ListViewProtocol: AnyObject {
    func updateView()
}

protocol ListViewPresenterProtocol {
    func getItem(at index: Int) -> PlaceModel
    func getItemsCount() -> Int
}

class ListViewPresenter: ListViewPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var view: ListViewProtocol?
    private var places = [PlaceModel]()
    
    // MARK: - Life Cycle Methods
    
    init(view: ListViewProtocol, places: [PlaceModel]) {
        self.view = view
        self.places = places
        self.view?.updateView()
    }
    
    // MARK: - Methods
    
    func getItem(at index: Int) -> PlaceModel {
        return places[index]
    }
    
    func getItemsCount() -> Int {
        return places.count
    }
}
