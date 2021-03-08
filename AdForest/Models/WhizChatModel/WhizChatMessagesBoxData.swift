//
//  WhizChatMessagesBoxData.swift
//  AdForest
//
//  Created by Apple on 05/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

struct WhizChatMessagesBoxData {
    
    var id : String!
    var PostId : String!
    var LiveRoomData : String!
    var authorId:String!
    var communicationId:String!
    var ChatId: String!
    var UserName:String!
    var PostTitle:String!
    var SenderId:String!

    var BlockedStatus: WhizChatBlockUserModel!
    var ChatMessagesList: [WhizChatMessagesBoxChatList]!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary ["id"] as? String
        PostId = dictionary ["post-id"] as? String
        LiveRoomData = dictionary ["live_room_data"] as? String
        authorId = dictionary ["author-id"] as? String
        communicationId = dictionary ["communication_id"] as? String
        ChatId = dictionary ["chat-id"] as? String
        UserName = dictionary ["user_name"] as? String
        PostTitle = dictionary ["post_title"] as? String
        SenderId = dictionary ["sender_id"] as? String
        ChatMessagesList = [WhizChatMessagesBoxChatList]()
        if let itemsArray = dictionary["chat"] as? [[String:Any]]{
            for dic in itemsArray{
                let value = WhizChatMessagesBoxChatList(fromDictionary: dic)
                ChatMessagesList.append(value)
            }
        }
        if let blockeduserData = dictionary["blocked_status"] as? [String:Any]{
            BlockedStatus = WhizChatBlockUserModel(fromDictionary: blockeduserData)
        }
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
