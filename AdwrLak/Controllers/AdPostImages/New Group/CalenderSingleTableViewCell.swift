//
//  CalenderSingleTableViewCell.swift
//  AdForest
//
//  Created by Furqan Nadeem on 15/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
//import ActionSheetPicker_3_0


protocol textValDateDelegate {
    func textValDate(value: String,indexPath: Int, fieldType:String, section: Int,fieldNam:String)
}

class CalenderSingleTableViewCell: UITableViewCell,DatePickerPopupViewDelegate {

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
    
    @IBOutlet weak var txtDate: UITextField!
      
    //MARK:- Properties
    var currentDate = ""
    var maxDate = ""
    var fieldName = ""
    var indexP = 0
    let bgColor = UserDefaults.standard.string(forKey: "mainColor")
    var delegate: textValDateDelegate?
    var index = 0
    var section = 0
    //var delegateMax: DateFieldsDelegateMax?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: 35.0, width: oltDate.frame.size.width + 18, height: 0.5)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        oltDate.layer.addSublayer(bottomBorder)
        
       
        selectionStyle = .none
        
    }
    func datePickerPopupView(_ view: DatePickerPopupView, didSelectDate date: Date) {
           // Handle the selected date here
           let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
           let formattedDate = dateFormatter.string(from: date)
           print("Selected date: \(formattedDate)")
        self.txtDate.text = formattedDate
                    self.currentDate = formattedDate
                    self.delegate?.textValDate(value: formattedDate, indexPath: self.indexP, fieldType: "textfield_date", section: self.section,fieldNam:self.fieldName)
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
//            //self.oltDate.setTitle(selectedDate, for: .normal)
//            self.txtDate.text = selectedDate
//            self.currentDate = selectedDate
//            self.delegate?.textValDate(value: selectedDate, indexPath: self.indexP, fieldType: "textfield_date", section: self.section,fieldNam:self.fieldName)
//
//
//            return
//        }, cancel: { ActionStringCancelBlock in return }, origin: sender as! UIView)
//        datePicker?.show()
    }
  
}
