//
//  UINavigationController+Extensions.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 01.09.2022.
//

import UIKit

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: EmptyBlock? = nil) {
        pushViewController(viewController, animated: animated)
        receiveTransitionCompletion(animated: animated, completion: completion)
    }
    
    func popToRootViewController(animated: Bool, completion: EmptyBlock? = nil) {
        popToRootViewController(animated: animated)
        receiveTransitionCompletion(animated: animated, completion: completion)
    }
    
    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: EmptyBlock? = nil) {
        popToViewController(viewController, animated: animated)
        receiveTransitionCompletion(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool, completion: EmptyBlock? = nil) {
        self.popViewController(animated: animated)
        receiveTransitionCompletion(animated: animated, completion: completion)
    }
    
    func receiveTransitionCompletion(animated: Bool, completion: EmptyBlock?) {
        guard let coordinator = self.transitionCoordinator, animated == true else {
            completion?()
            return
        }
        coordinator.animate(alongsideTransition: nil) { _ in
            completion?()
        }
    }
}
