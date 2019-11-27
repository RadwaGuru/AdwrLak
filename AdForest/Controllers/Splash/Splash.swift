//
//  Splash.swift
//  Adforest
//
//  Created by apple on 3/7/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Splash: UIViewController, NVActivityIndicatorViewable {
    
    
    //MARK:- Properties
    
    var defaults = UserDefaults.standard
    var isAppOpen = false
    var settingBlogArr = [String]()
    var isBlogImg:Bool = false
    var isSettingImg:Bool = false
    var imagesArr = [UIImage]()
    var isWplOn = false
    
    //MARK:- Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsdata()
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
            } else {
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
                self.appDelegate.moveToHome()
            } else {
                self.appDelegate.moveToLogin()
            }
        }
    }
    
    //MARK:- API Call
    func settingsdata() {
        self.showLoader()
        UserHandler.settingsdata(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                
                self.defaults.set(successResponse.data.mainColor, forKey: "mainColor")
                self.appDelegate.customizeNavigationBar(barTintColor: Constants.hexStringToUIColor(hex: successResponse.data.mainColor))
                self.defaults.set(successResponse.data.isRtl, forKey: "isRtl")
                UserDefaults.standard.set(successResponse.data.gmapLang, forKey: "langCod")
                self.defaults.set(successResponse.data.notLoginMsg, forKey: "notLogin")
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
                UserDefaults.standard.set(self.isWplOn, forKey: "isWpOn")
                UserDefaults.standard.set(successResponse.data.wpml_menu_text, forKey: "meuText")
                //Offers title
                self.defaults.set(successResponse.data.messagesScreen.mainTitle, forKey: "message")
                self.defaults.set(successResponse.data.messagesScreen.sent, forKey: "sentOffers")
                self.defaults.set(successResponse.data.messagesScreen.receive, forKey: "receiveOffers")
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
                    
                    if successResponse.data.menu.topLocation != nil{
                        UserHandler.sharedInstance.otherKeysArray.append("top_location_text")
                        UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.topLocation)
                        
                    }
                    
                    UserHandler.sharedInstance.otherKeysArray.append("logout")
                    UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.logout)
                    
                }
                
                if self.isWplOn == false {
                    if UserHandler.sharedInstance.menuKeysArray.contains("wpml_menu_text"){
                        UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                    }
                }else{
                    UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                }
                
                //                if UserHandler.sharedInstance.menuKeysArray.contains("wpml_menu_text"){
                //                    UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                //                }
                
                UserDefaults.standard.set(successResponse.data.location_text, forKey: "loc_text")
                if successResponse.data.menu.isShowMenu.blog == true{
                    self.settingBlogArr.append(successResponse.data.menu.blog)
                    UserDefaults.standard.set(true, forKey: "isBlog")
                    self.imagesArr.append(UIImage(named: "blog")!)
                }
                if successResponse.data.menu.isShowMenu.settings == true{
                    UserDefaults.standard.set(true, forKey: "isSet")
                    self.imagesArr.append(UIImage(named: "settings")!)
                    self.settingBlogArr.append(successResponse.data.menu.appSettings)
                }
                
                UserDefaults.standard.set(self.settingBlogArr, forKey: "setArr")
                UserDefaults.standard.set(self.imagesArr, forKey: "setArrImg")
                print(self.imagesArr)
                
                let isLang = UserDefaults.standard.string(forKey: "langFirst")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if self.isWplOn == true {
                    
                    if isLang == "1" {
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
                }else{
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
    
    // Login User
    func adForest_loginUser(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.loginUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.defaults.set(true, forKey: "isLogin")
                self.defaults.synchronize()
                self.appDelegate.moveToHome()
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
