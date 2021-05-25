//
//  LoginViewController.swift
//  Adforest
//
//  Created by apple on 1/2/18.
//  Copyright © 2018 apple. All rights reserved.
//

import AuthenticationServices
import CryptoKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import NVActivityIndicatorView
import SDWebImage
import UIKit
import UITextField_Shake

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, GIDSignInDelegate, UIScrollViewDelegate {
    // MARK: - Outlets

    @IBOutlet var topConstraintBtnGoogle2: NSLayoutConstraint!
    @IBOutlet var topConstraintBtnGoogle: NSLayoutConstraint!
    @IBOutlet var topConstraintBtnApple: NSLayoutConstraint!
    @IBOutlet var btnApple: UIButton!
    @IBOutlet var topConstraintBtnLinkedIn: NSLayoutConstraint!

    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.isScrollEnabled = true
        }
    }

    @IBOutlet var containerViewImage: UIView!
    @IBOutlet var imgTitle: UIImageView!
    @IBOutlet var lblWelcome: UILabel!
    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }

    @IBOutlet var btnViewPassword: UIButton! {
        didSet {
            btnViewPassword.tintColor = UIColor.gray
        }
    }

    @IBOutlet var imgPassword: UIImageView!
    @IBOutlet var txtPassword: UITextField! {
        didSet {
            txtPassword.delegate = self
        }
    }

    @IBOutlet var buttonForgotPassword: UIButton! {
        didSet {
            buttonForgotPassword.contentHorizontalAlignment = .right
        }
    }

    @IBOutlet var buttonLinkedIn: UIButton! {
        didSet {
            buttonLinkedIn.roundCornors()
            buttonLinkedIn.layer.borderWidth = 1
        }
    }

    @IBOutlet var buttonSubmit: UIButton! {
        didSet {
            buttonSubmit.roundCorners()
            buttonSubmit.layer.borderWidth = 1
        }
    }

    @IBOutlet var lblOr: UILabel!
    //    @IBOutlet weak var buttonFBLogin: UIButton! {
    //        didSet {
    //            buttonFBLogin.roundCorners()
    //            buttonFBLogin.isHidden = true
    //        }
    //    }

    @IBOutlet var btnFb: UIButton!
    @IBOutlet var buttonFBLogin: FBLoginButton!
    @IBOutlet var socialLoginHeightConstraint: NSLayoutConstraint!

    @IBOutlet var buttonGoogleLogin: UIButton! {
        didSet {
            buttonGoogleLogin.roundCorners()
            buttonGoogleLogin.isHidden = false
        }
    }

    @IBOutlet var buttonGuestLogin: UIButton! {
        didSet {
            buttonGuestLogin.roundCorners()
            buttonGuestLogin.layer.borderWidth = 1
            buttonGuestLogin.isHidden = true
        }
    }

    @IBOutlet var buttonRegisterWithUs: UIButton! {
        didSet {
            buttonRegisterWithUs.layer.borderWidth = 0.4
            buttonRegisterWithUs.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    @IBOutlet var viewRegisterWithUs: UIView!
    @IBOutlet var containerViewSocialButton: UIView!

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var emailSeperator: UIView!
    @IBOutlet weak var pwdSeperator: UIView!
    // MARK: - Properties

    var getLoginDetails = [LoginData]()
    var defaults = UserDefaults.standard
    var isVerifyOn = false
    let loginManager = LoginManager()

    var mainBtnColor = ""
    var isDelFb = UserDefaults.standard.bool(forKey: "delFb")
    var linkedInId = ""
    var linkedInFirstName = ""
    var linkedInLastName = ""
    var linkedInEmail = ""
    var linkedInProfilePicURL = ""
    var linkedInAccessToken = ""
    var iconClick = true
    var homeStyle: String = UserDefaults.standard.string(forKey: "homeStyles")!
    let storyboard2 = UIStoryboard(name: "Main2", bundle: nil)

    var codeSentToText: String = UserDefaults.standard.string(forKey: "codeSentTo")!
    var notReceived: String = UserDefaults.standard.string(forKey: "notReceived")!
    var tryAgain: String = UserDefaults.standard.string(forKey: "tryAgain")!
    var verifyNumberText: String = UserDefaults.standard.string(forKey: "verifyNumber")!
    var plHolderPhoneNumber: String = UserDefaults.standard.string(forKey: "phonePlaceholder")!
    var userNameplaceholder: String = UserDefaults.standard.string(forKey: "usernamePlaceHolder")!

    var emailPlaceHolder = ""
    var pwdPlaceHolder = ""

    // MARK: Application Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboard()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

        //        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        // self.adForest_loginDetails()
        txtFieldsWithRtl()
//        btnGoogleLog.isHidden = true
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
        if UserDefaults.standard.bool(forKey: "isRtl") {
            btnApple.imageEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 10)
        }

        if #available(iOS 13, *) {
            //         startSignInWithAppleFlow()
            setUpSignInAppleButton()
//            self.checkStatusOfAppleSignIn()

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
            // authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            authorizationButton.cornerRadius = 10

            // Add button on some view or stack
            // authorizationButton.frame.size = btnApple.frame.size
            // self.btnApple.addSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
    }

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
        adForest_loginDetails()
    }

    func fbLogin() {
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            if error != nil {
                print(error?.localizedDescription ?? "Nothing")
            } else if (result?.isCancelled)! {
                print("Cancel")
            } else if error == nil {
                self.userProfileDetails()
            } else {
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        defaults.removeObject(forKey: "isGuest")
        defaults.synchronize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - text Field Delegate Methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        } else if textField == txtPassword {
            txtPassword.resignFirstResponder()
            adForest_logIn()
        }
        return true
    }

