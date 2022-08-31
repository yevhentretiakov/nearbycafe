//
//  UIImageView+Extensions.swift
//  NearbyCafe
//
//  Created by Yevhen Tretiakov on 22.08.2022.
//

import UIKit

extension UIImageView {
    func setImage(with imageUrl: String, completion: ImageBlock? = nil) {
        DispatchQueue.global().async {
            if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.image = image
                    completion?(image)
                }
            } else {
                completion?(nil)
            }
        }
    }
}
