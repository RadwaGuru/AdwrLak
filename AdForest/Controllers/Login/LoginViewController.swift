//
//  LoginViewController.swift
//  Adforest
//
//  Created by apple on 1/2/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import NVActivityIndicatorView
import SDWebImage
import UITextField_Shake
import AuthenticationServices
import CryptoKit
import Firebase
import AuthenticationServices
import LinkedinSwift


class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, GIDSignInUIDelegate, GIDSignInDelegate, UIScrollViewDelegate{
    
    //MARK:- Outlets
    
    @IBOutlet weak var topConstraintBtnGoogle2: NSLayoutConstraint!
    @IBOutlet weak var topConstraintBtnGoogle: NSLayoutConstraint!
    @IBOutlet weak var topConstraintBtnApple: NSLayoutConstraint!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var topConstraintBtnLinkedIn: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.isScrollEnabled = true
        }
    }
    @IBOutlet weak var containerViewImage: UIView!
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var buttonForgotPassword: UIButton!{
        didSet{
            buttonForgotPassword.contentHorizontalAlignment = .right
        }
    }
    @IBOutlet weak var buttonLinkedIn: UIButton!{
        didSet{
            buttonLinkedIn.roundCornors()
            buttonLinkedIn.layer.borderWidth = 1
            
        }
    }
    @IBOutlet weak var buttonSubmit: UIButton! {
        didSet {
            buttonSubmit.roundCorners()
            buttonSubmit.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lblOr: UILabel!
    //    @IBOutlet weak var buttonFBLogin: UIButton! {
    //        didSet {
    //            buttonFBLogin.roundCorners()
    //            buttonFBLogin.isHidden = true
    //        }
    //    }
    
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var buttonFBLogin: FBLoginButton!
    @IBOutlet weak var btnGoogleLog: GIDSignInButton!
    @IBOutlet weak var socialLoginHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonGoogleLogin: GIDSignInButton! {
        didSet {
            buttonGoogleLogin.roundCorners()
            buttonGoogleLogin.isHidden = true
        }
    }
    
    @IBOutlet weak var buttonGuestLogin: UIButton! {
        didSet {
            buttonGuestLogin.roundCorners()
            buttonGuestLogin.layer.borderWidth = 1
            buttonGuestLogin.isHidden = true
        }
    }
    
    @IBOutlet weak var buttonRegisterWithUs: UIButton! {
        didSet {
            buttonRegisterWithUs.layer.borderWidth = 0.4
            buttonRegisterWithUs.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var viewRegisterWithUs: UIView!
    @IBOutlet weak var containerViewSocialButton: UIView!
    
    
    //MARK:- Properties
    var getLoginDetails = [LoginData]()
    var defaults = UserDefaults.standard
    var isVerifyOn = false
    let loginManager = LoginManager()
    
    var isDelFb = UserDefaults.standard.bool(forKey: "delFb")
    var accessToken: LISDKAccessToken?


//    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "86fohl6w88kexu", clientSecret: "YAOoXObs6wU3aUg9", state: "dwweewg43v", permissions:["r_liteprofile", "r_emailaddress"], redirectUrl: "https://adforest-testapp.scriptsbundle.com/"), nativeAppChecker: WebLoginOnly)
    
    private let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "86fohl6w88kexu", clientSecret: "YAOoXObs6wU3aUg9", state: "dwweewg43v", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://adforest-testapp.scriptsbundle.com/"))
    
    // MARK: Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //self.adForest_loginDetails()
        txtFieldsWithRtl()
        btnGoogleLog.isHidden = true
        buttonGuestLogin.isHidden = true
        btnApple.isHidden = true
//        buttonLinkedIn.isHidden = true
        // btnFb.isHidden = true
        // buttonFBLogin.isHidden = true
        
        
        //        if #available(iOS 13.0, *) {
        //            btnApple.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        //        } else {
        //            // Fallback on earlier versions
        //        }
        btnApple.layer.cornerRadius = 10
        btnApple.layer.borderWidth = 1
        btnApple.layer.borderColor = UIColor.black.cgColor
        
        
        if #available(iOS 13, *) {
            //         startSignInWithAppleFlow()
            setUpSignInAppleButton()
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    //
    //    func createButton() {
    //        if #available(iOS 13.0, *) {
    //            let authorizationButton = ASAuthorizationAppleIDButton()
    ////            authorizationButton.addTarget(self, action:
    ////                       #selector(handleAuthorizationAppleIDButtonPress),
    ////                       for: .touchUpInside)
    ////                   myView.addSubview(authorizationButton)
    //        } else {
    //            // Fallback on earlier versions
    //        }
    //
    //    }
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController =
                ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
    }
    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        if #available(iOS 13.0, *) {
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
        // Create an authorization controller with the given requests.
    }
    
    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            //authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            authorizationButton.cornerRadius = 10
            
            //Add button on some view or stack
            // authorizationButton.frame.size = btnApple.frame.size
            //self.btnApple.addSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    //    private func randomNonceString(length: Int = 32) -> String {
    //        precondition(length > 0)
    //        let charset: Array<Character> =
    //            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    //        var result = ""
    //        var remainingLength = length
    //
    //        while remainingLength > 0 {
    //            let randoms: [UInt8] = (0 ..< 16).map { _ in
    //                var random: UInt8 = 0
    //                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
    //                if errorCode != errSecSuccess {
    //                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
    //                }
    //                return random
    //            }
    //
    //            randoms.forEach { random in
    //                if remainingLength == 0 {
    //                    return
    //                }
    //
    //                if random < charset.count {
    //                    result.append(charset[Int(random)])
    //                    remainingLength -= 1
    //                }
    //            }
    //        }
    //
    //        return result
    //    }
    
    // Unhashed nonce.
    //    fileprivate var currentNonce: String?
    //
    //    @available(iOS 13, *)
    //    func startSignInWithAppleFlow() {
    //      let nonce = randomNonceString()
    //      currentNonce = nonce
    //      let appleIDProvider = ASAuthorizationAppleIDProvider()
    //      let request = appleIDProvider.createRequest()
    //      request.requestedScopes = [.fullName, .email]
    //      request.nonce = sha256(nonce)
    //
    //      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    //      authorizationController.delegate = self
    //      authorizationController.presentationContextProvider = self
    //      authorizationController.performRequests()
    //    }
    //
    //    @available(iOS 13, *)
    //    private func sha256(_ input: String) -> String {
    //      let inputData = Data(input.utf8)
    //      let hashedData = SHA256.hash(data: inputData)
    //      let hashString = hashedData.compactMap {
    //        return String(format: "%02x", $0)
    //      }.joined()
    //
    //      return hashString
    //    }
    
    
    
    
    
    @available(iOS 13.0, *)
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.adForest_loginDetails()
    }
    
    func fbLogin(){
        
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Nothing")
            }
            else if (result?.isCancelled)! {
                print("Cancel")
            }
            else if error == nil {
                self.userProfileDetails()
            } else {
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        defaults.removeObject(forKey: "isGuest")
        defaults.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- text Field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            txtPassword.resignFirstResponder()
            self.adForest_logIn()
        }
        return true
    }
    
    //MARK: - Custom
    
    func txtFieldsWithRtl(){
        if UserDefaults.standard.bool(forKey: "isRtl") {
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
        } else {
            txtEmail.textAlignment = .left
            txtPassword.textAlignment = .left
        }
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adForest_populateData() {
        if UserHandler.sharedInstance.objLoginDetails != nil {
            let objData = UserHandler.sharedInstance.objLoginDetails
            
            if let isVerification = objData?.isVerifyOn {
                self.isVerifyOn = isVerification
            }
            
            if let bgColor = defaults.string(forKey: "mainColor") {
                self.containerViewImage.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
                self.buttonSubmit.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                self.buttonGuestLogin.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                self.buttonSubmit.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
                self.buttonGuestLogin.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
            }
            
            if let imgUrl = URL(string: (objData?.logo)!) {
                imgTitle.sd_setShowActivityIndicatorView(true)
                imgTitle.sd_setIndicatorStyle(.gray)
                imgTitle.sd_setImage(with: imgUrl, completed: nil)
            }
            
            if let welcomeText = objData?.heading {
                self.lblWelcome.text = welcomeText
            }
            if let appleText = objData?.appleBtn{
                self.btnApple.setTitle(appleText,for: .normal)
            }
            
            if let emailPlaceHolder = objData?.emailPlaceholder {
                self.txtEmail.placeholder = emailPlaceHolder
            }
            if let passwordPlaceHolder = objData?.passwordPlaceholder {
                self.txtPassword.placeholder = passwordPlaceHolder
            }
            if let forgotText = objData?.forgotText {
                self.buttonForgotPassword.setTitle(forgotText, for: .normal)
            }
            if let submitText = objData?.formBtn {
                self.buttonSubmit.setTitle(submitText, for: .normal)
            }
            
            if let registerText = objData?.registerText {
                self.buttonRegisterWithUs.setTitle(registerText, for: .normal)
            }
            
            // Show hide guest button
            guard let settings = defaults.object(forKey: "settings") else {
                return
            }
            let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settings as! Data) as! [String : Any]
            let objSettings = SettingsRoot(fromDictionary: settingObject)
            
            
            var isShowGuestButton = false
            if let isShowGuest = objSettings.data.isAppOpen {
                isShowGuestButton = isShowGuest
            }
            if isShowGuestButton {
                self.buttonGuestLogin.isHidden = false
                if let guestText = objData?.guestLogin {
                    self.buttonGuestLogin.setTitle(guestText, for: .normal)
                }
            }
            else {
                self.buttonGuestLogin.isHidden = true
            }
            
            // Show/hide google and facebook button
            var isShowGoogle = false
            var isShowFacebook = false
            var isShowApple = false
            var isShowLinkedin = false
            
            if let isGoogle = objSettings.data.registerBtnShow.google {
                isShowGoogle = isGoogle
            }
            if let isFacebook = objSettings.data.registerBtnShow.facebook{
                isShowFacebook = isFacebook
            }
            if let isApple = objSettings.data.registerBtnShow.apple{
                isShowApple = isApple
            }
            if let isLinkedin = objSettings.data.registerBtnShow.linkedin{
                isShowLinkedin = isLinkedin
            }
            
            if isShowFacebook || isShowGoogle || isShowApple || isShowLinkedin {
                if let sepratorText = objData?.separator {
                    self.lblOr.text = sepratorText
                }
            }
            
            if isShowFacebook && isShowGoogle && isShowApple  {
                self.buttonFBLogin.isHidden = false
                self.btnFb.isHidden = false
                self.buttonGoogleLogin.isHidden = false
                self.btnGoogleLog.isHidden = false //New
                self.btnApple.isHidden = false
//                self.buttonLinkedIn.isHidden = false
            }
            else if isShowFacebook && isShowGoogle == false && isShowApple  {
                self.buttonFBLogin.isHidden = false
                self.btnFb.isHidden = false
                self.buttonGoogleLogin.isHidden = true
                self.btnGoogleLog.isHidden = true //New
                self.btnApple.isHidden = false
                self.topConstraintBtnApple.constant -= 50
//                self.buttonLinkedIn.isHidden = false
            }
            else if isShowFacebook == false && isShowGoogle == false && isShowApple  {
                self.buttonFBLogin.isHidden = true
                self.btnFb.isHidden = true
                self.buttonGoogleLogin.isHidden = true
                self.btnGoogleLog.isHidden = true //New
                self.btnApple.isHidden = false
                self.topConstraintBtnApple.constant -= 120
//                self.buttonLinkedIn.isHidden = false
                
                
            }
            else if isShowFacebook == false && isShowGoogle && isShowApple && isShowLinkedin {
                self.buttonFBLogin.isHidden = true
                self.btnFb.isHidden = true
                self.buttonGoogleLogin.isHidden = false
                self.btnGoogleLog.isHidden = false
                self.btnApple.isHidden = false
                self.buttonLinkedIn.isHidden = false
//                self.topConstraintBtnGoogle.constant -= 10
//                self.topConstraintBtnGoogle2.constant -= 10
            }
            else if isShowFacebook && isShowGoogle  && isShowApple == false && isShowLinkedin {
                self.buttonFBLogin.isHidden = false
                self.btnFb.isHidden = false
                self.buttonGoogleLogin.isHidden = false
                self.btnGoogleLog.isHidden = false
                self.btnApple.isHidden = true
                self.buttonLinkedIn.isHidden = false
                self.topConstraintBtnLinkedIn.constant -= 60

                
                
            }
                else if isShowFacebook && isShowGoogle  && isShowApple  {
                    self.buttonFBLogin.isHidden = false
                    self.btnFb.isHidden = false
                    self.buttonGoogleLogin.isHidden = false
                    self.btnGoogleLog.isHidden = false
                    self.btnApple.isHidden = false
//                    self.buttonLinkedIn.isHidden = true
                }
                    
            else if isShowFacebook && isShowGoogle == false && isShowApple == false {
                self.buttonFBLogin.isHidden = false
                self.btnFb.isHidden = false
                self.buttonGoogleLogin.isHidden = true
                self.btnGoogleLog.isHidden = true
                self.btnApple.isHidden = true
//                self.buttonLinkedIn.isHidden = true
                self.topConstraintBtnLinkedIn.constant -= -10

                btnFb.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                buttonFBLogin.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
            }
                
            else if isShowGoogle && isShowFacebook == false && isShowApple == false  {
                self.buttonGoogleLogin.isHidden = false
                self.btnGoogleLog.isHidden = false // New
                self.buttonGoogleLogin.translatesAutoresizingMaskIntoConstraints = false
                self.btnGoogleLog.translatesAutoresizingMaskIntoConstraints = false // New
                socialLoginHeightConstraint.constant -= 50
                self.buttonFBLogin.isHidden = true
                self.btnFb.isHidden = true
                self.btnApple.isHidden = true
//                self.buttonLinkedIn.isHidden = true
                btnGoogleLog.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                buttonGoogleLogin.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
            }
            else if isShowFacebook == false && isShowGoogle == false && isShowApple == false && isShowLinkedin {
                self.buttonGoogleLogin.isHidden = true
                self.btnGoogleLog.isHidden = true // New
                self.buttonFBLogin.isHidden = true
                self.btnFb.isHidden = true
                self.btnApple.isHidden = true
                self.buttonLinkedIn.isHidden = false
//                self.topConstraintBtnLinkedIn.constant -= 140
                buttonLinkedIn.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
//                buttonGuestLogin.topAnchor.constraint(equalTo: self.buttonLinkedIn.bottomAnchor, constant: 8).isActive = true

            }
                
            else if isShowFacebook == false && isShowGoogle == false && isShowApple  && isShowLinkedin {
                self.buttonGoogleLogin.isHidden = true
                self.btnGoogleLog.isHidden = true // New
                self.buttonFBLogin.isHidden = true
                self.btnFb.isHidden = true
                self.btnApple.isHidden = false
                self.topConstraintBtnApple.constant -= 120
                self.buttonLinkedIn.isHidden = false
                self.topConstraintBtnLinkedIn.constant -= 90
            }
            else if isShowFacebook == false && isShowGoogle  && isShowApple  && isShowLinkedin {
                self.buttonGoogleLogin.isHidden = false
                self.btnGoogleLog.isHidden = false // New
//                self.topConstraintBtnGoogle.constant -= 140
//                self.topConstraintBtnGoogle2.constant -= 140
                self.buttonFBLogin.isHidden = true
                self.btnFb.isHidden = true
                self.btnApple.isHidden = false
//                self.topConstraintBtnApple.constant -= 90
                self.buttonLinkedIn.isHidden = false
//                self.topConstraintBtnLinkedIn.constant -= 60
                btnGoogleLog.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                buttonGoogleLogin.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                buttonLinkedIn.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true

            }
                               
            else if isShowFacebook  && isShowGoogle  && isShowApple  && isShowLinkedin {
                self.buttonGoogleLogin.isHidden = false
                self.btnGoogleLog.isHidden = false // New
                self.buttonFBLogin.isHidden = false
                self.btnFb.isHidden = false
                self.btnApple.isHidden = false
                self.buttonLinkedIn.isHidden = false

            }
//            else if isShowFacebook  && isShowGoogle  && isShowApple == false  && isShowLinkedin {
//                self.buttonGoogleLogin.isHidden = false
//                self.btnGoogleLog.isHidden = false // New
//                self.buttonFBLogin.isHidden = false
//                self.btnFb.isHidden = false
//                self.btnApple.isHidden = true
//                self.buttonLinkedIn.isHidden = false
//
//            }

                
           
            else if isShowFacebook == false && isShowGoogle == false && isShowApple == false  && isShowLinkedin == false {
                self.lblOr.isHidden = true
                
                self.containerViewSocialButton.isHidden = true
                if isShowGuestButton {
                    self.buttonGuestLogin.isHidden = false
                    self.buttonGuestLogin.translatesAutoresizingMaskIntoConstraints = false
                    buttonGuestLogin.topAnchor.constraint(equalTo: self.buttonSubmit.bottomAnchor, constant: 8).isActive = true
                    if let guestText = objData?.guestLogin {
                        self.buttonGuestLogin.setTitle(guestText, for: .normal)
                    }
                } else {
                    self.buttonGuestLogin.isHidden = true
                }
            }
            

        }
    }
    
    //MARK:- IBActions
  
    @IBAction func actionForgotPassword(_ sender: Any) {
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        self.adForest_logIn()
    }
    func loadAccount() { // then & or are handling closures
    if let token = accessToken {
        LISDKSessionManager.createSession(with: token)
        if LISDKSessionManager.hasValidSession() {
            LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,public-profile-url,date-of-birth,phone-numbers,location)?format=json",
                success: {
                    response in
                    print(response?.data)
//                    then?()
                },
                error: {
                    error in
                    print(error)
//                    or?("error")
                }
            )
        }
    }else {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true,
                successBlock: {
                    (state) in
                    self.accessToken = LISDKSessionManager.sharedInstance().session.accessToken
                    if LISDKSessionManager.hasValidSession() {
                        LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,public-profile-url,date-of-birth,phone-numbers,location)?format=json",
                            success: {
                                response in
                                print(response?.data)
//                                then?()
                            },
                            error: {
                                error in
                                print(error)
//                                or?("error")
                            }
                        )
                    }
                },
                errorBlock: {
                    (error) in
//                    switch error. {
//                    default:
//                        if let errorUserInfo = error.userInfo["error"] as? NSString {
//                            or?(errorUserInfo as String)
//                        } else {
//                            or?(UIError.Code.Unknown)
//                        }
//                    }
                }
            )
        }
    }
    @IBAction func actionLinkedinSubmit(_ sender: Any) {
       // self.loadAccount()
        
//
//        let newViewController = WebViewController()
//        self.navigationController?.pushViewController(newViewController, animated: true)
//        self.loadAccount()
//        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
//
//            print("success called!")
//            let session = LISDKSessionManager.sharedInstance().session
//            }) { (error) -> Void in
//                print("Error: \(error)")
//        }
      
        
        let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "86fohl6w88kexu", clientSecret: "YAOoXObs6wU3aUg9", state: "dwweewg43v", permissions: ["r_liteprofile", "r_emailaddress"], redirectUrl: "https://adforest-testapp.scriptsbundle.com/"),nativeAppChecker: WebLoginOnly())
        linkedinHelper.authorizeSuccess({ (token) in

                print(token)

                let url = "https://api.linkedin.com/v2/me"
                linkedinHelper.requestURL(url, requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                  let dict = response.jsonObject
                  print(dict!)
                  let weatherArray = dict!["profilePicture"] as? [String:Any]
                    print(weatherArray)
                    let imgProfile = weatherArray as? [String:Any]
                    let linkedinImg = imgProfile!["displayImage"]
                        print(linkedinImg)
                    

                   let emailurl = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"
                    linkedinHelper.requestURL(emailurl, requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                        print(response)
                        let dict = response.jsonObject
                        print(dict!)
//                        let user = User(json: response.jsonObject)
                        if let weatherArray = dict!["elements"] as? [[String:Any]],
                           let weather = weatherArray.first {
                            let handle = weather["handle~"]
                               print(handle)
                            let email = handle as? [String:Any]
                            let emilaagay = email!["emailAddress"]
                            print(emilaagay)
                            let param: [String: Any] = [
                                "email":emilaagay!,
                                "type":"social",
                                "profile_img":linkedinImg!
                            ]
                            print(param)
                            self.defaults.set(true, forKey: "isSocial")
                            self.defaults.set(emilaagay, forKey: "email")
                            self.defaults.set("1122", forKey: "password")
                            self.defaults.synchronize()
                            self.adForest_loginUser(parameters: param as NSDictionary)
                            // the value is an optional.
                        }
//                        let data = dict!["elements"]
//                        print(data)
                    
//                       let foo: String!
//                        var foo = ""
//                        if  foo = {
//
//                            // do something with foo
//                            print(foo)
//                        } else {
//                            // item could not be found
//                        }
                        
                    })
//                    let dict = response.jsonObject
//                    print(dict!)
//                    let email = dict!["emailAddress"]
//                    print(email!)
//                    let param: [String: Any] = [
//                        "email":email!,
//                        "type":"social"
//                    ]
//                    print(param)
//                    self.defaults.set(true, forKey: "isSocial")
//                    self.defaults.set(email, forKey: "email")
//                    self.defaults.set("1122", forKey: "password")
//                    self.defaults.synchronize()
//                    self.adForest_loginUser(parameters: param as NSDictionary)

                }) {(error) -> Void in
                    print(error.localizedDescription)
                    //handle the error
            }
