//
//  NewRadioColorCollectionViewCell.swift
//  AdForest
//
//  Created by Apple on 24/11/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import LTHRadioButton
class NewRadioColorCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var btnAction: UIButton!{
//        didSet{
//            btnAction.isHidden = true
//        }
//    }
//    @IBOutlet weak var imgRadio: UIImageView!

    @IBOutlet weak var radioBtn: LTHRadioButton!
    //MARK:- Properties
    var dataArray = [AdPostValue]()
    var data : AdPostValue?
    var radioButtonCell: NewRadioColorTableViewCell!
    var indexPath = 0
    var id = ""
//    private let selectedColor   = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
//    private let deselectedColor = UIColor.lightGray

    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.selectionStyle = .none
        
        
    }
//     func setSelected(_ selected: Bool, animated: Bool) {
////        super.setSelected(selected, animated: animated)
//        
//        if selected {
//            return radioBtn.select(animated: animated)
//        }
//        
//        radioBtn.deselect(animated: animated)
//    }

    func initializeData(value: AdPostValue, radioButtonCellRef: NewRadioColorTableViewCell, index: Int) {
        data = value
        indexPath = index
        radioButtonCell = radioButtonCellRef
        // buttonRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
//    func update(with color: UIColor) {
//        backgroundColor             = color
//        radioBtn.selectedColor   = color == .darkGray ? .white : selectedColor
//        radioBtn.deselectedColor = color == .darkGray ? .lightGray : deselectedColor
//    }

}
