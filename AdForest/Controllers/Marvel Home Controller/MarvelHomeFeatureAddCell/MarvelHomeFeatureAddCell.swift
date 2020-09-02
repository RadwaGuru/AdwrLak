//
//  MarvelHomeFeatureAddCell.swift
//  AdForest
//
//  Created by Charlie on 28/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
protocol MarvelAddDetailDelegate{
    func goToAddDetail(ad_id : Int)
}

class MarvelHomeFeatureAddCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            
            
        }
        
    }
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    //{
    //        didSet{
    ////            collectionLayout.estimatedItemSize =
    //            //UICollectionViewFlowLayoutAutomaticSize
    //                //UICollectionViewFlowLayout.automaticSize
    //
    //        }
    //    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.clear
            containerView.roundCorners()
            
        }
    }
    
    
    
    //MARK:- Properties
    var delegate: MarvelAddDetailDelegate?
    var dataArray = [HomeAdd]()
    
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    var latestVertical: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var latestHorizontalSingleAd: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width,height: 110)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  MarvelHomeFeatureAddCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelHomeFeatureAddCollectionViewCell", for: indexPath) as! MarvelHomeFeatureAddCollectionViewCell
        let objData = dataArray[indexPath.row]
        for item in objData.adImages {
            if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                cell.adImg.sd_setShowActivityIndicatorView(true)
                cell.adImg.sd_setIndicatorStyle(.gray)
                cell.adImg.sd_setImage(with: imgUrl, completed: nil)
                
            }
        }
        
        if let name = objData.adTitle {
            cell.lblTitle.text = name
            let word = objData.adTimer.timer
            if objData.adTimer.isShow {
                let first10 = String(word!.prefix(10))
                print(first10)
                //                             cell.lblTimer.isHidden = true
                //                             cell.lblBidTimer.isHidden = false
                
                if first10 != ""{
                    let endDate = first10
                    self.isEndTime = endDate
                    Timer.every(1.second) {
                        //                                     self.countDown(date: endDate)
                        //                                     cell.lblBidTimer.text = "\(self.day) : \(self.hour) : \(self.minute) : \(self.second) "
                        
                    }
                }
            }else{
                //                             cell.lblBidTimer.isHidden = true
            }
            
        }
        if let location = objData.adLocation.address {
            cell.lblLocation.text = location
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        if UserDefaults.standard.bool(forKey: "isRtl") {
            //         featuredStarImg
            cell.featuredStarImg.image = UIImage(named: "featured_stars_rtl_round")
            //            image = UIImage(named: "featured_stars_rtl_round")
        }else{
            cell.featuredStarImg.image = UIImage(named: "featured_stars_round")
        }

        //                     if let featurText = objData.adStatus.featuredTypeText {
        //                         cell.lblFeature.text = featurText
        //                         cell.lblFeature.backgroundColor = Constants.hexStringToUIColor(hex: "#E52D27")
        //                     }
        cell.btnFullAction = { () in
            self.delegate?.goToAddDetail(ad_id: objData.adId)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
             if collectionView.isDragging {
    //            UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
    //
    ////                if indexPath.row % 2 == 0 {
    ////                    AnimationUtility.viewSlideInFromLeft(toRight: cell)
    ////                }
    ////                else {
    //                    AnimationUtility.viewSlideInFromRight(toLeft: cell)
    ////                }
    //
    //            }, completion: { (done) in
    //            })
                 cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                 UIView.animate(withDuration: 0.3, animations: {
                     cell.transform = CGAffineTransform.identity
                 })
             }
         }
    
    
}
