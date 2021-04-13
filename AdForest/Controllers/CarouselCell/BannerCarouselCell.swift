//
//  BannerCarouselCell.swift
//  AdForest
//
//  Created by Apple on 07/04/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import SDWebImage
protocol OpenPublicProfileDelegate {
    func publicProdile(id:String)
}
protocol OpenBannerCarouselDelegate {
    func openCarousel(url:String,title:String)
}
protocol BannerCategoryDetailDelegate {
    func goToCategoryDetail(id: Int)
}


class BannerCarouselCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            
        }
    }
    @IBOutlet weak var mainContainer: UIView!{
        didSet{
            mainContainer.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:-Properties
    var delegate:OpenBannerCarouselDelegate?
    var listDelegate:BannerCategoryDetailDelegate?
    var PublicProfileDelegate:OpenPublicProfileDelegate?
    var dataArray = [BannerCarouselData]()
    var isAutoScroll : Bool!
    var AutoScrollSpeeed = ""
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
        //            startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl?.currentPage = Int(roundedIndex)
    }
    //MARK:- Custom Timer
    func startTimer() {
        let time: String = AutoScrollSpeeed
        if time != ""{
            let dur = time
            var msToSeconds: Double { Double(dur)! / 1000 }
            debugPrint("Timer for Slider :: \(msToSeconds)")
            Timer.scheduledTimer(timeInterval: TimeInterval(msToSeconds), target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
        }
    }
    //MARK:-CollectionView Auto Scroll
    
    @objc func scrollToNextCell() {
        if counter < dataArray.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
            pageControl.currentPage = counter
        }else{
            counter = 0
            let index  = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
    }
    
    //MARK:- CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  BannerCarouselCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCarouselCollectionViewCell", for: indexPath) as! BannerCarouselCollectionViewCell
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = dataArray.count
        pageControl.currentPage = 0
        
        let objData = dataArray[indexPath.row]
        cell.imgViewCarousel.contentMode = .scaleToFill
        if let imgUrl = URL(string: objData.img) {
            cell.imgViewCarousel.sd_setShowActivityIndicatorView(true)
            cell.imgViewCarousel.sd_setIndicatorStyle(.gray)
            cell.imgViewCarousel.sd_setImage(with: imgUrl, completed: nil)
        }
        
        cell.btnFullAction = { () in

            if objData.type == "web" {
                self.delegate?.openCarousel(url: objData.url,title: objData.title)
            }else if objData.type == "category" {
                self.listDelegate?.goToCategoryDetail(id: Int(objData.url)!)
            }
            else if objData.type == "profile"{
                self.PublicProfileDelegate?.publicProdile(id: objData.url)
                
            }
            else{
                debugPrint("======FallsInElse=======")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
                self.collectionView.decelerationRate = 0.5
                
            })
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
