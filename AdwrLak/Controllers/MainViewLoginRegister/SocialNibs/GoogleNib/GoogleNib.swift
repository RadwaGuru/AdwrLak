//
//  GoogleNib.swift
//  AdForest
//
//  Created by Apple on 05/10/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class GoogleNib: UITableViewCell {

    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ContainerVIew: UIView!{
        didSet{
            ContainerVIew.layer.borderWidth = 1
            ContainerVIew.layer.borderColor = UIColor.black.cgColor
            ContainerVIew.layer.cornerRadius = 5
        }
    }
    var btnActionLoginByGoogle: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ActionBtnGoogle(_ sender: Any) {
        self.btnActionLoginByGoogle?()
    }
}
