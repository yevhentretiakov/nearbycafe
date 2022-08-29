//
//  DefaultRouter.swift
//  NearbyCafe
//
//  Created by user on 29.08.2022.
//

import UIKit

class MainRouter {
    // MARK: - Properties
    private let viewController: UIViewController
    private var navigationController: UINavigationController? {
        viewController.navigationController
    }
    
    // MARK: - Life Cycle Methods
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    func present(viewController: UIViewController, isModal: Bool, animated: Bool, completion: EmptyBlock? = nil) {
        if isModal || navigationController == nil {
            UIApplication.rootViewController?.present(viewController, animated: animated)
        } else {
            navigationController?.pushViewController(viewController, animated: animated)
        }
        completion?()
    }
    
    func popToViewController(viewController: UIViewController, animated: Bool, completion: EmptyBlock? = nil) {
        navigationController?.popToViewController(viewController, animated: animated)
        completion?()
    }
    
    func popToViewContoller(at index: Int, animated: Bool, completion: EmptyBlock? = nil) {
        if let viewContolller = navigationController?.viewControllers[index] {
            navigationController?.popToViewController(viewContolller, animated: animated)
        }
        completion?()
    }
    
    func popToRootViewController(animated: Bool, completion: EmptyBlock? = nil) {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: animated)
        } else {
            viewController.dismiss(animated: animated)
        }
        completion?()
    }
    
    func dismissViewController(animated: Bool, completion: EmptyBlock? = nil) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            viewController.dismiss(animated: animated)
        }
        completion?()
    }
}
