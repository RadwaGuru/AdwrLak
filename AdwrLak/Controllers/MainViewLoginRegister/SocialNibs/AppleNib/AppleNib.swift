//
//  AppleNib.swift
//  AdForest
//
//  Created by Apple on 05/10/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class AppleNib: UITableViewCell {
    @IBOutlet weak var ContainerView: UIView!{
        didSet{
            ContainerView.layer.borderWidth = 1
            ContainerView.layer.borderColor = UIColor.black.cgColor
            ContainerView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var btnActionApple: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var btnActionLoginByApple: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ActionAppleBtn(_ sender: Any) {
        self.btnActionLoginByApple?()
    }
}
