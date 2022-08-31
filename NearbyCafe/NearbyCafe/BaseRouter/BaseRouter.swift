//
//  DefaultRouter.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 29.08.2022.
//

import UIKit

// MARK: - Protocols
protocol BaseRouter {
    func show(viewController: UIViewController, isModal: Bool, animated: Bool, completion: EmptyBlock?)
    func popToViewController(viewController: UIViewController, animated: Bool, completion: EmptyBlock?)
    func popToRootViewController(animated: Bool, completion: EmptyBlock?)
    func close(animated: Bool, completion: EmptyBlock?)
}

class DefaultBaseRouter: BaseRouter {
    // MARK: - Properties
    let viewController: UIViewController
    private var navigationController: UINavigationController? {
        viewController.navigationController
    }
    
    // MARK: - Life Cycle Methods
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    func show(viewController: UIViewController, isModal: Bool, animated: Bool, completion: EmptyBlock? = nil) {
        if isModal {
            let presentingViewController = navigationController ?? viewController
            presentingViewController.present(viewController, animated: animated) {
                completion?()
            }
        } else {
            navigationController?.pushViewController(viewController, animated: animated)
            receiveTransitionCompletion {
                completion?()
            }
        }
    }
    
    func popToViewController(viewController: UIViewController, animated: Bool, completion: EmptyBlock? = nil) {
        navigationController?.popToViewController(viewController, animated: animated)
        receiveTransitionCompletion {
            completion?()
        }
    }
    
    func popToRootViewController(animated: Bool, completion: EmptyBlock? = nil) {
        navigationController?.popToRootViewController(animated: animated)
        receiveTransitionCompletion {
            completion?()
        }
    }
    
    func close(animated: Bool, completion: EmptyBlock? = nil) {
        if viewController.isModal {
            dismiss(animated: animated) {
                completion?()
            }
        } else {
            pop(animated: animated) {
                completion?()
            }
        }
    }
    
    private func dismiss(animated: Bool, completion: EmptyBlock? = nil) {
        viewController.dismiss(animated: animated) {
            completion?()
        }
    }
    
    private func pop(animated: Bool, completion: EmptyBlock? = nil) {
        navigationController?.popViewController(animated: animated)
        receiveTransitionCompletion {
            completion?()
        }
    }
    
    private func receiveTransitionCompletion(completion: EmptyBlock?) {
        if let coordinator = navigationController?.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            completion?()
        }
    }
}
