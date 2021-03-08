//
//  beerTableViewCell.swift
//  InfiniumTest
//
//  Created by andrii on 05/03/2021.
//

import UIKit
import Hero
import SDWebImage

class BeerTableViewCell: UITableViewCell {
    @IBOutlet private weak var iconView:UIImageView!
    @IBOutlet private weak var nameLabel:UILabel!
    @IBOutlet private weak var categoryLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setBeer( _ beer: Beer) {
        nameLabel.text = beer.name
        if let category = beer.style?.category?.name {
            categoryLabel.text = category
        } else {
            categoryLabel.text = ""
        }
        
        iconView.hero.id = beer.id
        if let image = beer.labels?.medium{
            iconView.sd_setImage(with: URL(string: image))
        }else {
            iconView.image = UIImage(named: "beerDefault")
        }
    }
}
