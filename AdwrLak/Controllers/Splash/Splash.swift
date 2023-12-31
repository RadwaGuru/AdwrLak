//
//  Splash.swift
//  Adforest
//
//  Created by apple on 3/7/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import OSLog
class Splash: UIViewController, NVActivityIndicatorViewable {
    
    
    //MARK:- Properties
    
    var defaults = UserDefaults.standard
    var isAppOpen = false
    var settingBlogArr = [String]()
    var isBlogImg:Bool = false
    var isSettingImg:Bool = false
    var imagesArr = [UIImage]()
//    var imagesArr: [UIImage] = []

    var isWplOn = false
    var isToplocationOn = false
    var isBlogOn = false
    var isSettingsOn = false
    var uploadingImage = ""
    var InValidUrl = ""
    var navigationBarAppearace = UINavigationBar.appearance()
    var footerHome = ""
    var footerAdSearch = ""
    var footerAdPost = ""
    var footerProfile = ""
    var footerSettings = ""
    var featuredScrollEnabled: Bool!
    var featuredScrolldata : SettingsFeaturedScroll!
    var featuredTime : String!
    var featuredLoop = ""
    var home = "homeMulti"
    var topLocArr : [HomeAppTopLocation]!
    var settingExtrasData: SettingsExtra!
    var ad_id = ""
    var sender_id = ""
    var receiver_id = ""
    var messageType = ""
    var isBlocked :String?
    var blockMessage = ""
    var btn_text = ""
    var notiTopic = ""
    var NTitle = ""
    var NMessage = ""
    var NImage = ""
    //MARK:- Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fatalError()
        if UserDefaults.standard.bool(forKey: "isGuest") {
            print("val")
        }else{
            self.defaults.set(true, forKey: "isGuest")
        }
        self.settingsdata()
//        AppUpdater.shared.showUpdate(withConfirmation: true)
}
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adForest_checkLogin() {
        if defaults.bool(forKey: "isLogin") {
            guard let email = defaults.string(forKey: "email") else {
                return
            }
            guard let password = defaults.string(forKey: "password") else {
                return
            }
            if defaults.bool(forKey: "isSocial") {
                let param: [String: Any] = [
                    "email": email,
                    "type": "social"
                ]
                print(param)
                self.adForest_loginUser(parameters: param as NSDictionary)
            }
            else if defaults.bool(forKey: "otp"){
                let phoneNumber = defaults.string(forKey: "phoneNumber")
                let param: [String: Any] = [
                    "phone": phoneNumber,
                    "name": email

                ]
                print(param)
            
                self.adForest_loginOTPUser(parameters: param as NSDictionary)

            }
//            else if notiTopic == "broadcast"{
//                print("broadcast: \(NTitle) \(NMessage) \(NImage)")
////                var NTitle = ""
////                var NMessage = ""
////                var NImage = ""
//            }
            else if notiTopic == "chat"{
                let chatVC = self.storyboard?.instantiateViewController(withIdentifier: ChatController.className) as! ChatController
                chatVC.ad_id = ad_id
                chatVC.sender_id = sender_id
                chatVC.receiver_id = receiver_id
                chatVC.messageType = messageType
                chatVC.calledFrom = "splash"
                UserDefaults.standard.set("1", forKey: "fromNotification")
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
            else {
                let param : [String : Any] = [
                    "email" : email,
                    "password": password
                ]
                print(param)
                self.adForest_loginUser(parameters: param as NSDictionary)
            }
        }
        else  {
            if isAppOpen {
                if self.home == "home1"{
                    self.appDelegate.moveToHome()

                }else if self.home == "home2"{
                    self.appDelegate.moveToMultiHome()
                }
                else if self.home == "home3"{
                    self.appDelegate.moveToMarvelHome()
                }
            } else {
                //                let newViewController = AppIntroViewController()
                //                self.navigationController?.pushViewController(newViewController, animated: true)
//                self.appDelegate.moveToLogin()
                self.appDelegate.moveToMainViewLoginRegisterController()
            }
        }
    }
    
    //MARK:- API Call
    func settingsdata() {
        self.showLoader()
        UserHandler.settingsdata(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                UserDefaults.standard.set(successResponse.data.alertDialog.title, forKey: "aler")
                UserDefaults.standard.set(successResponse.data.internetDialog.okBtn, forKey: "okbtnNew")
                UserDefaults.standard.set(successResponse.data.internetDialog.cancelBtn, forKey: "cancelBtn")
                UserDefaults.standard.set(successResponse.data.alertDialog.select, forKey: "select")
                UserDefaults.standard.set(successResponse.data.alertDialog.camera, forKey: "camera")
                UserDefaults.standard.set(successResponse.data.alertDialog.CameraNotAvailable, forKey: "cameraNotAvavilable")
                UserDefaults.standard.set(successResponse.data.alertDialog.gallery, forKey: "gallery")
                
                UserDefaults.standard.set(successResponse.data.internetDialog.cancelBtn, forKey: "cancelbtnNew")
                //self.defaults.set(successResponse.data.mainColor, forKey: "mainColor")
                self.defaults.set(successResponse.data.mainColor, forKey: "#00355f")
                self.appDelegate.customizeNavigationBar(barTintColor: Constants.hexStringToUIColor(hex: successResponse.data.mainColor))
                //                self.navigationBarAppearace.tintColor = UIColor.white
//                                self.navigationBarAppearace.barTintColor = Constants.hexStringToUIColor(hex: successResponse.data.mainColor)
//                if #available(iOS 13.0, *) {
//                    let app = UINavigationBarAppearance()
//                    app.backgroundColor = Constants.hexStringToUIColor(hex: successResponse.data.mainColor)
//                    self.navigationController?.navigationBar.scrollEdgeAppearance = app
//                } else {
//                    // Fallback on earlier versions
//                }
         
                self.navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                self.defaults.set(successResponse.data.isRtl, forKey: "isRtl")
                UserDefaults.standard.set(successResponse.data.locationType, forKey: "locType")
                
                UserDefaults.standard.set(successResponse.data.gmapLang, forKey: "langCod")
                self.defaults.set(successResponse.data.notLoginMsg, forKey: "notLogin")
                self.defaults.set(successResponse.data.ImgReqMessage, forKey:"ImgReqMessage")
                self.defaults.set(successResponse.data.homescreenLayout, forKey:"homescreenLayout")
                self.defaults.set(successResponse.data.featuredAdsLayout,forKey: "featuredAdsLayout")
                self.defaults.set(successResponse.data.latestAdsLayout,forKey: "latestAdsLayout")
                self.defaults.set(successResponse.data.nearByAdsLayout,forKey: "nearByAdsLayout")
                self.defaults.set(successResponse.data.sliderAdsLayout,forKey: "sliderAdsLayout")
                self.defaults.set(successResponse.data.catSectionTitle,forKey: "catSectionTitle")
                self.defaults.set(successResponse.data.locationSectionStyle,forKey: "locationSectionStyle")
                self.defaults.set(successResponse.data.placesSearchType, forKey: "placesSearchType")
                self.defaults.set(successResponse.data.adDetailStyle,forKey: "adDetailStyle")
                self.home = successResponse.data.homeStyles
                self.defaults.set(successResponse.data.homeStyles,forKey: "homeStyles")
                self.topLocArr = successResponse.data.appTopLocation
                self.defaults.set(successResponse.data.isAppOpen, forKey: "isAppOpen")
                self.defaults.set(successResponse.data.showNearby, forKey: "showNearBy")
                self.defaults.set(successResponse.data.showHome, forKey: "showHome")
                self.defaults.set(true, forKey: "showSearch")
                self.defaults.set(successResponse.data.advanceIcon, forKey: "advanceSearch")
                self.defaults.set(successResponse.data.buyText, forKey: "buy")
                self.defaults.set(successResponse.data.appPageTestUrl, forKey: "shopUrl")
                //Save Shop title to show in Shop Navigation Title
                self.defaults.set(successResponse.data.menu.shop, forKey: "shopTitle")
                self.isAppOpen = successResponse.data.isAppOpen
                self.isWplOn = successResponse.data.is_wpml_active
                self.isToplocationOn = successResponse.data.menu.isShowMenu.toplocation
                self.isBlogOn = successResponse.data.menu.isShowMenu.blog
                self.isSettingsOn = successResponse.data.menu.isShowMenu.settings
                UserDefaults.standard.set(self.isBlogOn, forKey: "isBlogOn")
                UserDefaults.standard.set(self.isSettingsOn, forKey: "isSettingsOn")
                
                UserDefaults.standard.set(self.isToplocationOn, forKey: "isToplocOn")
                UserDefaults.standard.set(self.isWplOn, forKey: "isWpOn")
                UserDefaults.standard.set(successResponse.data.wpml_menu_text, forKey: "meuText")
                self.uploadingImage = successResponse.data.ImgUplaoding
                UserDefaults.standard.set(self.uploadingImage, forKey: "Uploading")
                self.InValidUrl = successResponse.data.InValidUrl
                UserDefaults.standard.set(self.InValidUrl, forKey: "InValidUrl")
                self.footerHome = successResponse.data.footerMenu.home
                self.footerAdSearch = successResponse.data.footerMenu.advSearch
                self.footerAdPost = successResponse.data.footerMenu.adPost
                self.footerProfile = successResponse.data.footerMenu.profile
                self.footerSettings = successResponse.data.footerMenu.settings
                UserDefaults.standard.set(self.footerHome, forKey: "footerHome")
                UserDefaults.standard.set(self.footerAdSearch, forKey: "footerAdSearch")
                UserDefaults.standard.set(self.footerAdPost, forKey: "footerAdPost")
                UserDefaults.standard.set(self.footerProfile, forKey: "footerProfile")
                UserDefaults.standard.set(self.footerSettings, forKey: "footerSettings")
                
                self.featuredScrollEnabled = successResponse.data.featuredScrollEnabled
                if successResponse.data.featuredScroll != nil {
                    self.featuredScrolldata = successResponse.data.featuredScroll
                    self.featuredTime = self.featuredScrolldata.duration
                    self.featuredLoop = self.featuredScrolldata.loop
                    UserDefaults.standard.set(self.featuredTime, forKey: "featuredTime")
                    UserDefaults.standard.set(self.featuredLoop, forKey: "featuredLoop")
                    
                }
                
                
                //Offers title
                self.defaults.set(successResponse.data.messagesScreen.mainTitle, forKey: "message")
                self.defaults.set(successResponse.data.messagesScreen.sent, forKey: "sentOffers")
                self.defaults.set(successResponse.data.messagesScreen.receive, forKey: "receiveOffers")
                self.defaults.set(successResponse.data.messagesScreen.blocked, forKey: "blocked")
                self.defaults.set(successResponse.data.is_WhizChat_active, forKey: "is_WhizChat_active")
                self.defaults.set(successResponse.data.WhizChatPageTitle, forKey: "Whiz_ChatPageTitle")
                self.defaults.set(successResponse.data.WhizChatAPiKey, forKey: "WhizChatAPiKey")
                self.defaults.set(successResponse.data.WhizChatEmptyMessage, forKey: "WhizChatEmptyMessage")
                self.defaults.set(successResponse.data.WhizChatStartTyping, forKey: "WhizChatStartTyping")
                self.defaults.set(successResponse.data.PusherUrl, forKey: "PusherUrl")
                self.defaults.setValue(successResponse.data.isWhatsApp, forKey: "isWhatsApp")

                if successResponse.data.extraTexts != nil {
                    self.defaults.set(successResponse.data.extraTexts.codeSentTo, forKey: "codeSentTo")
                    self.defaults.set(successResponse.data.extraTexts.notReceived, forKey: "notReceived")
                    self.defaults.set(successResponse.data.extraTexts.tryAgain, forKey: "tryAgain")
                    self.defaults.set(successResponse.data.extraTexts.verifyNumber, forKey: "verifyNumber")
                    self.defaults.set(successResponse.data.extraTexts.phonePlaceholder, forKey: "phonePlaceholder")
                    self.defaults.set(successResponse.data.extraTexts.usernamePlaceHolder, forKey: "usernamePlaceHolder")
                    self.defaults.set(successResponse.data.extraTexts.enterEmail, forKey: "enterEmail")
                }

                
                


                AddsHandler.sharedInstance.topLocationArray  = successResponse.data.appTopLocation
                self.defaults.synchronize()
                UserHandler.sharedInstance.objSettings = successResponse.data
                UserHandler.sharedInstance.objSettingsMenu = successResponse.data.menu.submenu.pages
                
                UserHandler.sharedInstance.menuKeysArray = successResponse.data.menu.dynamicMenu.keys
                
                if successResponse.data.menu.iStaticMenu != nil{
                    if successResponse.data.menu.iStaticMenu.keys != nil{
                        UserHandler.sharedInstance.otherKeysArray = successResponse.data.menu.iStaticMenu.keys
                    }
                }
                
                if successResponse.data.menu.iStaticMenu != nil{
                    if successResponse.data.menu.iStaticMenu.array != nil{
                        UserHandler.sharedInstance.otherValuesArray = successResponse.data.menu.iStaticMenu.array
                    }
                }
                
                UserDefaults.standard.set(successResponse.data.wpml_menu_text, forKey: "langHeading")
                UserDefaults.standard.set(successResponse.data.menu.topLocation, forKey: "locHeading")

                if successResponse.data.menu.iStaticMenu.array == nil{
                    if  successResponse.data.menu.iStaticMenu.array == nil {
                        if self.isWplOn == true{
                            UserHandler.sharedInstance.otherKeysArray.append("wpml_menu_text")
                            UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.wpml_menu_text)
                        }
                    }
                    if successResponse.data.menu.isShowMenu.blog == true{
                        UserHandler.sharedInstance.otherKeysArray.append("blog")
                        UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.blog)
                    }
                    
                    if successResponse.data.menu.isShowMenu.settings == true{
                        UserHandler.sharedInstance.otherKeysArray.append("app_settings")
                        UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.appSettings)
                    }
                    if successResponse.data.menu.isShowMenu.toplocation == true{
                        //                        if successResponse.data.menu.topLocation != nil{
                        print(successResponse.data.menu.isShowMenu.toplocation)
                        UserHandler.sharedInstance.otherKeysArray.append("top_location_text")
                        UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.topLocation)
                        //                        }
                        
                    }
                    
                    UserHandler.sharedInstance.otherKeysArray.append("logout")
                    UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.logout)
                    
                }
                
                if self.isWplOn == false {
                    if UserHandler.sharedInstance.menuKeysArray.contains("wpml_menu_text"){
                        
                        UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                    }
                }
                else{
                    UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                }
                
                
                //                if UserHandler.sharedInstance.menuKeysArray.contains("wpml_menu_text"){
                //                    UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                //                }
                
                UserDefaults.standard.set(successResponse.data.location_text, forKey: "loc_text")
                //adding other section items in menu for leftViewController
                
                if successResponse.data.menu.isShowMenu.blog == true{
                    self.settingBlogArr.append(successResponse.data.menu.blog)
                    UserDefaults.standard.set(true, forKey: "isBlog")
//                    self.imagesArr.append(UIImage(named: "blog")!)
                    self.imagesArr.append(UIImage(named: "blog")!)

                }
                if successResponse.data.menu.isShowMenu.settings == true{
                    UserDefaults.standard.set(true, forKey: "isSet")
                    self.imagesArr.append(UIImage(named: "settings")!)
                    self.settingBlogArr.append(successResponse.data.menu.appSettings)
                }
                
                if successResponse.data.menu.isShowMenu.toplocation == true{
                    print(successResponse.data.menu.isShowMenu.toplocation)
                    UserDefaults.standard.string(forKey: "is_top_location")
                    self.imagesArr.append(UIImage(named:"location")!)
                    self.settingBlogArr.append(successResponse.data.menu.topLocation)
                }
                
                if successResponse.data.menu.isShowMenu.isWpmlActive == true{
                    UserDefaults.standard.string(forKey: "is_wpml_active")
                    self.imagesArr.append(UIImage(named:"language")!)
                    self.settingBlogArr.append(successResponse.data.menu.wpml)

                }
                if self.imagesArr.count == 1 {
                    self.imagesArr.append(UIImage(named:"language")!)
                    self.imagesArr.append(UIImage(named:"location")!)
                    self.imagesArr.append(UIImage(named: "settings")!)
                    self.imagesArr.append(UIImage(named: "blog")!)
                }
