//
//  ListModuleRouter.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 29.08.2022.
//

import UIKit

// MARK: - Protocols
protocol ListModuleRouter {
    func close(animated: Bool, completion: EmptyBlock?)
}

final class DefaultListModuleRouter: DefaultBaseRouter, ListModuleRouter {

}
