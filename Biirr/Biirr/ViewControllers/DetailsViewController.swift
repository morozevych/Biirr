//
//  DetailsViewController.swift
//  InfiniumTest
//
//  Created by andrii on 05/03/2021.
//

import UIKit
import Hero

class DetailsViewController: UIViewController {
    @IBOutlet weak var illustrationImageView: UIImageView!
    
    
    @IBOutlet weak var abvView: UIView!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var bitterView: UIView!
    @IBOutlet weak var bitterLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    public var beer : Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hero.isEnabled = true
    
        if let beer = beer{
            illustrationImageView.hero.id = beer.id

            if let str = beer.ibu,
               let ibu = Int(str){
                bitterView.isHidden = false
                if ibu > 50 {
                    bitterLabel.textColor = .white
                    bitterLabel.text = "Hipster Plus"
                    bitterView.backgroundColor = UIColor(red: 0.62, green: 0.50, blue: 0.11, alpha: 1.00)
                } else if ibu > 20{
                    bitterLabel.textColor = .black
                    bitterLabel.text = "Bitter"
                    bitterView.backgroundColor = UIColor(red: 0.99, green: 0.76, blue: 0.00, alpha: 1.00)                } else {
                    bitterLabel.textColor = .black
                    bitterLabel.text = "Smooth"
                    bitterView.backgroundColor = UIColor(red: 0.99, green: 0.90, blue: 0.58, alpha: 1.00)
                }
            } else{
                bitterView.isHidden = true
            }
            
            if let abv = beer.abv{
                abvView.isHidden = false
                abvLabel.text = abv + "%"
            } else {
                abvView.isHidden = true
            }
            
            titleLabel.text = beer.nameDisplay
            if let category = beer.style?.category?.name {
                categoryLabel.text = category
            } else {
                categoryLabel.text = ""
            }
            
            descriptionLabel.text = beer.beerDescription ?? "Description isn't currently available for this beer"
            
            
            if let imageURL = beer.labels?.medium {
                illustrationImageView.sd_setImage(with: URL(string: imageURL))
            }else {
                illustrationImageView.image = UIImage(named: "beerDefault")
            }
        }
    }
}
