//
//  GuestNib.swift
//  AdForest
//
//  Created by Apple on 05/10/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class GuestNib: UITableViewCell {
    @IBOutlet weak var COntainerView: UIView!{
        didSet{
            COntainerView.layer.borderWidth = 1
            COntainerView.layer.borderColor = UIColor.black.cgColor
            COntainerView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var btnGuestLogin: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var btnActionLoginByGuest: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func ActionBtnGuest(_ sender: Any) {
        self.btnActionLoginByGuest?()
    }
    
}
