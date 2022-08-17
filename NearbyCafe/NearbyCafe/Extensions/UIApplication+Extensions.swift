//
//  UIApplication+Extensions.swift
//  NearbyCafe
//
//  Created by user on 12.08.2022.
//

import UIKit

extension UIApplication {
    static func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
         }
    }
}
