//
//  SettingsExtra.swift
//  AdForest
//
//  Created by Apple on 10/05/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

struct SettingsExtra {
    
    var codeSentTo: String!
    var notReceived: String!
    var tryAgain:String!
    var verifyNumber:String!
    var phonePlaceholder:String!
    var usernamePlaceHolder:String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        codeSentTo  = dictionary["code_sent"] as? String
        notReceived = dictionary["not_received"] as? String
        tryAgain = dictionary["try_again"] as? String
        verifyNumber = dictionary["verify_number"] as? String
        phonePlaceholder = dictionary["phone"] as? String
        usernamePlaceHolder = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        return dictionary
    }
    
}