//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if txtEmail.text?.isValidPhone == true {
////            txtPassword.placeholder = userNameplaceholder
////            txtPassword.isSecureTextEntry = false
//            imgEmail.image = #imageLiteral(resourceName: "Phone")
////            imgPassword.image = #imageLiteral(resourceName: "profile")
//            txtEmail.placeholder = plHolderPhoneNumber
////            btnViewPassword.isHidden = true
//            txtPassword.isHidden = true
//            imgPassword.isHidden = true
//            btnViewPassword.isHidden = true
//            pwdSeperator.isHidden = true
//            pwdView.isHidden = true
//            buttonForgotPassword.translatesAutoresizingMaskIntoConstraints = false
//            buttonForgotPassword.topAnchor.constraint(equalTo: self.emailView.bottomAnchor).isActive = true
//
//        } else {
//            txtPassword.placeholder = pwdPlaceHolder
//            txtPassword.isSecureTextEntry = true
//            imgEmail.image = #imageLiteral(resourceName: "msg")
//            imgPassword.image = #imageLiteral(resourceName: "Password")
//            txtEmail.placeholder = emailPlaceHolder
//            btnViewPassword.isHidden = false
//        }
//    }

    // MARK: - Custom

    func txtFieldsWithRtl() {
        if UserDefaults.standard.bool(forKey: "isRtl") {
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
        } else {
            txtEmail.textAlignment = .left
            txtPassword.textAlignment = .left
        }
    }

    func showLoader() {
        startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue, messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }

    func adForest_populateData() {
        if UserHandler.sharedInstance.objLoginDetails != nil {
            let objData = UserHandler.sharedInstance.objLoginDetails

            if let isVerification = objData?.isVerifyOn {
                isVerifyOn = isVerification
            }

            if let bgColor = defaults.string(forKey: "mainColor") {
                containerViewImage.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
                buttonSubmit.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                buttonGuestLogin.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                buttonSubmit.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
                buttonGuestLogin.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
            }

            if let imgUrl = URL(string: (objData?.logo)!) {
                imgTitle.sd_setShowActivityIndicatorView(true)
                imgTitle.sd_setIndicatorStyle(.gray)
                imgTitle.sd_setImage(with: imgUrl, completed: nil)
            }

            if let welcomeText = objData?.heading {
                lblWelcome.text = welcomeText
            }
            if let appleText = objData?.appleBtn {
                btnApple.setTitle(appleText, for: .normal)
            }

            if let emailPlaceHolder = objData?.emailPlaceholder {
                self.emailPlaceHolder = emailPlaceHolder
                txtEmail.placeholder = emailPlaceHolder
            }
            if let passwordPlaceHolder = objData?.passwordPlaceholder {
                pwdPlaceHolder = passwordPlaceHolder
                txtPassword.placeholder = passwordPlaceHolder
            }
            if let forgotText = objData?.forgotText {
                buttonForgotPassword.setTitle(forgotText, for: .normal)
            }
            if let submitText = objData?.formBtn {
                buttonSubmit.setTitle(submitText, for: .normal)
            }

            if let registerText = objData?.registerText {
                buttonRegisterWithUs.setTitle(registerText, for: .normal)
            }

            // Show hide guest button
            guard let settings = defaults.object(forKey: "settings") else {
                return
            }
            let settingObject = NSKeyedUnarchiver.unarchiveObject(with: settings as! Data) as! [String: Any]
            let objSettings = SettingsRoot(fromDictionary: settingObject)

            var isShowGuestButton = false
            if let isShowGuest = objSettings.data.isAppOpen {
                isShowGuestButton = isShowGuest
            }
            if isShowGuestButton {
                buttonGuestLogin.isHidden = false
                if let guestText = objData?.guestLogin {
                    buttonGuestLogin.setTitle(guestText, for: .normal)
                }
            } else {
                buttonGuestLogin.isHidden = true
            }

            // Show/hide google and facebook button
            var isShowGoogle = false
            var isShowFacebook = false
            var isShowApple = false
            var isShowLinkedin = false

            if let isGoogle = objSettings.data.registerBtnShow.google {
                isShowGoogle = isGoogle
            }
            if let isFacebook = objSettings.data.registerBtnShow.facebook {
                isShowFacebook = isFacebook
            }
            if let isApple = objSettings.data.registerBtnShow.apple {
                isShowApple = isApple
            }
            if let isLinkedin = objSettings.data.registerBtnShow.linkedin {
                isShowLinkedin = isLinkedin
            }

            if isShowFacebook || isShowGoogle || isShowApple || isShowLinkedin {
                if let sepratorText = objData?.separator {
                    lblOr.text = sepratorText
                }
            }

            if isShowFacebook && isShowGoogle && isShowApple && isShowLinkedin == false {
                btnFb.isHidden = false
                buttonGoogleLogin.isHidden = false
                btnApple.isHidden = false
                buttonLinkedIn.isHidden = true
            } else if isShowFacebook && isShowGoogle == false && isShowApple && isShowLinkedin == false {
                btnFb.isHidden = false
                buttonGoogleLogin.isHidden = true
                btnApple.isHidden = false
                buttonLinkedIn.isHidden = true
                btnFb.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: btnFb.bottomAnchor, constant: 8).isActive = true
                socialLoginHeightConstraint.constant -= 90
            } else if isShowFacebook && isShowGoogle && isShowApple == false && isShowLinkedin {
                btnFb.isHidden = false
                buttonGoogleLogin.isHidden = false
                btnApple.isHidden = true
                buttonLinkedIn.isHidden = false
                btnFb.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                buttonGoogleLogin.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                buttonLinkedIn.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                socialLoginHeightConstraint.constant -= 100
            } else if isShowFacebook == false && isShowGoogle == false && isShowApple && isShowLinkedin == false {
                btnFb.isHidden = true
                buttonGoogleLogin.isHidden = true
                btnApple.isHidden = false
                btnApple.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 18).isActive = true
                buttonLinkedIn.isHidden = true
            } else if isShowFacebook == false && isShowGoogle && isShowApple && isShowLinkedin == false {
                btnFb.isHidden = true
                buttonGoogleLogin.isHidden = false
                btnApple.isHidden = false
                buttonLinkedIn.isHidden = true
                buttonGoogleLogin.centerXAnchor.constraint(equalTo: containerViewSocialButton.centerXAnchor).isActive = true
                buttonGoogleLogin.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: buttonGoogleLogin.bottomAnchor, constant: 8).isActive = true
            } else if isShowFacebook == false && isShowGoogle && isShowApple && isShowLinkedin {
                btnFb.isHidden = true
                buttonGoogleLogin.isHidden = false
                btnApple.isHidden = false
                buttonLinkedIn.isHidden = false
            } else if isShowFacebook && isShowGoogle && isShowApple == false && isShowLinkedin == false {
                btnFb.isHidden = false
                buttonGoogleLogin.isHidden = false
                btnApple.isHidden = true
                buttonLinkedIn.isHidden = true
                btnFb.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                buttonGoogleLogin.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                socialLoginHeightConstraint.constant -= 120
            } else if isShowFacebook && isShowGoogle && isShowApple == false && isShowLinkedin {
                btnFb.isHidden = false
                buttonGoogleLogin.isHidden = false
                btnApple.isHidden = true
                buttonLinkedIn.isHidden = false
                topConstraintBtnLinkedIn.constant -= 60
            }
