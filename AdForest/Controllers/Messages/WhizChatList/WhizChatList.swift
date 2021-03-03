//
//  WhizChatList.swift
//  AdForest
//
//  Created by Apple on 03/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class WhizChatList: UITableViewCell {


    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
//    @IBOutlet weak var lblMsgContent: UILabel!
    @IBOutlet weak var lblAdTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!{
        didSet{
            imgUser.layer.borderWidth = 0.5
            imgUser.layer.masksToBounds = false
            imgUser.layer.borderColor = UIColor.lightGray.cgColor
            imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
            imgUser.clipsToBounds = true
        }
    }
    @IBOutlet weak var mainContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
