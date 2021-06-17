//
//  FirebasePhoneNumberVerificationViewController.swift
//  AdForest
//
//  Created by Apple on 07/04/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView
import JGProgressHUD
class FirebasePhoneNumberVerificationViewController: UIViewController, OTPDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var otpView: UIView!{
        didSet{
            otpView.backgroundColor = Constants.hexStringToUIColor(hex: "#ffffff")
        }
    }
    
    @IBOutlet weak var bgView: UIView!{
        didSet{
            bgView.backgroundColor = Constants.hexStringToUIColor(hex: "#ffffff")
        }
    }
    @IBOutlet weak var btnSubmit: UIButton!{
        didSet{
            if let bgColor = defaults.string(forKey: "mainColor") {
                //                btnSubmit.layer.cornerRadius = 20
                btnSubmit.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    @IBOutlet weak var requestOTPagain: UIButton!{
        didSet{
            if let bgColor = defaults.string(forKey: "mainColor") {
                requestOTPagain.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var lblPhonenumber: UILabel!
    @IBOutlet weak var btnResendCode: UIButton!
    
    @IBOutlet weak var lblnotRcv: UILabel!
    //MARK:-Properties
    var barButtonItems = [UIBarButtonItem]()
    var currentVerificationId = ""
    var phoneNumber = ""
    var codeSentTo = ""
    var codeNotReceived = ""
    var resendCode = ""
    var verifyNumber = ""
    var count = 60  // 60sec if you want
    var resendTimer = Timer()
    var otpStackView = OTPStackView()
    var defaults = UserDefaults.standard
    var isFrom = ""
    var userName = ""
    var isVerifyOn = false
    var homeStyle: String = UserDefaults.standard.string(forKey: "homeStyles")!
    
    let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.verifyNumber
        
        self.lblPhonenumber.text = ("\(codeSentTo)\(phoneNumber)")
        self.lblnotRcv.text = codeNotReceived
        self.btnSubmit.setTitle(self.verifyNumber, for: .normal)
        self.lblnotRcv.isHidden = true
        let yourBackImage = UIImage(named: "backbutton")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        otpView.addSubview(otpStackView)
        otpStackView.heightAnchor.constraint(equalTo: otpView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpView.centerYAnchor).isActive = true
        otpStackView.delegate = self
        let bgColor = defaults.string(forKey: "mainColor")
        otpStackView.activeFieldBorderColor = Constants.hexStringToUIColor(hex: bgColor!)
        otpStackView.inactiveFieldBorderColor = Constants.hexStringToUIColor(hex: bgColor!)
        otpStackView.setAllFieldColor(color: Constants.hexStringToUIColor(hex: bgColor!))
        self.requestOTP()
        resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func update() {
        if(count > 0) {
            count = count - 1
            print(count)
            btnResendCode.setTitle("00:\(count)", for: .normal)
            btnResendCode.isUserInteractionEnabled = false
        }
        else {
            resendTimer.invalidate()
            btnResendCode.isUserInteractionEnabled = true
            lblnotRcv.isHidden = false
            self.btnResendCode.setTitle(self.resendCode, for: .normal)
            
            // if you want to reset the time make count = 60 and resendTime.fire()
        }
    }
    
    @IBAction func ActionRequestOTPAgain(_ sender: Any) {
        self.requestOTP()
    }
    @IBAction func ActionSUbmitBtn(_ sender: Any) {
        debugPrint("txtFied Data:\(otpStackView.getOTP())")
        
        let verificationCode = otpStackView.getOTP()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                let alert = Constants.showBasicAlert(message: authError.description)
                self.presentVC(alert)
                print(authError.description)
                return
            }
            
            // User has signed in successfully and currentUser object is valid
            debugPrint("PhonneNumber Verified User:: \(Auth.auth().currentUser?.phoneNumber)")
            let currentUserInstance = Auth.auth().currentUser
            if Auth.auth().currentUser?.phoneNumber == self.phoneNumber{
                if self.isFrom == "Register"{
                    let parameter : [String: Any] = ["phone": self.phoneNumber,"name":self.userName]
                    print(parameter)
                    //                    self.defaults.set(self.userName, forKey: "email")
                    //                    self.defaults.set("1122", forKey: "password")
                    self.defaults.set(true, forKey: "otp")
                    self.adForest_RegisterOTPUser(param: parameter as NSDictionary)
                    
                }else if self.isFrom == "Login"{
                    let param : [String : Any] = [
                        "phone" : self.phoneNumber,
                        "name": self.userName
                        
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "otp")
                    self.defaults.set(true, forKey: "isLogin")
                    self.defaults.setValue(self.phoneNumber, forKey: "phoneNumber")
                    self.defaults.set(self.userName, forKey: "email")
                    self.defaults.set("1122", forKey: "password")
                    
                    self.adForest_loginOTPUser(parameters: param as NSDictionary)
                    
                }
                else{
                    let parameter : [String: Any] = ["phone_number": self.phoneNumber]
                    print(parameter)
                    self.adForest_verifyCode(parameter: parameter as NSDictionary)
                    
                }
            }
        }
    }
    func didChangeValidity(isValid: Bool) {
        print(isValid)
    }
    
    func requestOTP(){
        Auth.auth().languageCode = "en"
        //        phoneNumber = "+923316789159"
        //        let phoneNumber = "+16505554567"
        
        //"+923137633303"
        
        // Step 4: Request SMS
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                let alert = Constants.showBasicAlert(message: error.localizedDescription)
                self.presentVC(alert)
                
                return
            }
            
            // Either received APNs or user has passed the reCAPTCHA
            // Step 5: Verification ID is saved for later use for verifying OTP with phone number
            print(verificationID)
            self.currentVerificationId = verificationID!
            
        }
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func navigationbuttons() {
        
        //Location Search
        let locationButton = UIButton(type: .custom)
        if #available(iOS 11, *) {
            locationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            locationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else {
            locationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        locationButton.setBackgroundImage(image, for: .normal)
        locationButton.tintColor = UIColor.white
        //        locationButton.addTarget(self, action: #selector(onClicklocationButton), for: .touchUpInside)
        let barButtonLocation = UIBarButtonItem(customView: locationButton)
        //       if defaults.bool(forKey: "showNearBy") {
        self.barButtonItems.append(barButtonLocation)
        //     }
        
        
        self.navigationItem.rightBarButtonItems = barButtonItems
        
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    //MARK:-API Calls
    // Login Userx
    func adForest_loginOTPUser(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.LoginOTPUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
         
                self.defaults.set(true, forKey: "isLogin")
                self.defaults.set(successResponse.data.userName, forKey: "email")
                self.defaults.set("1122", forKey: "password")
                
                self.defaults.synchronize()
                
                if self.homeStyle == "home1"{
                    self.appDelegate.moveToHome()
                    
                }else if self.homeStyle == "home2"{
                    self.appDelegate.moveToMultiHome()
                }
                else if self.homeStyle == "home3"{
                    self.appDelegate.moveToMarvelHome()
                }
                
            } else {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    let confirmationVC = self.storyboard1.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                    confirmationVC.isFromVerification = true
                    confirmationVC.user_id = successResponse.data.id
                    self.navigationController?.pushViewController(confirmationVC, animated: true)
                })
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    // adForest_RegisterOTPUser
    func adForest_RegisterOTPUser(param: NSDictionary) {
        self.showLoader()
        UserHandler.RegisterOTPUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                
                self.defaults.set(successResponse.data.userName, forKey: "email")
                self.defaults.set("1122", forKey: "password")
                self.defaults.set(true, forKey: "isLogin")
                self.defaults.synchronize()
                if self.homeStyle == "home1"{
                    self.appDelegate.moveToHome()
                    
                }else if self.homeStyle == "home2"{
                    self.appDelegate.moveToMultiHome()
                }
                else if self.homeStyle == "home3"{
                    self.appDelegate.moveToMarvelHome()
                }
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
    
    //    MAverifyFireBaseCode
    
    
    func adForest_verifyCode(parameter: NSDictionary) {
        self.showLoader()
        UserHandler.verifyFireBaseCode(param: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = successResponse.message as! String
                hud.detailTextLabel.text = nil
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.position = .bottomCenter
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2.0)
                self.perform(#selector(self.disMiss), with: nil, afterDelay: 2)
                UserDefaults.standard.set(true, forKey: "can")
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    @objc func disMiss(){
        self.dismissVC(completion: nil)
    }
    
}

