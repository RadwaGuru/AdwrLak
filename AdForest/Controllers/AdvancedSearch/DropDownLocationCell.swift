//
//  DropDownLocationCell.swift
//  AdForest
//
//  Created by Apple on 13/05/2022.
//  Copyright © 2022 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DropDown

class DropDownLocationCell: UITableViewCell ,NVActivityIndicatorViewable , SubCategoryDelegate {
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.addShadowToView()
        }
    }
    
    
    //MARK:- Properties
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var dropDownKeysArray = [String]()
    var dropDownValuesArray = [String]()
    var fieldTypeName = [String]()
    var hasSubArray = [Bool]()
    var hasTemplateArray = [Bool]()
    var hasCategoryTempelateArray = [Bool]()
    var delegate : selectValue?
    var fieldNam = ""
    var indexes = 0
    var section = 0
    var btnPopupAction : (()->())?
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let valueDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.valueDropDown
        ]
    }()
    
    var selectedKey = ""
    var selectedValue = ""
    var param = ""
    var fieldName = ""
    var hasSub = false
    var hasTempelate = false
    var hasCategoryTempelate = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK:- SetUp Drop Down
    func accountDropDown() {
        valueDropDown.anchorView = locationBtn
        valueDropDown.dataSource = dropDownValuesArray
        valueDropDown.selectionAction = { [unowned self]
            (index, item) in
            print(index)
            self.locationBtn.setTitle(item, for: .normal)
            self.selectedKey = self.dropDownKeysArray[index]
            self.selectedValue = item
            self.param = self.fieldTypeName[index]
            print(self.param)
            self.hasSub = self.hasSubArray[index]
            self.hasTempelate = self.hasTemplateArray[index]
            self.hasCategoryTempelate = self.hasCategoryTempelateArray[index]
            if self.param == "ad_country" {
                let url = Constants.URL.baseUrl+Constants.URL.categorySublocations
                print(url)
                let param: [String: Any] = ["ad_country": self.selectedKey]
                self.adForest_subCategory(url: url, param: param as NSDictionary)
                self.delegate?.selectValue(selectVal: self.selectedValue, selectKey: self.selectedKey, fieldType: "select",section: self.section,indexPath: indexes, fieldTypeName: self.fieldNam)
                
            }
        }
    }
    //MARK:- Delegate Method
    
    func subCategoryDetails(name: String, id: Int, hasSubType: Bool, hasTempelate: Bool, hasCatTempelate: Bool) {
        print(name, id, hasSubType, hasTempelate, hasCatTempelate)
        if hasSubType {
            if self.param == "ad_country" {
                let url = Constants.URL.baseUrl+Constants.URL.categorySublocations
                print(url)
                let param: [String: Any] = ["ad_country": id]
                print(param)
                self.adForest_subCategory(url: url, param: param as NSDictionary)
                self.delegate?.selectValue(selectVal: self.selectedKey, selectKey: self.selectedKey, fieldType: "select", section: self.section,indexPath: indexes, fieldTypeName: self.fieldNam)
            }
        }
        else {
            locationBtn.setTitle(name, for: .normal)
            self.selectedKey = String(id)
            self.selectedValue = name
            self.delegate?.selectValue(selectVal: String(id), selectKey: self.selectedKey, fieldType: "select", section: self.section,indexPath: indexes, fieldTypeName: self.fieldNam)
        }
    }
    //MARK:- API Call
    func adForest_subCategory(url: String ,param: NSDictionary) {
        let searchObj = AdvancedSearchController()
        searchObj.showLoader()
        AddsHandler.subCategory(url: url, parameter: param, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objSearchCategory = successResponse.data
                let seacrhCatVC = self.storyboard.instantiateViewController(withIdentifier: "SearchCategoryDetail") as! SearchCategoryDetail
                
                seacrhCatVC.dataArray = successResponse.data.values
                seacrhCatVC.modalPresentationStyle = .overCurrentContext
                seacrhCatVC.modalTransitionStyle = .crossDissolve
                seacrhCatVC.delegate = self
                self.appDel.presentController(ShowVC: seacrhCatVC)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDel.presentController(ShowVC: alert)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.appDel.presentController(ShowVC: alert)
        }
    }
    @IBAction func btnLocationAction(_ sender: Any) {
        self.btnPopupAction?()
        
    }
}
