//
//  WhizChatMessageList.swift
//  AdForest
//
//  Created by Apple on 04/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation


struct WhizChatMessageList {
    var ChatList: [WhizChatMessageListData]!
    var WhizChatPageTitle: String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        ChatList = [WhizChatMessageListData]()
        if let itemsArray = dictionary["chat_list"] as? [[String:Any]]{
            for dic in itemsArray{
                let value = WhizChatMessageListData(fromDictionary: dic)
                ChatList.append(value)
            }
        }
        WhizChatPageTitle = dictionary["page_title"] as? String

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