//         linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
//
//            self.linkedinHelper.requestURL("https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id={86fohl6w88kexu}&redirect_uri=https://adforest-testapp.scriptsbundle.com/auth/linkedin/callback%2Fauth%2Flinkedin%2Fcallback&state=fooobar&scope=r_liteprofile%20r_emailaddress%20w_member_social", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
//
//
//                 print(response)
//                let dict = response.jsonObject
//                print(dict!)
//                let email = dict!["emailAddress"]
//                print(email!)
//                let param: [String: Any] = [
//                    "email":email!,
//                    "type":"social"
//                ]
//                print(param)
//                self.defaults.set(true, forKey: "isSocial")
//                self.defaults.set(email, forKey: "email")
//                self.defaults.set("1122", forKey: "password")
//                self.defaults.synchronize()
//                self.adForest_loginUser(parameters: param as NSDictionary)
//
//            }) { [unowned self] (error) -> Void in
//
//                //self.writeConsoleLine("Encounter error: \(error.localizedDescription)")
//            }
//        }, error: { (error) -> Void in
//            //Encounter error: error.localizedDescription
//        }, cancel: { () -> Void in
//            //User Cancelled!
//        })
        }, error: nil)
    }
    
    func adForest_logIn() {
        guard let email = txtEmail.text else {
            return
        }
        guard let password = txtPassword.text else {
            return
        }
        if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if password == "" {
            self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
            let param : [String : Any] = [
                "email" : email,
                "password": password
            ]
            print(param)
            self.defaults.set(email, forKey: "email")
            self.defaults.set(password, forKey: "password")
            self.adForest_loginUser(parameters: param as NSDictionary)
        }
    }
    
    
    
    //    @IBAction func actionFBLogin(_ sender: UIButton) {
    //
    //        fbLogin()
    //
    //    }
    //
    
    @IBAction func btnLoginfBoK(_ sender: UIButton) {
        fbLogin()
        
    }
    //    @IBAction func actionFBLogin(_ sender: FBSDKButton) {
    //        let loginManager = FBSDKLoginManager()
    //        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
    //            if error != nil {
    //                print(error?.localizedDescription ?? "Nothing")
    //            }
    //            else if (result?.isCancelled)! {
    //                print("Cancel")
    //            }
    //            else if error == nil {
    //                self.userProfileDetails()
    //            } else {
    //            }
    //        }
    //
    //    }
    
    
    //    @IBAction func actionFBLogin(_ sender: Any) {
    //        //let loginManager = FBSDKLoginManager()
    //        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
    //            if error != nil {
    //                print(error?.localizedDescription ?? "Nothing")
    //            }
    //            else if (result?.isCancelled)! {
    //                print("Cancel")
    //            }
    //            else if error == nil {
    //                self.userProfileDetails()
    //            } else {
    //            }
    //        }
    //    }
    
    
    @IBAction func btnAppleClicked(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            //            startSignInWithAppleFlow()
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    @IBAction func actionGoogleLogin(_ sender: Any) {
        if GoogleAuthenctication.isLooggedIn {
            GoogleAuthenctication.signOut()
        }
        else {
            GoogleAuthenctication.signIn()
        }
    }
    
    @IBAction func actionGuestLogin(_ sender: Any) {
        defaults.set(true, forKey: "isGuest")
        self.showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.appDelegate.moveToHome()
            self.stopAnimating()
        }
    }
    
    @IBAction func actionRegisterWithUs(_ sender: Any) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    //MARK:- Google Delegate Methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }
        if error == nil {
            guard let email = user.profile.email,
                let googleID = user.userID,
                let name = user.profile.name
                else { return }
            guard let token = user.authentication.idToken else {
                return
            }
            print("\(email), \(googleID), \(name), \(token)")
            let param: [String: Any] = [
                "email": email,
                "type": "social"
            ]
            print(param)
            self.defaults.set(true, forKey: "isSocial")
            self.defaults.set(email, forKey: "email")
            self.defaults.set("1122", forKey: "password")
            self.defaults.synchronize()
            self.adForest_loginUser(parameters: param as NSDictionary)
        }
    }
    // Google Sign In Delegate
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Facebook Delegate Methods
    
    func userProfileDetails() {
        if (AccessToken.current != nil) {
            GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Nothing")
                    return
                }
                else {
                    guard let results = result as? NSDictionary else { return }
                    guard let facebookId = results["email"] as? String,
                        let email = results["email"] as? String else {
                            return
                    }
                    print("\(email), \(facebookId)")
                    let param: [String: Any] = [
                        "email": email,
                        "type": "social"
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    self.defaults.set(email, forKey: "email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    
                    self.adForest_loginUser(parameters: param as NSDictionary)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton!) -> Bool {
        return true
    }
    
    //MARK:- API Calls
    
    //Login Data Get Request
    func adForest_loginDetails() {
        self.showLoader()
        UserHandler.loginDetails(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.objLoginDetails = successResponse.data
                self.adForest_populateData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // Login User
    func adForest_loginUser(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.loginUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                if self.isVerifyOn && successResponse.data.isAccountConfirm == false {
                    let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                        confirmationVC.isFromVerification = true
                        confirmationVC.user_id = successResponse.data.id
                        self.navigationController?.pushViewController(confirmationVC, animated: true)
                    })
                    self.presentVC(alert)
                } else {
                    self.defaults.set(true, forKey: "isLogin")
                    self.defaults.synchronize()
                    self.appDelegate.moveToHome()
                }
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}



@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding,ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            
            let email = appleIDCredential.email
            if email != nil{
                UserDefaults.standard.set(email, forKey:"emailA")
            }
            
            let emApple = UserDefaults.standard.string(forKey: "emailA")
            if emApple != nil{
                let param: [String: Any] = [
                    "email": emApple!,
                    "type": "social"
                ]
                print(param)
                self.defaults.set(true, forKey: "isSocial")
                UserDefaults.standard.set(emApple, forKey:"email")
                self.defaults.set("1122", forKey: "password")
                self.defaults.synchronize()
                UserDefaults.standard.set("true", forKey: "apple")
                self.adForest_loginUser(parameters: param as NSDictionary)
                print(userIdentifier,fullName,email)
            }else{
                let alert = Constants.showBasicAlert(message: "Apple id....")
                self.presentVC(alert)
                
                
            }
            //                         if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            //                guard let nonce = currentNonce else {
            //                  fatalError("Invalid state: A login callback was received, but no login request was sent.")
            //                }
            //                guard let appleIDToken = appleIDCredential.identityToken else {
            //                  print("Unable to fetch identity token")
            //                  return
            //                }
            //                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            //                  print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            //                  return
            //                }
            //
            //                // Initialize a Firebase credential.
            //                let credential = OAuthProvider.credential(withProviderID: "apple.com",
            //                                                          idToken: idTokenString,
            //                                                          accessToken: nonce)
            //                let emApple = UserDefaults.standard.string(forKey: "emailA")
            //
            //                let param: [String: Any] = [
            //                    "email": emApple!,
            //                    "type": "social"
            //                ]
            //                self.defaults.set(true, forKey: "isSocial")
            //                UserDefaults.standard.set(emApple, forKey:"email")
            //                self.defaults.set("1122", forKey: "password")
            //                self.defaults.synchronize()
            //                UserDefaults.standard.set("true", forKey: "apple")
            //                self.adForest_loginUser(parameters: param as NSDictionary)
            //                print(userIdentifier,fullName,email)
            //                // Sign in with Firebase.
            //                Auth.auth().signIn(with: credential) { (authResult, error) in
            //                    if (error != nil) {
            //                    // Error. If error.code == .MissingOrInvalidNonce, make sure
            //                    // you're sending the SHA256-hashed nonce as a hex string with
            //                    // your request to Apple.
            //                        print(error!.localizedDescription)
            //                    return
            //                  }
            //                  // User is signed in to Firebase with Apple.
            //                  // ...
            //                }
            //              }
            //            func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            //              // Handle error.
            //              print("Sign in with Apple errored: \(error)")
            //            }
            
        }
    }
    
    
}

class User {
typealias JSON = [String: Any]
var id: String?
var firstName: String?
var lastName: String?

init(json: JSON) {

guard let id = json["id"] as? String, let firstName = json["firstName"] as? String, let lastName = json["lastName"] as? String else { return }

self.id = id
self.firstName = firstName
self.lastName = lastName
    }
    
}
