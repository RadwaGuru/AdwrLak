//
//  WhizChatInitData.swift
//  AdForest
//
//  Created by Apple on 03/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation


struct WhizChatInitData {
    var postId: String!
    var roomId: String!
    var communicationId:String!
    var chatId: Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        postId = dictionary["post_id"] as? String
        roomId = dictionary["room_id"] as? String
        communicationId = dictionary["comm_id"] as? String
        chatId = dictionary["chat-id"] as? Int

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

