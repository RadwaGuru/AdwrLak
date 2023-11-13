//
//  TextFieldCell.swift
//  AdForest
//
//  Created by apple on 5/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
//import ActionSheetPicker_3_0

protocol AddDataDelegate {
    func addToFieldsArray(obj: AdPostField, index: Int, isFrom: String, title: String)
}

protocol textValDelegate {
    func textVal(value: String,indexPath: Int, fieldType:String, section: Int,fieldNam:String)
}

class TextFieldCell: UITableViewCell, UITextFieldDelegate,DatePickerPopupViewDelegate {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var txtType: UITextField!{
        didSet{
            txtType.delegate = self
        }
    }
    
    //MARK:- Properties
    //var delegate: AddDataDelegate?
    var fieldName = ""
    var objSaved = AdPostField()
    var selectedIndex = 0
    //var delegate : textFieldValueDelegate?
    var inde = 0
    var section = 0
    var delegate : textValDelegate?
    var fieldType = "textfield"
    var s = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        if UserDefaults.standard.bool(forKey: "isRtl") {
            txtType.textAlignment = .right
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        objSaved.fieldVal = txtType.text
        if txtType.text == "" || txtType.text == nil {
            s.isHidden = false
        }else{
            s.isHidden = true
        }
       // self.delegate?.addToFieldsArray(obj: objSaved, index: selectedIndex, isFrom: "textfield", title: "")
    }
    func datePickerPopupView(_ view: DatePickerPopupView, didSelectDate date: Date) {
           // Handle the selected date here
           let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
           let formattedDate = dateFormatter.string(from: date)
           print("Selected date: \(formattedDate)")
        self.txtType.text = formattedDate
                    self.delegate?.textVal(value:formattedDate , indexPath: self.inde ,fieldType: "textfield",section:self.section,fieldNam: self.fieldName)
       }
    @IBAction func txtEditingStart(_ sender: UITextField) {
//        s.isHidden = true
        if fieldName == "ad_bidding_time" && fieldType == "textfield"{
            sender.isEnabled = false
            
            
            let popupView = DatePickerPopupView(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
            popupView.center = (UIApplication.shared.keyWindow?.rootViewController?.view.center)!
            popupView.delegate = self
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(popupView)

//            let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: Date(), doneBlock: {
//                picker, value, index in
//                print("value = \(value!)")
//                print("index = \(index!)")
//                print("picker = \(picker!)")
//                let dateFormatter = DateFormatter()
////                dateFormatter.dateFormat = "yyyy-MM-dd"
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let selectedDate = dateFormatter.string(from: value as! Date)
//                self.txtType.text = selectedDate
//                self.delegate?.textVal(value:selectedDate , indexPath: self.inde ,fieldType: "textfield",section:self.section,fieldNam: self.fieldName)
//                 sender.isEnabled = true
//                return
//            }, cancel: { ActionStringCancelBlock in return }, origin: sender as! UIView)
//            datePicker?.show()
            sender.isEnabled = true
//            let timePicker: UIPickerView = UIPickerView()
//            //assign delegate and datasoursce to its view controller
//            timePicker.delegate = self
//            timePicker.dataSource = self
//
//            // setting properties of the pickerView
//            timePicker.frame = CGRect(x: 0, y: 50, width: self.contentView.frame.width, height: 200)
//            timePicker.backgroundColor = .white
//            // add pickerView to the view
//            self.contentView.addSubview(timePicker)
        }else{
             sender.isEnabled = true
        }
       

        
        
    }
    
    @IBAction func txtEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            s.isHidden = true
            delegate?.textVal(value: text, indexPath: inde,fieldType: "textfield",section:section,fieldNam: fieldName)
        }
    }
    
    
}
//extension TextFieldCell: UIPickerViewDelegate, UIPickerViewDataSource{
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return 60
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return String(format: "%02d", row)
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if component == 0{
//            let minute = row
//            print("minute: \(minute)")
//        }else{
//            let second = row
//            print("second: \(second)")
//        }
//    }
//}
import UIKit
protocol DatePickerPopupViewDelegate: AnyObject {
    func datePickerPopupView(_ view: DatePickerPopupView, didSelectDate date: Date)

}
class DatePickerPopupView: UIView {

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        // Optionally set a minimum and maximum date if needed
        // picker.minimumDate = Date()
        // picker.maximumDate = someDate
        return picker
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    weak var delegate: DatePickerPopupViewDelegate?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Setup Views

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 8.0
        layer.masksToBounds = false // Allow the shadow to be displayed
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 4


        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: topAnchor).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8.0).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0).isActive = true
    }

    // MARK: - Actions

    @objc private func doneButtonTapped() {
        // Handle the done button tap here
        // For example, you can use a delegate to notify the parent view controller
        // that the date selection is done and pass the selected date
        let selectedDate = datePicker.date
        delegate?.datePickerPopupView(self, didSelectDate: selectedDate)
        removeFromSuperview()

    }
 }
