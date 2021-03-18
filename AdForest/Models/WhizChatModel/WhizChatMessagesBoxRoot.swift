//
//  WhizChatMessagesBox.swift
//  AdForest
//
//  Created by Apple on 05/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct WhizChatMessagesBoxRoot {
    
    var data : WhizChatMessagesBoxData!
    var message : String!
    var success : Bool!
    var extra: WhizChatMessagesBoxExtraData!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = WhizChatMessagesBoxData(fromDictionary: dataData)
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
        if let extraData = dictionary["extra"] as? [String:Any]{
            extra = WhizChatMessagesBoxExtraData(fromDictionary: extraData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        if extra != nil {
            dictionary["extra"] = extra
        }
        return dictionary
    }
    
}
