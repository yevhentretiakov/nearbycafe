//
//  ListTableViewCell.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPlace(place: Place) {
        self.nameLabel.text = place.name
        self.rateLabel.text = String(place.rating)
        
        DispatchQueue.global().async {
            if let url = URL(string: place.icon), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.icon.image = UIImage(data: data)
                }
            }
        }
        
        self.addressLabel.text = place.address
    }
}
