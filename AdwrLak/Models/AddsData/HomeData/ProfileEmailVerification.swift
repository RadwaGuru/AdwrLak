//
//  ProfileEmailVerification.swift
//  AdForest
//
//  Created by Apple on 26/07/2023.
//  Copyright © 2023 apple. All rights reserved.
//

import Foundation


struct ProfileEmailVerification{

    var otpAlertMsg : String!
    var otpAlertCancel : String!
    var otpAlertProfile : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        otpAlertMsg = dictionary["title"] as? String
        otpAlertCancel = dictionary["btn_no"] as? String
        otpAlertProfile = dictionary["btn_ok"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if otpAlertMsg != nil{
            dictionary["title"] = otpAlertMsg
        }
        if otpAlertCancel != nil{
            dictionary["btn_no"] = otpAlertCancel
        }
        if otpAlertProfile != nil{
            dictionary["btn_ok"] = otpAlertProfile
        }
        return dictionary
    }
}
