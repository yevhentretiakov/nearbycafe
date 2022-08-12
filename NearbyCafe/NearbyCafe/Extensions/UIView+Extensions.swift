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
    
    func addShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}
