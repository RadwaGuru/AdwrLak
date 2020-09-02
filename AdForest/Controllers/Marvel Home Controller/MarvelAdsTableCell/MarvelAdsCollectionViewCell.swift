//
//  MarvelAdsCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 01/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelAdsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
            containerView.marvelRoundCorners()
        }
    }
    
    @IBOutlet weak var adImg: UIImageView!{
        didSet{
            adImg.marvelRoundCorners()
        }
        
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var locationIcon: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                locationIcon.image = locationIcon.image?.withRenderingMode(.alwaysTemplate)
                locationIcon.tintColor = UIColor(hex: mainColor)
                
                
            }
        }
    }
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    static let identifier = "MarvelAdsCollectionViewCell"

    @IBOutlet weak var btnViewAll: UIButton!
    var btnFullAction: (()->())?
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }

}
