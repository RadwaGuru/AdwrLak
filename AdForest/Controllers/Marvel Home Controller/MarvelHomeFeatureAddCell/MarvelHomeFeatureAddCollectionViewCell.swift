//
//  MarvelHomeFeatureAddCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 28/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelHomeFeatureAddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }

    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var adImg: UIImageView!{
        didSet{
            adImg.marvelRoundCorners()
            
        }
        
    }

    
    @IBOutlet weak var btnViewAd: UIButton!
    @IBOutlet weak var locationIcon: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                locationIcon.image = locationIcon.image?.withRenderingMode(.alwaysTemplate)
                locationIcon.tintColor = UIColor(hex: mainColor)


            }
            
        }
        
    }
    
    @IBOutlet weak var featuredStarImg: UIImageView!
    @IBOutlet weak var containerView: UIView!{
        didSet{
//            containerView.backgroundColor = UIColor.clear
            containerView.addShadowToView()
            containerView.marvelRoundCorners()
            

        }
    }
   
    
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    var btnFullAction: (()->())?
       @IBAction func actionFullButton(_ sender: Any) {
           self.btnFullAction?()
       }
}
