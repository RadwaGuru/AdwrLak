//
//  WhizChatBlockUserModel.swift
//  AdForest
//
//  Created by Apple on 05/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct WhizChatBlockUserModel {
    
    let id: Int!
    var CurrentSession: Int!
    var BlockedId: String!
    var BlockerID: Int!
    var PostId : String!
    var ChatSession: String!
    var isBLocked: Bool!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        CurrentSession = dictionary["current_session"] as? Int
        BlockedId = dictionary["blocked_id"] as? String
        BlockerID = dictionary["blocker_id"] as? Int
        PostId = dictionary["post_id"] as? String
        ChatSession = dictionary["chat_session"] as? String
        isBLocked = dictionary["is_blocked"] as? Bool
        
        
        
        
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
