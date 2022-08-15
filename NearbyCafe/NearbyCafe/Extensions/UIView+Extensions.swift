//
//  UIView+Extensions.swift
//  NearbyCafe
//
//  Created by user on 12.08.2022.
//

import UIKit

extension UIView {
    
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
    }
    
    func addShadow(color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
                   offset: CGSize = CGSize(width: 0.0, height: 2.0),
                   opacity: Float = 1.0,
                   radius: CGFloat = 2) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}
