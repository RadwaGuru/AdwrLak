//
//  LinkedinNib.swift
//  AdForest
//
//  Created by Apple on 05/10/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class LinkedinNib: UITableViewCell {

    @IBOutlet weak var btnActionLInkedin: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ContainerView: UIView!{
        didSet{
            ContainerView.layer.borderWidth = 1
            ContainerView.layer.borderColor = UIColor.black.cgColor
            ContainerView.layer.cornerRadius = 5
        }
    }
    var btnActionLoginByLinkedin: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ActionBtnLinkedIn(_ sender: Any) {
        self.btnActionLoginByLinkedin?()
    }
}
