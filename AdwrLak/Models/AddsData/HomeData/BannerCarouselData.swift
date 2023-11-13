//
//  BannerCarouselData.swift
//  AdForest
//
//  Created by Apple on 13/04/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct BannerCarouselData {
    var img : String!
    var title : String!
    var type : String!
    var url : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        img = dictionary["image"] as? String
        title = dictionary["title"] as? String
        type = dictionary["description"] as? String
        url  = dictionary ["url"] as? String
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
