//
//  WhizChatMessagesBoxChatList.swift
//  AdForest
//
//  Created by Apple on 05/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct WhizChatMessagesBoxChatList {
    
    let chatMessageID: String!
    var chatSenderID: String!
    var chatSenderName: String!
    var chatMessage: String!
    var chatPostID : String!
    var chatPostAuthor: String!
    var chatTime: String!
    var isReply: String!
    var rel : String!
    var messageType: String!
    var msg: String!
    //   var Attachemnt will be array
    //    var lastSeen will be a string!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        chatMessageID = dictionary["chat_message_id"] as? String
        chatSenderID = dictionary["chat_sender_id"] as? String
        chatSenderName = dictionary["chat_sender_name"] as? String
//        chatMessage = dictionary["msg"] as? String
        chatPostID = dictionary["chat_post_id"] as? String
        chatPostAuthor = dictionary["chat_post_author"] as? String
        chatTime = dictionary["time_chat"] as? String
        isReply = dictionary["is_reply"] as? String
        rel = dictionary["rel"] as? String
        messageType = dictionary["message_type"] as? String
        msg = dictionary["msg"] as? String
        
        
        
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
