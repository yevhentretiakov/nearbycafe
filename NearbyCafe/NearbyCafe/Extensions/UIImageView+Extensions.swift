//
//  UIImageView+Extensions.swift
//  NearbyCafe
//
//  Created by user on 22.08.2022.
//

import UIKit

extension UIImageView {
    func configureImage(imageUrl: String) {
        DispatchQueue.global().async {
            if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
