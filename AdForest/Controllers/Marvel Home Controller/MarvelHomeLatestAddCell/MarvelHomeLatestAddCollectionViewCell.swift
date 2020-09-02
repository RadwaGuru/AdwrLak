//
//  MarvelHomeLatestAddCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 01/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelHomeLatestAddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
                
            }
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                locationIcon.image = locationIcon.image?.withRenderingMode(.alwaysTemplate)
                locationIcon.tintColor = UIColor(hex: mainColor)
                
                
            }
            
        }
        
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var adImg: UIImageView!{
        didSet{
            adImg.marvelRoundCorners()
        }
    }
  
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.addShadowToView()
            cellView.marvelRoundCorners()
        }
    }
    
    
    @IBOutlet weak var btnViewAll: UIButton!
    var btnFullAction: (()->())?
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
}
}
