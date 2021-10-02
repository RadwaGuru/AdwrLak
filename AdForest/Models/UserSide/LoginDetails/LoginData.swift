//
//  LoginData.swift
//  AdForest
//
//  Created by apple on 3/19/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct LoginData {
    
    var bgColor : String!
    var emailPlaceholder : String!
    var facebookBtn : String!
    var appleBtn : String!
    var forgotText : String!
    var formBtn : String!
    var googleBtn : String!
    var linkedInBtn : String!
    var guestLogin : String!
    var emailBtn:String!
    var phoneBtn:String!
    var PhoneVerificationtxt:String!
    var OtpText:String!
    var welcomeTxt:String!
    var intoTxt:String!
    var guestText : String!
    var heading : String!
    var logo : String!
    var passwordPlaceholder : String!
    var registerText : String!
    var separator : String!
    var isVerifyOn : Bool!
    var pageTitle:String!
    var registerTitle:String!
    var codeSentTo: String!
    var notReceived: String!
    var tryAgain:String!
    var verifyNumber:String!
    var phonePlaceholder:String!
    var enterPhoneError:String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bgColor = dictionary["bg_color"] as? String
        emailPlaceholder = dictionary["email_placeholder"] as? String
        facebookBtn = dictionary["facebook_btn"] as? String
        appleBtn = dictionary["apple_btn"] as? String
        forgotText = dictionary["forgot_text"] as? String
        formBtn = dictionary["form_btn"] as? String
        googleBtn = dictionary["google_btn"] as? String
        phoneBtn = dictionary["phone_btn"] as? String
        emailBtn = dictionary["email_btn"] as? String
        linkedInBtn = dictionary["linkedin_btn"] as? String
        guestLogin = dictionary["guest_login"] as? String
        guestText = dictionary["guest_text"] as? String
        heading = dictionary["heading"] as? String
        logo = dictionary["logo"] as? String
        passwordPlaceholder = dictionary["password_placeholder"] as? String
        registerText = dictionary["register_text"] as? String
        separator = dictionary["separator"] as? String
        isVerifyOn = dictionary["is_verify_on"] as? Bool
        PhoneVerificationtxt = dictionary["phone_verification"] as? String
        OtpText = dictionary["otp_text"] as? String
        welcomeTxt = dictionary["welcome_txt"] as? String
        intoTxt = dictionary["intro_text"] as? String
        pageTitle = dictionary["page_title"] as? String
        registerTitle = dictionary["register"] as? String
        codeSentTo  = dictionary["code_sent"] as? String
        notReceived = dictionary["not_received"] as? String
        tryAgain = dictionary["try_again"] as? String
        verifyNumber = dictionary["verify_number"] as? String
        phonePlaceholder = dictionary["phone_number"] as? String
        enterPhoneError = dictionary["input_number"] as? String

    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bgColor != nil{
            dictionary["bg_color"] = bgColor
        }
        if emailPlaceholder != nil{
            dictionary["email_placeholder"] = emailPlaceholder
        }
        if facebookBtn != nil{
            dictionary["facebook_btn"] = facebookBtn
        }
        if appleBtn != nil{
            dictionary["apple_btn"] = appleBtn
        }
        if forgotText != nil{
            dictionary["forgot_text"] = forgotText
        }
        if formBtn != nil{
            dictionary["form_btn"] = formBtn
        }
        if googleBtn != nil{
            dictionary["google_btn"] = googleBtn
        }
        if guestLogin != nil{
            dictionary["guest_login"] = guestLogin
        }
        if guestText != nil{
            dictionary["guest_text"] = guestText
        }
        if heading != nil{
            dictionary["heading"] = heading
        }
        if logo != nil{
            dictionary["logo"] = logo
        }
        if passwordPlaceholder != nil{
            dictionary["password_placeholder"] = passwordPlaceholder
        }
        if registerText != nil{
            dictionary["register_text"] = registerText
        }
        if separator != nil{
            dictionary["separator"] = separator
        }
        if isVerifyOn != nil{
            dictionary["is_verify_on"] = isVerifyOn
        }
        return dictionary
    }
    
}
