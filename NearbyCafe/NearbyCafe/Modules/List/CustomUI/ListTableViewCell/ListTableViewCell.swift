//
//  ListTableViewCell.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Methods
    
    func configure(place: PlaceModel) {
        self.nameLabel.text = place.name
        self.rateLabel.text = String(place.rating)
        iconImageView.image = nil
        iconImageView.configureImage(imageUrl: place.imageUrl)
        self.addressLabel.text = place.address
    }
}
