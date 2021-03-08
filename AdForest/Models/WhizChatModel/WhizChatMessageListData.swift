//
//  WhizChatMessageListData.swift
//  AdForest
//
//  Created by Apple on 04/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

struct WhizChatMessageListData {
    var AdTitle: String!
    var receiverName: String!
    var ImageUrl:String!
    var ChatId: String!
    var lastActive: String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        AdTitle = dictionary["post_title"] as? String
        receiverName = dictionary["receiver_name"] as? String
        ImageUrl = dictionary["image_url"] as? String
        ChatId = dictionary["chat_id"] as? String
        lastActive = dictionary["last_active_time-id"] as? String

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