//            else if isShowFacebook && isShowGoogle  && isShowApple  {
//                self.btnFb.isHidden = false
//                self.buttonGoogleLogin.isHidden = false
//                self.btnApple.isHidden = false
//            }

            else if isShowFacebook && isShowGoogle == false && isShowApple == false && isShowLinkedin == false {
                btnFb.isHidden = false
                buttonGoogleLogin.isHidden = true
                btnApple.isHidden = true
                buttonLinkedIn.isHidden = true
                // Constraints
                btnFb.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                buttonLinkedIn.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
            } else if isShowGoogle && isShowFacebook == false && isShowApple == false && isShowLinkedin == false {
                buttonGoogleLogin.isHidden = false
                buttonGoogleLogin.translatesAutoresizingMaskIntoConstraints = false
                socialLoginHeightConstraint.constant -= 50

                btnFb.isHidden = true
                btnApple.isHidden = true
                buttonLinkedIn.isHidden = true

                // Constraints
                buttonLinkedIn.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                buttonGoogleLogin.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
            } else if isShowFacebook == false && isShowGoogle == false && isShowApple == false && isShowLinkedin {
                buttonGoogleLogin.isHidden = true
                btnFb.isHidden = true
                btnApple.isHidden = true
                buttonLinkedIn.isHidden = false
                buttonLinkedIn.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
            } else if isShowFacebook == false && isShowGoogle == false && isShowApple && isShowLinkedin {
                buttonGoogleLogin.isHidden = true
                btnFb.isHidden = true
                btnApple.isHidden = false
                buttonLinkedIn.isHidden = false
                buttonLinkedIn.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: buttonLinkedIn.bottomAnchor, constant: 8).isActive = true
            } else if isShowFacebook == false && isShowGoogle && isShowApple && isShowLinkedin {
                buttonGoogleLogin.isHidden = false
                btnFb.isHidden = true
                btnApple.isHidden = false
                buttonLinkedIn.isHidden = false
                buttonGoogleLogin.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                btnApple.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
                buttonLinkedIn.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 8).isActive = true
            } else if isShowFacebook && isShowGoogle && isShowApple && isShowLinkedin {
                buttonGoogleLogin.isHidden = false
                btnFb.isHidden = false
                btnApple.isHidden = false
                buttonLinkedIn.isHidden = false
            } else if isShowFacebook == false && isShowGoogle == false && isShowApple == false && isShowLinkedin == false {
                lblOr.isHidden = true

                containerViewSocialButton.isHidden = true
                if isShowGuestButton {
                    buttonGuestLogin.isHidden = false
                    buttonGuestLogin.translatesAutoresizingMaskIntoConstraints = false
                    buttonGuestLogin.topAnchor.constraint(equalTo: buttonSubmit.bottomAnchor, constant: 8).isActive = true
                    if let guestText = objData?.guestLogin {
                        buttonGuestLogin.setTitle(guestText, for: .normal)
                    }
                } else {
                    buttonGuestLogin.isHidden = true
                }
            }
        }
    }

    // MARK: - IBActions

    @IBAction func actionShowPassword(_ sender: Any) {
        if iconClick == true {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                let image = UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate)
                btnViewPassword.setImage(image, for: .normal)
                mainBtnColor = mainColor
                print(mainBtnColor)
            }

            txtPassword.isSecureTextEntry = false
            btnViewPassword.tintColor = UIColor(hex: mainBtnColor)

        } else {
            btnViewPassword.tintColor = UIColor.gray
            txtPassword.isSecureTextEntry = true
        }

        iconClick = !iconClick
    }

    @IBAction func actionForgotPassword(_ sender: Any) {
        let forgotPassVC = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        navigationController?.pushViewController(forgotPassVC, animated: true)
    }

    @IBAction func actionSubmit(_ sender: Any) {
        adForest_logIn()
    }

    @IBAction func actionLinkedinSubmit(_ sender: Any) {
        linkedInAuthVC()
    }

    var webView = WKWebView()
    func linkedInAuthVC() {
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor),
        ])

        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"

        let authURLFull = Constants.LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + Constants.LinkedInConstants.CLIENT_ID + "&scope=" + Constants.LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + Constants.LinkedInConstants.REDIRECT_URI

        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
        webView.load(urlRequest)

        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        //        navController.navigationBar.barTintColor = UIColor.colorFromHex("#0072B1")
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical

        present(navController, animated: true, completion: nil)
    }

    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc func refreshAction() {
        webView.reload()
    }

    @objc func actionHandleAppleSignin() {
        DispatchQueue.main.async {
            //               self.vwUserDetail.isHidden = true
            //
            //               self.lblID.text = ""
            //               self.lblFirstname.text = ""
            //               self.lblLastname.text = ""
            //               self.lblEmail.text = ""
        }

        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
    }

    func adForest_logIn() {
//        if txtEmail.text?.isValidPhone == true {
//            let param: [String: Any] = [
////                "name": txtPassword.text!,
//                "phone": txtEmail.text!,
//            ]
//            print(param)
//            adForest_CheckloginUser(parameters: param as NSDictionary)
//        } else {
            guard let email = txtEmail.text else {
                return
            }
            guard let password = txtPassword.text else {
                return
            }
            if email == "" {
                txtEmail.shake(6, withDelta: 10, speed: 0.06)
            } else if !email.isValidEmail {
                txtEmail.shake(6, withDelta: 10, speed: 0.06)
            } else if password == "" {
                txtPassword.shake(6, withDelta: 10, speed: 0.06)
            } else {
                let param: [String: Any] = [
                    "email": email,
                    "password": password,
                ]
                print(param)
                defaults.set(email, forKey: "email")
                defaults.set(password, forKey: "password")
                adForest_loginUser(parameters: param as NSDictionary)
            }
        }
