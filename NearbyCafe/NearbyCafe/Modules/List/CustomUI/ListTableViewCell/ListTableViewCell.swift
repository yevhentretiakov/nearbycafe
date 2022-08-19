//
//  ListTableViewCell.swift
//  NearbyCafe
//
//  Created by user on 10.08.2022.
//

import UIKit

final class ListTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let cellID = "ListTableViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    // MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPlace(place: PlaceModel) {
        self.nameLabel.text = place.name
        self.rateLabel.text = String(place.rating)
        
        DispatchQueue.global().async {
            if let url = URL(string: place.icon), let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.icon.image = UIImage(data: data)
                }
            }
        }
        
        self.addressLabel.text = place.vicinity
    }
}
