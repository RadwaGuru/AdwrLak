//
//  BannerCarouselRoot.swift
//  AdForest
//
//  Created by Apple on 13/04/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct BannerCarouselRoot {
    var BannerSliders: [BannerCarouselData]!
    var isAutoScroll: Bool!
    var AutoScrollSpeed: String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        BannerSliders = [BannerCarouselData]()
            if let catIconsArray = dictionary["sliders"] as? [[String:Any]]{
                for dic in catIconsArray{
                    let value = BannerCarouselData(fromDictionary: dic)
                    BannerSliders.append(value)
                }
            }
        isAutoScroll = dictionary["auto_scrol"] as? Bool
        AutoScrollSpeed = dictionary["carousel_speed"] as? String

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
