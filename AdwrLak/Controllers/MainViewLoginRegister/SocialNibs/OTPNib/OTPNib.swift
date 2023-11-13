//
//  OTPNib.swift
//  AdForest
//
//  Created by Apple on 05/10/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class OTPNib: UITableViewCell {

    @IBOutlet weak var btnActionOtp: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.black.cgColor
            containerView.layer.cornerRadius = 5
        }
    }
    var btnActionLoginByOTP: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ActionBtnOTP(_ sender: Any) {
        self.btnActionLoginByOTP?()
    }
}
