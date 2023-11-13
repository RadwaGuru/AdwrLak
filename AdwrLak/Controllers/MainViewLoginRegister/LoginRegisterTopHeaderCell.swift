//
//  LoginRegisterTopHeaderCell.swift
//  AdForest
//
//  Created by Apple on 13/09/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class LoginRegisterTopHeaderCell: UITableViewCell {

    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
