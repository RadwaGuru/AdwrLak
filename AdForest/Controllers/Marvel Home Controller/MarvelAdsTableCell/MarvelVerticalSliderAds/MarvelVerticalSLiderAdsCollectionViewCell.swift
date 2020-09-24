//
//  MarvelVerticalSLiderAdsCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 14/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelVerticalSLiderAdsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblTimer: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblTimer.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var imgLocation: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                imgLocation.image = imgLocation.image?.withRenderingMode(.alwaysTemplate)
                imgLocation.tintColor = UIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adImg: UIImageView!{
        didSet{
            adImg.marvelRoundCorners()
            adImg.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.marveladdShadowToView()
        }
    }
    
    
    var futureDate = ""
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var isEndTime = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Timer.every(1.second) {
            self.countDown(date: self.futureDate)
            
            self.lblTimer.text = "\(self.day) : \(self.hour) : \(self.minute) : \(self.second) "
            
            
            
        }
        
        
    }
    
    //MARK:- Counter
    func countDown(date: String) {
        
        let calendar = Calendar.current
        let requestComponents = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .nanosecond])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeNow = Date()
        guard let dateis = dateFormatter.date(from: date) else {
            return
        }
        let timeDifference = calendar.dateComponents(requestComponents, from: timeNow, to: dateis)
        day = timeDifference.day!
        hour = timeDifference.hour!
        minute = timeDifference.minute!
        second = timeDifference.second!
        
    }
    var btnFullAction: (()->())?
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
    
    
    
}