//                if self.isWplOn == true{
//                    UserDefaults.standard.string(forKey: "is_wpml_active")
//                    self.imagesArr.append(UIImage(named:"language")!)
//                    self.settingBlogArr.append(successResponse.data.menu.wpml)
//                }
                
                
                UserDefaults.standard.set(self.settingBlogArr, forKey: "setArr")
                UserDefaults.standard.set(self.imagesArr, forKey: "setArrImg")
                print(self.imagesArr)
                
                let isLang = UserDefaults.standard.string(forKey: "langFirst")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let islocFirst = UserDefaults.standard.string(forKey: "locFirst")
                if self.isWplOn == true {
                    
                    if isLang != "1" {
                        let langCtrl = storyboard.instantiateViewController(withIdentifier: LangViewController.className) as! LangViewController
                        self.navigationController?.pushViewController(langCtrl, animated: true)
                    } else {
                        if successResponse.data.isRtl {
                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
                            self.adForest_checkLogin()
                        } else {
                            UIView.appearance().semanticContentAttribute = .forceLeftToRight
                            self.adForest_checkLogin()
                        }
                    }
                } else if self.isToplocationOn == true {
                    if islocFirst != "1"{
                        let locCtrl = storyboard.instantiateViewController(withIdentifier: SetLocationController.className) as! SetLocationController
                        self.navigationController?.pushViewController(locCtrl, animated: true)
                    }else{
                        if successResponse.data.isRtl {
                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
                            self.adForest_checkLogin()
                        } else {
                            UIView.appearance().semanticContentAttribute = .forceLeftToRight
                            self.adForest_checkLogin()
                        }
                    }
                    
                }
                else{
                    if successResponse.data.isRtl {
                        UIView.appearance().semanticContentAttribute = .forceRightToLeft
                        self.adForest_checkLogin()
                    } else {
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                        self.adForest_checkLogin()
                    }
                }
                
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
    
    
    // Login Userx
    func adForest_loginOTPUser(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.LoginOTPUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.defaults.set(true, forKey: "isLogin")
//                self.defaults.setValue(true, forKey: "otp")
                self.defaults.synchronize()
                if self.home == "home1"{
                    self.appDelegate.moveToHome()

                }else if self.home == "home2"{
                    self.appDelegate.moveToMultiHome()
                }
                else if self.home == "home3"{
                    self.appDelegate.moveToMarvelHome()
                }
                
            }
            else {
                self.appDelegate.moveToLogin()
            }
        }) { (error) in
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
                self.defaults.set(true, forKey: "isLogin")
                self.defaults.set(false, forKey: "isGuest")
//                self.defaults.setValue(true, forKey: "otp")
                self.defaults.synchronize()
                if self.home == "home1"{
                    self.appDelegate.moveToHome()

                }else if self.home == "home2"{
                    self.appDelegate.moveToMultiHome()
                }
                else if self.home == "home3"{
                    self.appDelegate.moveToMarvelHome()
                }
                
            }
            else {
                self.appDelegate.moveToLogin()
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

extension UserDefaults {
    func imageArray(forKey key: String) -> [UIImage]? {
        guard let array = self.array(forKey: key) as? [Data] else {
            return nil
        }
        return array.compactMap() { UIImage(data: $0) }
    }
    
    func set(_ imageArray: [UIImage], forKey key: String) {
        self.set(imageArray.compactMap({ UIImagePNGRepresentation($0) }), forKey: key)
    }
}
import UIKit

enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}

