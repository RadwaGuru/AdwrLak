//
//  ProfileCell.swift
//  AdForest
//
//  Created by apple on 3/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import Cosmos

class ProfileCell: UITableViewCell {
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var btnGoogle: UIButton!
    
    @IBOutlet weak var btnLinkedIn: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblLastlogin: UILabel!
    @IBOutlet weak var containerViewEditProfile: UIView!
    @IBOutlet weak var buttonEditProfile: UIButton! {
        didSet {
            buttonEditProfile.contentHorizontalAlignment = .left
            
        }
    }
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var lblAvgRating: UILabel!
    
    //MARK:- Properties
    var actionEdit: (()->())?
    var ratingCosmos : (() -> ())?
    var dataArraySocial  = [SellersSocialIcon]()
    var btnUrlvalue = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    
    }
//    @IBAction func btnGoogleaction(_ sender: Any) {
//    
//        let inValidUrl:String = "Invalid url"
//              
//              if #available(iOS 10.0, *) {
//                  if verifyUrl(urlString: btnUrlvalue) == false {
//                      Constants.showBasicAlert(message: inValidUrl)
//                  }else{
//                      UIApplication.shared.open(URL(string: btnUrlvalue)!, options: [:], completionHandler: nil)
//                  }
//                  
//              } else {
//                  if verifyUrl(urlString: btnUrlvalue) == false {
//                      Constants.showBasicAlert(message: inValidUrl)
//                  }else{
//                      UIApplication.shared.openURL(URL(string: btnUrlvalue)!)
//                  }
//              }
//    }
//    @IBAction func btnLinkedInaction(_ sender: Any) {
//    let inValidUrl:String = "Invalid url"
//          
//          if #available(iOS 10.0, *) {
//              if verifyUrl(urlString: btnUrlvalue) == false {
//                  Constants.showBasicAlert(message: inValidUrl)
//              }else{
//                  UIApplication.shared.open(URL(string: btnUrlvalue)!, options: [:], completionHandler: nil)
//              }
//              
//          } else {
//              if verifyUrl(urlString: btnUrlvalue) == false {
//                  Constants.showBasicAlert(message: inValidUrl)
//              }else{
//                  UIApplication.shared.openURL(URL(string: btnUrlvalue)!)
//              }
//          }
//      }
//    @IBAction func btnTwitteraction(_ sender: Any) {
//        let inValidUrl:String = "Invalid url"
//              
//              if #available(iOS 10.0, *) {
//                  if verifyUrl(urlString: btnUrlvalue) == false {
//                      Constants.showBasicAlert(message: inValidUrl)
//                  }else{
//                      UIApplication.shared.open(URL(string: btnUrlvalue)!, options: [:], completionHandler: nil)
//                  }
//                  
//              } else {
//                  if verifyUrl(urlString: btnUrlvalue) == false {
//                      Constants.showBasicAlert(message: inValidUrl)
//                  }else{
//                      UIApplication.shared.openURL(URL(string: btnUrlvalue)!)
//                  }
//              }
//         }
//    @IBAction func btnFBaction(_ sender: Any) {
////        let viewLink = UserDefaults.standard.string(forKey: "socialIcons")
//        //stringArray(forKey: "socialIcons")
////        print(viewLink)
//        let inValidUrl:String = "Invalid url"
//        
//        if #available(iOS 10.0, *) {
//            if verifyUrl(urlString: btnUrlvalue) == false {
//                Constants.showBasicAlert(message: inValidUrl)
//            }else{
//                UIApplication.shared.open(URL(string: btnUrlvalue)!, options: [:], completionHandler: nil)
//            }
//            
//        } else {
//            if verifyUrl(urlString: btnUrlvalue) == false {
//                Constants.showBasicAlert(message: inValidUrl)
//            }else{
//                UIApplication.shared.openURL(URL(string: btnUrlvalue)!)
//            }
//        }
//       }
//    
//    func verifyUrl (urlString: String?) -> Bool {
//           //Check for nil
//           if let urlString = urlString {
//               // create NSURL instance
//               if let url = NSURL(string: urlString) {
//                   // check if your application can open the NSURL instance
//                   return UIApplication.shared.canOpenURL(url as URL)
//               }
//           }
//           return false
//       }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionEditProfile(_ sender: Any) {
        actionEdit?()
    }
    func didTouchCosmos(_ rating: Double) {
        ratingCosmos?()
        print("Rating Clicked")
    }
    
    func didFinishTouchingCosmos(_ rating: Double) {
        
        print("Rating Clicked is That")
    }
    
 func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 70, y: 120, width:  100, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        contentView.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.3, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}