//    }

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
        actionHandleAppleSignin()
        //        if #available(iOS 13.0, *) {
        //            //            startSignInWithAppleFlow()
        //
        //            let appleIDProvider = ASAuthorizationAppleIDProvider()
        //            let request = appleIDProvider.createRequest()
        //            request.requestedScopes = [.fullName, .email]
        //            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        //            authorizationController.delegate = self
        //            authorizationController.performRequests()
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }

    @IBAction func actionGoogleLogin(_ sender: Any) {
        if GoogleAuthenctication.isLooggedIn {
            GoogleAuthenctication.signOut()
        } else {
            GoogleAuthenctication.signIn()
        }
    }

    @IBAction func actionGuestLogin(_ sender: Any) {
        defaults.set(true, forKey: "isGuest")
        showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            if self.homeStyle == "home1" {
                self.appDelegate.moveToHome()

            } else if self.homeStyle == "home2" {
                self.appDelegate.moveToMultiHome()
            } else if self.homeStyle == "home3" {
                self.appDelegate.moveToMarvelHome()
            }
            self.stopAnimating()
        }
    }

    @IBAction func actionRegisterWithUs(_ sender: Any) {
        let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(registerVC, animated: true)
    }

    // MARK: - Google Delegate Methods

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
                "type": "social",
            ]
            print(param)
            defaults.set(true, forKey: "isSocial")
            defaults.set(email, forKey: "email")
            defaults.set("1122", forKey: "password")
            defaults.synchronize()
            adForest_loginUser(parameters: param as NSDictionary)
        }
    }

    // Google Sign In Delegate
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Facebook Delegate Methods

    func userProfileDetails() {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { _, result, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Nothing")
                    return
                } else {
                    guard let results = result as? NSDictionary else { return }
                    guard let facebookId = results["email"] as? String,
                          let email = results["email"] as? String else {
                        return
                    }
                    print("\(email), \(facebookId)")
                    let param: [String: Any] = [
                        "email": email,
                        "type": "social",
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

    // MARK: - API Calls

    // Login Data Get Request
    func adForest_loginDetails() {
        showLoader()
        UserHandler.loginDetails(success: { successResponse in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.objLoginDetails = successResponse.data
                self.adForest_populateData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { error in
            self.stopAnimating()
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

                verifyVC.codeSentTo = self.codeSentToText
                verifyVC.codeNotReceived = self.notReceived
                verifyVC.resendCode = self.tryAgain
                verifyVC.verifyNumber = self.verifyNumberText
                verifyVC.isFrom = "Login"
                verifyVC.userName = successResponse.data.userName
                    //"qwerty123456"
                    
                verifyVC.phoneNumber = self.txtEmail.text!
                verifyVC.isVerifyOn = self.isVerifyOn
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

    // MARK:- Login User
    func adForest_loginUser(parameters: NSDictionary) {
        showLoader()
        UserHandler.loginUser(parameter: parameters, success: { successResponse in
            self.stopAnimating()
            if successResponse.success {
                if self.isVerifyOn && successResponse.data.isAccountConfirm == false {
                    let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                        confirmationVC.isFromVerification = true
                        if successResponse.data != nil {
                            confirmationVC.user_id = successResponse.data.id
                        }
                        self.navigationController?.pushViewController(confirmationVC, animated: true)
                    })
                    self.presentVC(alert)
                } else {
                    self.defaults.set(true, forKey: "isLogin")
                    self.defaults.synchronize()

                    if self.homeStyle == "home1" {
                        self.appDelegate.moveToHome()

                    } else if self.homeStyle == "home2" {
                        self.appDelegate.moveToMultiHome()
                    } else if self.homeStyle == "home3" {
                        self.appDelegate.moveToMarvelHome()
                    }
                }
            } else {
//                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
//                    let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//                    confirmationVC.isFromVerification = true
//                    if successResponse.data != nil {
//                        confirmationVC.user_id = successResponse.data.id
//                    }
//                    self.navigationController?.pushViewController(confirmationVC, animated: true)
//                })
//                self.presentVC(alert)
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { error in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            DispatchQueue.main.async {
                if "\(credentials.user)" != "" {
                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if credentials.email != nil {
                    UserDefaults.standard.set("\(credentials.email!)", forKey: "User_Email")
                }
                if credentials.fullName!.givenName != nil {
                    UserDefaults.standard.set("\(credentials.fullName!.givenName!)", forKey: "User_FirstName")
                }
                if credentials.fullName!.familyName != nil {
                    UserDefaults.standard.set("\(credentials.fullName!.familyName!)", forKey: "User_LastName")
                }
                UserDefaults.standard.synchronize()
                self.setupUserInfoAndOpenView()
            }

        case let credentials as ASPasswordCredential:
            DispatchQueue.main.async {
                if "\(credentials.user)" != "" {
                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if "\(credentials.password)" != "" {
                    UserDefaults.standard.set("\(credentials.password)", forKey: "User_Password")
                }
                UserDefaults.standard.synchronize()
                self.setupUserInfoAndOpenView()
            }
        case let credentials as ASAuthorizationAppleIDProvider:
            DispatchQueue.main.async {
                credentials.getCredentialState(forUserID: "\(UserDefaults.standard.value(forKey: "User_AppleID")!)") { credentialState, _ in

                    switch credentialState {
                    case .authorized:
                        self.setupUserInfoAndOpenView()
                        break
                    default:
                        break
                    }
                }
            }

        default:
            let alert: UIAlertController = UIAlertController(title: "Apple Sign In", message: "Something went wrong with your Apple Sign In!", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            present(alert, animated: true, completion: nil)
            break
        }
    }

    func setupUserInfoAndOpenView() {
        DispatchQueue.main.async {
            if "\(UserDefaults.standard.value(forKey: "User_FirstName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_LastName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_Email")!)" != "" {
                let emApple = UserDefaults.standard.value(forKey: "User_Email")!
                if emApple != nil {
                    let param: [String: Any] = [
                        "email": emApple,
                        "type": "social",
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    UserDefaults.standard.set(emApple, forKey: "email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    UserDefaults.standard.set("true", forKey: "apple")
                    self.adForest_loginUser(parameters: param as NSDictionary)
                }

            } else {
                let emApple = UserDefaults.standard.value(forKey: "User_AppleID")!
                if emApple != nil {
                    let param: [String: Any] = [
                        "email": emApple,
                        "type": "social",
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    UserDefaults.standard.set(emApple, forKey: "email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    UserDefaults.standard.set("true", forKey: "apple")
                    self.adForest_loginUser(parameters: param as NSDictionary)
                }
            }
        }
    }

    func checkStatusOfAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "\(UserDefaults.standard.value(forKey: "User_AppleID")!)") { credentialState, _ in

            switch credentialState {
            case .authorized:
                self.setupUserInfoAndOpenView()
                break
            default:
                break
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        let alert: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
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

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)

        // Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }

    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(Constants.LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }

    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }

    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"

        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + Constants.LinkedInConstants.REDIRECT_URI + "&client_id=" + Constants.LinkedInConstants.CLIENT_ID + "&client_secret=" + Constants.LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: Constants.LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]

                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")

                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")

                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }

    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)

                // AccessToken
                print("LinkedIn Access Token: \(accessToken)")
                self.linkedInAccessToken = accessToken

                // LinkedIn Id
                let linkedinId: String! = linkedInProfileModel?.id
                print("LinkedIn Id: \(linkedinId ?? "")")
                self.linkedInId = linkedinId

                // LinkedIn First Name
                let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
                print("LinkedIn First Name: \(linkedinFirstName ?? "")")
                self.linkedInFirstName = linkedinFirstName

                // LinkedIn Last Name
                let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
                print("LinkedIn Last Name: \(linkedinLastName ?? "")")
                self.linkedInLastName = linkedinLastName

                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!

                /*
                 Change row of the 'elements' array to get diffrent size of the profile url
                 elements[0] = 100x100
                 elements[1] = 200x200
                 elements[2] = 400x400
                 elements[3] = 800x800
                 */
                if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                self.linkedInProfilePicURL = linkedinProfilePic

                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken)
            }
        }
        task.resume()
    }

    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)

                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                print("LinkedIn Email: \(linkedinEmail ?? "")")
                self.linkedInEmail = linkedinEmail

                DispatchQueue.main.async {
                    let param: [String: Any] = [
                        "email": linkedinEmail!,
                        "LinkedIn_img": self.linkedInProfilePicURL,
                        "type": "social",
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    UserDefaults.standard.set(linkedinEmail, forKey: "email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    self.adForest_loginUser(parameters: param as NSDictionary)
                    //                    self.performSegue(withIdentifier: "detailseg", sender: self)
                }
            }
        }
        task.resume()
    }
}
