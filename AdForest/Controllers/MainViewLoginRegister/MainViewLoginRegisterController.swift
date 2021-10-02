//
//  MainViewLoginRegisterController.swift
//  AdForest
//
//  Created by Apple on 02/09/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import NVActivityIndicatorView
import GoogleSignIn
import AuthenticationServices

class MainViewLoginRegisterController: UIViewController,NVActivityIndicatorViewable,UITableViewDataSource,UITableViewDelegate,GIDSignInDelegate {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblSubheading: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    
    //MARK:-Properties
    var calledFrom = ""
    let loginManager = LoginManager()
    var defaults = UserDefaults.standard
    var homeStyle: String = UserDefaults.standard.string(forKey: "homeStyles")!
    var isVerifyOn = false
    var linkedInId = ""
    var linkedInFirstName = ""
    var linkedInLastName = ""
    var linkedInEmail = ""
    var linkedInProfilePicURL = ""
    var linkedInAccessToken = ""
    var facebookLabel = ""
    var googleLabel = ""
    var linkedINLabel = ""
    var appleLabel = ""
    var guest = ""
    var emailLbl = ""
    var phonelbl = ""
    var isAppOpen = UserDefaults.standard.bool(forKey: "isAppOpen")
    var phTxt = ""
    var OTPTxt = ""
    var welcomeTxt = ""
    var introTxt  = ""
    var submit = ""
    var codeSentTo = ""
    var notReceived = ""
    var tryAgain = ""
    var verifyNumber = ""
    var phonePlaceholder = ""
    var enterPhoneerror = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        initViewData()
        self.addLeftBarButtonWithImage()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        //        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        adForest_loginDetails()

