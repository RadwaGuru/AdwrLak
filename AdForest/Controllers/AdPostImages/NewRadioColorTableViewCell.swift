//
//  NewRadioColorTableViewCell.swift
//  AdForest
//
//  Created by Apple on 24/11/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class NewRadioColorTableViewCell: UITableViewCell, UITableViewDelegate,UITableViewDataSource  {
    
    
    
        @IBOutlet weak var tableView: UITableView!{
            didSet{
                tableView.delegate = self
                tableView.dataSource = self
            }
       }
    
    
//    @IBOutlet weak var collectionView: UICollectionView!{
//        didSet{
//            collectionView.delegate = self
//            collectionView.dataSource = self
//            collectionView.allowsMultipleSelection = false
//        }
//
//    }
    @IBOutlet weak var containerView: UIView!
    
    
    //MARK:- Properties
    
    var dataArray = [AdPostValue]()
    var data : AdPostValue?
    var radioButtonCell: NewRadioColorTableViewCell!
    var indexPath = 0
    var id = ""
    
    
    //MARK:- Loading View from Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        if selected {
        //            return radioBtn.select(animated: animated)
        //        }
        //        //
        //        radioBtn.deselect(animated: animated)
        // Configure the view for the selected state
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: NewRadioColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRadioColorCollectionViewCell", for: indexPath) as! NewRadioColorCollectionViewCell
//        let objData = dataArray[indexPath.row]
//        if objData.isChecked == true{
//            //            cell.radioBtn.selectedColor = UIColor(hex: dataArray[indexPath.row].id)
//            //            cell.imgViewRadio.image = UIImage(named: "radio-on-button")
//            //            cell.imgViewRadio.tintColor = UIColor(hex: dataArray[indexPath.row].id)
//
//        }
//        //        cell.radioBtn.deselectedColor = UIColor(hex: objData.id)
//
//        //        cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
//        //        cell.imgViewRadio.tintColor = UIColor(hex: objData.id)
//        cell.dataArray = dataArray
//        id = cell.id
//        print(objData.id)
//        cell.reloadInputViews()
//        cell.initializeData(value: objData, radioButtonCellRef: self, index: indexPath.row)
//        cell.radioBtn.onSelect {
//            cell.radioBtn.selectedColor = UIColor(hex: objData.id)
//            cell.radioBtn.useTapGestureRecognizer = true
//
//            //UIColor(hex: self.dataArray[indexPath.row].id)
//            //            cell.imgViewRadio.image = UIImage(named: "radio-on-button")
//            //            cell.imgViewRadio.image = cell.imgViewRadio.image?.withRenderingMode(.alwaysTemplate)
//            //            cell.imgViewRadio.tintColor = UIColor(hex: dataArray[indexPath.row].id)
////            self.id = self.dataArray[indexPath.row].id
////            cell.radioBtn.isSelected = true
//            //            selectedColor = self.dataArray[indexPath.row].id
//            //            isselected = true
//        }
////        if cell.radioBtn.isSelected{
////            cell.radioBtn.select(animated: true)
////        }
//        cell.radioBtn.deselect(animated: true)
//
//        return cell
//    }
    
    
    //    //MARK:- TableView DELEGate Methods
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataArray.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: NewRadioColorInnerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewRadioColorInnerTableViewCell", for: indexPath) as! NewRadioColorInnerTableViewCell
            let objData = dataArray[indexPath.row]
    //        if let title = objData.name {
    //            cell.lblName.text = title
    //            cell.buttonRadio.titleLabel?.text = title
    //        }
            //print(objData.isSelected, indexPath.row)
    //        seletedRad = cell.seletedRadio
