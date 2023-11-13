//
//  CalendarCell.swift
//  AdForest
//
//  Created by Apple on 8/29/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
//import ActionSheetPicker_3_0

protocol DateFieldsDelegateMax {
    func DateValuesMax(MaxDate: String,MinDate: String, fieldType: String, indexPath: Int,fieldTypeName:String)
}

class CalendarCell: UITableViewCell, DatePickerPopupViewDelegate {


    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var oltDate: UIButton! {
        didSet {
            oltDate.contentHorizontalAlignment = .left
        }
    }
    
    @IBOutlet weak var btnDateMax: UIButton!{
        didSet {
            btnDateMax.contentHorizontalAlignment = .left
        }
    }
    
    //MARK:- Properties
    var currentDate = ""
    var maxDate = ""
    var fieldName = ""
    var indexP = 0
    let bgColor = UserDefaults.standard.string(forKey: "mainColor")
    var delegateMax: DateFieldsDelegateMax?
    var fieldTypeNam = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 35.0, width: oltDate.frame.size.width + 18, height: 0.5)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        oltDate.layer.addSublayer(bottomBorder)
        
        let bottomBorder2 = CALayer()
        bottomBorder2.frame = CGRect(x: 0.0, y: 35.0, width: btnDateMax.frame.size.width + 18, height: 0.5)
        bottomBorder2.backgroundColor = UIColor.lightGray.cgColor
        btnDateMax.layer.addSublayer(bottomBorder2)
        
        selectionStyle = .none
     
    }
    func datePickerPopupView(_ view: DatePickerPopupView, didSelectDate date: Date) {
           // Handle the selected date here
           let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
           let formattedDate = dateFormatter.string(from: date)
           print("Selected date: \(formattedDate)")
        self.oltDate.setTitle(formattedDate, for: .normal)
                   self.currentDate = formattedDate
                   self.delegateMax?.DateValuesMax(MaxDate: (self.btnDateMax.titleLabel?.text)! , MinDate: self.currentDate,  fieldType: "textfield_date" , indexPath: self.indexP,fieldTypeName:self.fieldTypeNam)
       }
    @IBAction func actionCalendar(_ sender: Any) {
        let popupView = DatePickerPopupView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        popupView.center = (UIApplication.shared.keyWindow?.rootViewController?.view.center)!
        popupView.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(popupView)

//        let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
//            picker, value, index in
//            print("value = \(value!)")
//            print("index = \(index!)")
//            print("picker = \(picker!)")
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//
//            let selectedDate = dateFormatter.string(from: value as! Date)
//            self.oltDate.setTitle(selectedDate, for: .normal)
//            self.currentDate = selectedDate
//            self.delegateMax?.DateValuesMax(MaxDate: (self.btnDateMax.titleLabel?.text)! , MinDate: self.currentDate,  fieldType: "textfield_date" , indexPath: self.indexP,fieldTypeName:self.fieldTypeNam)
//            return
//        }, cancel: { ActionStringCancelBlock in return }, origin: sender as! UIView)
//        datePicker?.show()
    }
    
    @IBAction func btnMaxDateClicked(_ sender: UIButton) {
        let popupView = DatePickerPopupView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        popupView.center = (UIApplication.shared.keyWindow?.rootViewController?.view.center)!
        popupView.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(popupView)
//        let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
//            picker, value, index in
//            print("value = \(value!)")
//            print("index = \(index!)")
//            print("picker = \(picker!)")
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//
//            let selectedDate = dateFormatter.string(from: value as! Date)
//            self.btnDateMax.setTitle(selectedDate, for: .normal)
//            self.maxDate = selectedDate
//            self.delegateMax?.DateValuesMax(MaxDate: self.maxDate , MinDate:(self.oltDate.titleLabel?.text)! ,  fieldType: "textfield_date" , indexPath: self.indexP,fieldTypeName:self.fieldTypeNam)
//
//            return
//        }, cancel: { ActionStringCancelBlock in return }, origin: sender as! UIView)
//        datePicker?.show()
        
    }
    
    
    
}
