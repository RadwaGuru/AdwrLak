//
//  NewRadioColorInnerTableViewCell.swift
//  AdForest
//
//  Created by Apple on 24/11/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import LTHRadioButton
//import UIButtonExtension
import KGRadioButton

class NewRadioColorInnerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorbtnRadio: UIButton!
    @IBOutlet weak var radioColorBtn: KGRadioButton!
//    @IBOutlet weak var radioBtn: LTHRadioButton!
    //    @IBOutlet weak var imgRadio: UIImageView!
//
//
//    @IBOutlet weak var btnRadio: UIButton!
//
//
//    //MARK:- Properties
    var dataArray = [AdPostValue]()
    var data : AdPostValue?
    var radioButtonCell: NewRadioColorTableViewCell!
    var indexPath = 0
    var id = ""
//    var btnClick: (()->())?
//
//
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        radioColorBtn.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)

    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    func initializeData(value: AdPostValue, radioButtonCellRef: NewRadioColorTableViewCell, index: Int) {
        data = value
        indexPath = index
        radioButtonCell = radioButtonCellRef
        colorbtnRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    func initCellItem() {
        let deselectedImage = UIImage(named: "uncheck")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
        colorbtnRadio.setImage(deselectedImage, for: .normal)
        colorbtnRadio.setImage(selectedImage, for: .selected)
        colorbtnRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    @objc func radioButtonTapped(_ radioButton: UIButton) {
        
        if (radioButtonCell.dataArray[indexPath].isChecked) {
            colorbtnRadio.setBackgroundImage(#imageLiteral(resourceName: "empty (1)"), for: .normal)
            //  data?.isSelected = false
            radioButtonCell.dataArray[indexPath].isChecked = false
//            seletedRadio = (radioButton.titleLabel?.text)!
        }
        else {
//            seletedRadio = (radioButton.titleLabel?.text!)!
            colorbtnRadio.setBackgroundImage(#imageLiteral(resourceName: "radio-on-button"), for: .normal)
            // data?.isSelected = true
            radioButtonCell.dataArray[indexPath].isChecked = true
        }
        
        for (i, value) in radioButtonCell.dataArray.enumerated() {
            if i != indexPath {
                radioButtonCell.dataArray[i].isChecked = false
            }
        }
        radioButtonCell.tableView.reloadData()
    }
    
    func deselectOtherButton() {
        let tableView = self.superview?.superview as! UITableView
        let tappedCellIndexPath = tableView.indexPath(for: self)!
        let section = tappedCellIndexPath.section
        let rowCounts = tableView.numberOfRows(inSection: section)
        
        for row in 0..<rowCounts {
            if row != tappedCellIndexPath.row {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! RadioButtonTableViewCell
                cell.buttonRadio.isSelected = false
            }
        }
    }


    
//    @objc func manualAction (sender: KGRadioButton) {
//         sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            print("Selected")
//        } else{
//            print("Not Selected")
//        }
//    }

    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        if selected {
//            return radioBtn.select(animated: animated)
//        }
//        
//        radioBtn.deselect(animated: animated)
//    }

//    func initCellItem() {
//        let deselectedImage = UIImage(named: "uncheck")?.withRenderingMode(.alwaysTemplate)
//        let selectedImage = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
//        imgRadio.image = deselectedImage
//        imgRadio.image = selectedImage
//
//        //        btnRadio.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
//    }
//    @IBAction func actionBtnRadio(_ sender: UIButton) {
////        self.btnClick?()
//
//        if (radioButtonCell.dataArray[indexPath].isChecked) {
////            imgRadio.image = UIImage(named: "radio-on-button")
//            imgRadio.image = imgRadio.image?.withRenderingMode(.alwaysTemplate)
//            imgRadio.tintColor = UIColor(hex: dataArray[indexPath].id)
//
////            buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "empty (1)"), for: .normal)
//            radioButtonCell.dataArray[indexPath].isChecked = false
////            seletedRadio = (radioButton.titleLabel?.text)!
//        }
//        else {
//            imgRadio.image = nil
////            seletedRadio = (radioButton.titleLabel?.text!)!
////            buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "radio-on-button"), for: .normal)
//            radioButtonCell.dataArray[indexPath].isChecked = true
//        }
//
//        for (i, value) in radioButtonCell.dataArray.enumerated() {
//            if i != indexPath {
//                radioButtonCell.dataArray[i].isChecked = false
//            }
//        }
////        radioButtonCell.tableView.reloadData()
//
//    }
//    func deselectOtherButton() {
//        let tableView = self.superview?.superview as! UITableView
//        let tappedCellIndexPath = tableView.indexPath(for: self)!
//        let section = tappedCellIndexPath.section
//        let rowCounts = tableView.numberOfRows(inSection: section)
//
//        for row in 0..<rowCounts {
//            if row != tappedCellIndexPath.row {
//                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! NewRadioColorInnerTableViewCell
//                cell.btnRadio.isSelected = false
//            }
//        }
//    }




}