        if #available(iOS 13, *) {
            setUpSignInAppleButton()
            
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //initViewData()

        
    }
    func initViewData(){
        if calledFrom == "Login" {
            self.title = "Login"
        }
        else if calledFrom == "register"{
            self.title = "Register With us"
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
    //MARK:-Custom Loader
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    //MARK:-Social Logins
    //MARK:Facebook Login
    func btnLoginFbOk() {
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
    func userProfileDetails() {
        if (AccessToken.current != nil) {
            GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Nothing")
                    return
                }
                else {
                    guard let results = result as? NSDictionary else { return }
                    guard  let email = results["email"] as? String else {
                        return
                    }
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
    
    //MARK:- Google Login
    
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
    
    
    //MARK:- Apple Login
    
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
    @objc func actionHandleAppleSignin() {
        DispatchQueue.main.async {
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
    //MARK:- LinkedIn Login
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
    //MARK:- // Login Data Get Request
    func adForest_loginDetails() {
        showLoader()
        UserHandler.loginDetails(success: { successResponse in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.objLoginDetails = successResponse.data
                if self.calledFrom == "Login" {
                    self.title = successResponse.data.pageTitle
                }
                else if self.calledFrom == "register"{
                    self.title = successResponse.data.registerTitle
                }
                
                self.facebookLabel =  successResponse.data.facebookBtn
                self.googleLabel = successResponse.data.googleBtn
                self.linkedINLabel =  successResponse.data.linkedInBtn
                self.appleLabel = successResponse.data.appleBtn
                self.guest = successResponse.data.guestLogin
                self.emailLbl = successResponse.data.emailBtn
                self.phonelbl = successResponse.data.phoneBtn
                self.phTxt = successResponse.data.PhoneVerificationtxt
                self.submit = successResponse.data.formBtn
                self.OTPTxt =  successResponse.data.OtpText
                self.welcomeTxt = successResponse.data.welcomeTxt
                self.introTxt = successResponse.data.intoTxt
                self.codeSentTo = successResponse.data.codeSentTo
                self.notReceived = successResponse.data.notReceived
                self.tryAgain = successResponse.data.tryAgain
                self.verifyNumber = successResponse.data.verifyNumber
                self.phonePlaceholder = successResponse.data.phonePlaceholder
                self.enterPhoneerror  = successResponse.data.enterPhoneError
                self.tableView.reloadData()
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
    
    //MARK:- Login User With Social
    func adForest_loginUser(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.loginUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success{
                if self.isVerifyOn && successResponse.data.isAccountConfirm == false {
                    let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                        confirmationVC.isFromVerification = true
                        confirmationVC.user_id = successResponse.data.id
                        self.navigationController?.pushViewController(confirmationVC, animated: true)
                    })
                    self.presentVC(alert)
                }
                else {
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
    
    
    //MARK:- Table View Delegate Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell: LoginRegisterTopHeaderCell = tableView.dequeueReusableCell(withIdentifier: "LoginRegisterTopHeaderCell", for: indexPath) as! LoginRegisterTopHeaderCell
            cell.lblHeading.text = welcomeTxt
            cell.lblSubHeading.text = introTxt
            
            return cell
        case 1:
            let cell: SocialLoginRegisterCell = tableView.dequeueReusableCell(withIdentifier: "SocialLoginRegisterCell", for: indexPath) as! SocialLoginRegisterCell
            cell.calledFrom = calledFrom
            if calledFrom == "register"{
                cell.viewLoginAsGuest.isHidden = true
            }
            if isAppOpen ==  false {
                cell.viewLoginAsGuest.isHidden = true
            }
            cell.lblLoginByPhone.text = phonelbl
            cell.lblLoginByApple.text = appleLabel
            cell.lblLoginByGoogle.text = googleLabel
            cell.lblLoginByLinkedIn.text = linkedINLabel
            cell.lblLoginByEmail.text =  emailLbl
            cell.lblLoginByFaceBook.text = facebookLabel
            cell.lblLoginAsGuest.text = guest
           
            cell.btnActionLoginByEmail = { () in
                if self.calledFrom == "register"{
                    let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
                    self.navigationController?.pushViewController(registerVC, animated: true)
                }
                else{
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
            cell.btnActionLoginByFacebook = { () in
                self.btnLoginFbOk()
                
            }
            cell.btnActionLoginByGoogle = { () in
                if GoogleAuthenctication.isLooggedIn {
                    GoogleAuthenctication.signOut()
                } else {
                    GoogleAuthenctication.signIn()
                }
            }
            cell.btnActionLoginByApple = {() in
                self.actionHandleAppleSignin()
            }
            cell.btnActionLoginByLInkedIn = {() in
                self.linkedInAuthVC()
            }
            cell.btnActionLoginByGuest = {() in
                self.defaults.set(true, forKey: "isGuest")
                self.showLoader()
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
            cell.btnActionLoginByPhone = {() in
                let otpVC = self.storyboard?.instantiateViewController(withIdentifier: "OTPControllerViewController") as! OTPControllerViewController
                otpVC.calledFrom = self.calledFrom
                otpVC.phVerifcation = self.phTxt
                otpVC.otpTxt = self.OTPTxt
                otpVC.submit = self.submit
                otpVC.placeholderField = self.phonePlaceholder
                otpVC.codeSentTo = self.codeSentTo
                otpVC.notReceived = self.notReceived
                otpVC.tryAgain = self.tryAgain
                otpVC.verifyNumber = self.verifyNumber
                otpVC.phonePlaceholder = self.phonePlaceholder
                otpVC.enterPhoneerror = self.enterPhoneerror
                self.navigationController?.pushViewController(otpVC, animated: true)
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section  = indexPath.section
        var height: CGFloat = 0
        
        if section == 0{
            height =  156
            
        }else if section == 1{
            height =  455
            
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
}
@available(iOS 13.0, *)
extension MainViewLoginRegisterController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
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
        case let credentials as ASAuthorizationError:
            DispatchQueue.main.async {
                
                debugPrint("errrorrr",credentials._nsError)
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
                let alert = Constants.showBasicAlert(message: "error")
                self.presentVC(alert)
                //                let emApple = UserDefaults.standard.value(forKey: "User_AppleID")!
                //                if emApple != nil {
                //                    let param: [String: Any] = [
                //                        "email": emApple,
                //                        "type": "social",
                //                    ]
                //                    print(param)
                //                    self.defaults.set(true, forKey: "isSocial")
                //                    UserDefaults.standard.set(emApple, forKey: "email")
                //                    self.defaults.set("1122", forKey: "password")
                //                    self.defaults.synchronize()
                //                    UserDefaults.standard.set("true", forKey: "apple")
                //                    self.adForest_loginUser(parameters: param as NSDictionary)
                //                }
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
extension MainViewLoginRegisterController: WKNavigationDelegate {
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
                }
            }
        }
        task.resume()
    }
}
