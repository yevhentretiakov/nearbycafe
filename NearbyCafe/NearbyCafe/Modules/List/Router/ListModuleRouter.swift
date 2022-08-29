//
//  ListModuleRouter.swift
//  NearbyCafe
//
//  Created by user on 29.08.2022.
//

import UIKit

// MARK: - Protocols
protocol ListModuleRouterProtocol {
    func close()
}

class ListModuleRouter: MainRouter, ListModuleRouterProtocol {
    // MARK: - Methods
    func close() {
        dismissViewController(animated: true)
    }
}
