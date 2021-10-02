//
//  OTPControllerViewController.swift
//  AdForest
//
//  Created by Apple on 16/09/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class OTPControllerViewController: UIViewController,NVActivityIndicatorViewable {

    @IBOutlet weak var btnSubmit: UIButton!{
        didSet{
            btnSubmit.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK:- Properties
    let storyboard2 = UIStoryboard(name: "Main2", bundle: nil)
    var calledFrom = ""
    var defaults = UserDefaults.standard
    var phVerifcation = ""
    var otpTxt = ""
    var submit = ""
    var placeholderField = ""
    var codeSentTo = ""
    var notReceived = ""
    var tryAgain = ""
    var verifyNumber = ""
    var phonePlaceholder = ""
    var enterPhoneerror = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title  = phVerifcation
        lblHeading.text = phVerifcation
        lblSubHeading.text = otpTxt
        btnSubmit.setTitle(submit, for: .normal)
        txtPhoneNumber.placeholder = placeholderField
        txtPhoneNumber.keyboardType = .phonePad
        self.showBackButton()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:-Custom Loader
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    @IBAction func ActionBtnSubmit(_ sender: Any) {
        if txtPhoneNumber.text == "" {
            self.showToast(message: enterPhoneerror)
        }
        else{
            if calledFrom == "Login"{
                let param: [String: Any] = [
                    "phone": txtPhoneNumber.text!,
                ]
                print(param)
                adForest_CheckloginUser(parameters: param as NSDictionary)

            }
            else{
                let parameters : [String: Any] = [
                    "phone": txtPhoneNumber.text!,
                ]
                print(parameters)
                defaults.set(txtPhoneNumber.text!, forKey: "email")
                self.adForest_AlreadyRegisterUser(param: parameters as NSDictionary)
            }
        }

    }
    //MARK:- Already User Register
    func adForest_AlreadyRegisterUser(param: NSDictionary) {
        self.showLoader()
        UserHandler.CheckAlreadyRegisterUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let verifyVC = self.storyboard2.instantiateViewController(withIdentifier: "FirebasePhoneNumberVerificationViewController") as! FirebasePhoneNumberVerificationViewController
                verifyVC.modalPresentationStyle = .custom
                verifyVC.codeSentTo = self.codeSentTo
                verifyVC.codeNotReceived = self.notReceived
                verifyVC.resendCode = self.tryAgain
                verifyVC.verifyNumber = self.verifyNumber
                verifyVC.isFrom = "Register"
                verifyVC.userName = "self.txtName.text!"
                verifyVC.phoneNumber = self.txtPhoneNumber.text!
                self.navigationController?.pushViewController(verifyVC, animated: true)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    // MARK:- CheckLoginUser
    func adForest_CheckloginUser(parameters: NSDictionary) {
        showLoader()
        UserHandler.CheckLoginUser(parameter: parameters, success: { successResponse in
            self.stopAnimating()
            if successResponse.success {
                let verifyVC = self.storyboard2.instantiateViewController(withIdentifier: "FirebasePhoneNumberVerificationViewController") as! FirebasePhoneNumberVerificationViewController
                verifyVC.modalPresentationStyle = .custom

                verifyVC.codeSentTo = "self.codeSentToText"
                verifyVC.codeNotReceived = "self.notReceived"
                verifyVC.resendCode = "self.tryAgain"
                verifyVC.verifyNumber = "self.verifyNumberText"
                verifyVC.isFrom = "Login"
                verifyVC.userName = successResponse.data.userName
                    //"qwerty123456"
                    
                verifyVC.phoneNumber = self.txtPhoneNumber.text!
                verifyVC.isVerifyOn = true
                    //self.isVerifyOn
                self.navigationController?.pushViewController(verifyVC, animated: true)

            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { error in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
