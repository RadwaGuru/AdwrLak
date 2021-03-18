//
//  WhizChatMessagesBoxExtraData.swift
//  AdForest
//
//  Created by Apple on 16/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct WhizChatMessagesBoxExtraData {
    
    var imageFormat:[String]!
    var imageSize:Int!
    var imageAllowed:String!
    var fileFormat:[String]!
    var fileSize:Int!
    var fileAllow:String!
    var ImageLimitText:String!
    var DocLimitText:String!
    var docFormatText:String!
    var uploadImageHeading:String!
    var uploadDocumentHeading:String!
    var ImageFormatText:String!
    var uploadLocationHeading: String!
    var isLcoationAllowed: String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        imageFormat = dictionary["image_format"] as? [String]
        imageSize = dictionary["image_size"] as? Int
        imageAllowed = dictionary["image_allow"] as? String
        fileFormat = dictionary["file_format"] as? [String]
        fileSize = dictionary["file_size"] as? Int
        fileAllow = dictionary["file_allow"] as? String
        ImageLimitText = dictionary["image_limit_txt"] as? String
        DocLimitText = dictionary["doc_limit_txt"] as? String
        docFormatText = dictionary["doc_format_txt"] as? String
        //        ImageFormatText = dictionary["doc_format_txt"] as? String
        uploadImageHeading = dictionary["upload_image"] as? String
        uploadDocumentHeading = dictionary["upload_doc"] as? String
        uploadLocationHeading = dictionary["upload_loc"] as? String
        isLcoationAllowed = dictionary["location_allow"] as? String
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

