//
//  MarvelAdsTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 01/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
protocol MarvelRelatedAddDetailDelegate{
    func goToAddDetail(ad_id : Int)
}
class MarvelAdsTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var heightConstraintTitle: NSLayoutConstraint!
    
    @IBOutlet weak var oltViewAll: UIButton!
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            
            
        }
    }
    //MARK:- Properties
    
    var dataArray = [HomeAdd]()
    var delegate : MarvelRelatedAddDetailDelegate?
//    private var scrollView = UIScrollView.init()
    private var topCollView: DynmicHeightCollectionView!


        var btnViewAll :(()->())?
    //    var day: Int = 0
    //    var hour: Int = 0
    //    var minute: Int = 0
    //    var second: Int = 0
    //    var serverTime = ""
    //    var isEndTime = ""
    //    var latestVertical: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    //    var latestHorizontalSingleAd: String =  UserDefaults.standard.string(forKey: "homescreenLayout")!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setupViews()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
      private func setupViews() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint.init(item: contentView, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 1, constant: 0)
        heightConstraint.priority = UILayoutPriority.init(200)
        

        
        self.contentView.addConstraints([
          self.contentView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
          heightConstraint,
          ])
               
        self.topCollView = returnCollView()
        self.topCollView.register(MarvelAdsCollectionViewCell.self, forCellWithReuseIdentifier: MarvelAdsCollectionViewCell.identifier)
        self.topCollView.layer.cornerRadius = 5.0
        self.topCollView.layer.borderColor = #colorLiteral(red: 0.4039215686, green: 0.4666666667, blue: 0.7215686275, alpha: 1).cgColor
        self.topCollView.layer.borderWidth = 1.25
        self.topCollView.isDynamicSizeRequired = true
        
      }

     private func returnCollView() -> DynmicHeightCollectionView {
        
        let layout = TokenCollViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let collView = DynmicHeightCollectionView.init(frame: .zero, collectionViewLayout: layout)
        collView.translatesAutoresizingMaskIntoConstraints = false
        collView.delegate = self
        collView.dataSource = self
        collView.backgroundColor = .clear
        return collView
      }

    //MARK:- Custom
    
    func reloadData() {
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  MarvelAdsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelAdsCollectionViewCell", for: indexPath) as! MarvelAdsCollectionViewCell
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
            //            let word = objData.adTimer.timer
            //            if objData.adTimer.isShow {
            //                let first10 = String(word!.prefix(10))
            //                print(first10)
            //                //                           cell.lblTimer.isHidden = true
            //                //                           cell.lblBidTimer.isHidden = false
            //
            //                if first10 != ""{
            //                    let endDate = first10
            //                    self.isEndTime = endDate
            //                    Timer.every(1.second) {
            //                        //                                   self.countDown(date: endDate)
            //                        //                                   cell.lblBidTimer.text = "\(self.day) : \(self.hour) : \(self.minute) : \(self.second) "
            //
            //                    }
            //                }
            //            }else{
            //                //                           cell.lblBidTimer.isHidden = true
            //            }
            //
        }
        if let location = objData.adLocation.address {
            cell.lblLocation.text = location
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        cell.btnFullAction = { () in
            self.delegate?.goToAddDetail(ad_id: objData.adId)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.width,height: 106)
        
    }
    
    //MARK:- Actions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
    
}
