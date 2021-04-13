//
//  BannerCarouselCollectionViewCell.swift
//  AdForest
//
//  Created by Apple on 07/04/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class BannerCarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
//    {
//        didSet{
//            containerView.addShadowToView()
//        }
//    }
    @IBOutlet weak var imgViewCarousel: UIImageView!{
        didSet{
            imgViewCarousel.roundCorners()
        }
    }
    @IBOutlet weak var btnBannerClick: UIButton!
//MARK:-Properties
    var btnFullAction: (()->())?
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func ActionBannerImage(_ sender: Any) {
        self.btnFullAction?()
    }
}
