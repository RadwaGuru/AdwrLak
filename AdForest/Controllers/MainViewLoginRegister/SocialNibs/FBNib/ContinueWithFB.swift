//
//  ContinueWithFB.swift
//  AdForest
//
//  Created by Apple on 05/10/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ContinueWithFB: UITableViewCell {

    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var conatinerView: UIView!{
        didSet{
            conatinerView.layer.borderWidth = 1
            conatinerView.layer.borderColor = UIColor.black.cgColor
            conatinerView.layer.cornerRadius = 5
        }
    }
    var btnActionLoginByFacebook: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ActionBtnAction(_ sender: Any) {
        self.btnActionLoginByFacebook?()

    }
}