class AppUpdater: NSObject {

    private override init() {}
    static let shared = AppUpdater()

    func showUpdate(withConfirmation: Bool) {
        DispatchQueue.global().async {
            self.checkVersion(force : !withConfirmation)
        }
    }

    private  func checkVersion(force: Bool) {
        let info = Bundle.main.infoDictionary
        if let currentVersion = info?["CFBundleShortVersionString"] as? String {
            _ = getAppInfo { (info, error) in
                if let appStoreAppVersion = info?.version{
                    if let error = error {
                        print("error getting app store version: ", error)
                    } else if appStoreAppVersion == currentVersion {
                        print("Already on the last app version: ",currentVersion)
                    } else {
                        print("Needs update: AppStore Version: \(appStoreAppVersion) > Current version: ",currentVersion)
                            DispatchQueue.main.async {
                                let topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                                topController.showAppUpdateAlert(Version: (info?.version)!, Force: force, AppURL: (info?.trackViewUrl)!)
                        }
                    }
                }
            }
        }
    }

    private func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        guard let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                DispatchQueue.main.async {
                    completion(nil, VersionError.invalidBundleInfo)
                }
                return nil
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                guard let info = result.results.first else { throw VersionError.invalidResponse }

                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
        return task
    }
}

extension UIViewController {
    @objc fileprivate func showAppUpdateAlert( Version : String, Force: Bool, AppURL: String) {
        let appName = Bundle.appName()

        let alertTitle = "New Version"
        let alertMessage = "\(appName) Version \(Version) is available on AppStore."

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        if !Force {
            let notNowButton = UIAlertAction(title: "Not Now", style: .default) { (action:UIAlertAction) in
                let splash = Splash()
                splash.settingsdata()
            }
            alertController.addAction(notNowButton)
        }

        let updateButton = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction) in
            guard let url = URL(string: AppURL) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

        alertController.addAction(updateButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}
