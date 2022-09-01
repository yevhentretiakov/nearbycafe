//
//  UIViewController.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 12.08.2022.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions {
            actions.forEach { action in
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        return presentingIsModal || presentingIsNavigation
    }
}
