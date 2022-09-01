//
//  ListModuleRouter.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 29.08.2022.
//

import UIKit

// MARK: - Protocols
protocol ListModuleRouter {
    func close()
}

final class DefaultListModuleRouter: DefaultBaseRouter, ListModuleRouter {
    func close() {
        close(animated: true)
    }
}
