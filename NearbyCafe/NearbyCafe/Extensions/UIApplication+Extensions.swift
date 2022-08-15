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
            print("aa")
            if UIApplication.shared.canOpenURL(url) {
                print("cc")
                UIApplication.shared.open(url)
            }
         }
    }
}