//                    cell.imgRadio.image = cell.imgRadio.image?.withRenderingMode(.alwaysTemplate)
//                    cell.imgRadio.tintColor = UIColor(hex: objData.id)
//            cell.radioBtn.selectedColor = UIColor(hex: dataArray[indexPath.row].id)
//            cell.radioBtn.deselectedColor = UIColor(hex: objData.id)
//            cell.radioColorBtn.outerCircleColor = UIColor(hex: objData.id)
//            cell.colorbtnRadio.backgroundColor = UIColor(hex: objData.id)
//            cell.colorbtnRadio.setTitle("Sasasass", for: .normal)

            //tintColor = UIColor(hex: objData.id)
            //backgroundColor = UIColor(hex: objData.id)
            if objData.isChecked {
                
//                cell.radioBtn.selectedColor = UIColor(hex: dataArray[indexPath.row].id)

//                cell.imgRadio.image = UIImage(named: "radio-on-button")
//                cell.imgRadio.tintColor = UIColor(hex: dataArray[indexPath.row].id)
    //            cell.buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "radio-on-button"), for: .normal)
    //            cell.buttonRadio.isSelected = true
    //            delegate?.radVal(rVal: seletedRad, fieldType: "radio", indexPath: index, isSelected: objData.isChecked,fieldNam:fieldName)
            }else {
//                cell.radioBtn.deselectedColor = UIColor(hex: objData.id)
//
//                cell.imgRadio.image = cell.imgRadio.image?.withRenderingMode(.alwaysTemplate)
//                cell.imgRadio.tintColor = UIColor(hex: objData.id)
    
    //            cell.imgRadio.image = UIImage(named: "empty")
    //            cell.buttonRadio.setBackgroundImage(#imageLiteral(resourceName: "empty (1)"), for: .normal)
            }
            cell.initializeData(value: objData, radioButtonCellRef: self, index: indexPath.row)
            
    //        cell.btnClick = { [self] () in
    //            cell.imgRadio.image = UIImage(named: "radio-on-button")
    //            cell.imgRadio.image = cell.imgRadio.image?.withRenderingMode(.alwaysTemplate)
    //            cell.imgRadio.tintColor = UIColor(hex: dataArray[indexPath.row].id)
    //
    ////            id = dataArray[indexPath.row].id
    ////            selectedColor = dataArray[indexPath.row].id
    ////            isselected = true
    ////            self.delegate?.colorVal(colorCode: selectedColor, fieldType: "radio_color", indexPath: index, isSelected: true,fieldNam: fieldName)
    //            for (i, value) in self.dataArray.enumerated() {
    //                if i != indexPath.row {
    //                    self.dataArray[i].isChecked = false
    //                }
    //            }
    //        }

            return cell
        }
    
      func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        print("will select")
        return indexPath
    }
//
//    override  func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
//        return indexPath
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        
    }
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell: NewRadioColorInnerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewRadioColorInnerTableViewCell", for: indexPath) as! NewRadioColorInnerTableViewCell
//        let objData = dataArray[indexPath.row]
//        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
//        if cell.radioBtn.isSelected{
//            cell.radioBtn.selectedColor = UIColor(hex: dataArray[indexPath.row].id)
//        }
//        else{
//            cell.radioBtn.deselect()
//        }
//    }
    ////    func deselectOtherButton() {
    ////        let tableView = self.superview?.superview as! UITableView
    ////        let tappedCellIndexPath = tableView.indexPath(for: self)!
    ////        let section = tappedCellIndexPath.section
    ////        let rowCounts = tableView.numberOfRows(inSection: section)
    ////
    ////        for row in 0..<rowCounts {
    ////            if row != tappedCellIndexPath.row {
    ////                let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as! NewRadioColorTableViewCell
    //////                cell.btnRadio.isSelected = false
    ////            }
    ////        }
    ////    }
    //
    //
    
    
}
//class ViewController: UITableViewController {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
//    }
//
//
//    // MARK: - Cells
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NewRadioColorInnerTableViewCell",
//                                                 for: indexPath) as! NewRadioColorInnerTableViewCell
//        cell.selectionStyle = .none
//
//        return cell
//    }
//
//
//
//    // MARK: - Selection
//
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
//        return indexPath
//    }
//
//    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
//        return indexPath
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let top = UIApplication.shared.statusBarFrame.height
//        tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
//        tableView.allowsMultipleSelection = false
//        tableView.register(NewRadioColorInnerTableViewCell.self, forCellReuseIdentifier: "NewRadioColorInnerTableViewCell")
//    }
//}
//
//
