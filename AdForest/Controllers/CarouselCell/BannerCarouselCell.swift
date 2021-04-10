//
//  BannerCarouselCell.swift
//  AdForest
//
//  Created by Apple on 07/04/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import SDWebImage

protocol OpenBannerCarouselDelegate {
    func openCarousel(url:String)
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

        //?
    let urlImages = //["https://i.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68","https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE","https://i.picsum.photos/id/1000/5626/3635.jpg?hmac=qWh065Fr_M8Oa3sNsdDL8ngWXv2Jb-EE49ZIn6c0P-g","https://i.picsum.photos/id/100/2500/1656.jpg?hmac=gWyN-7ZB32rkAjMhKXQgdHOIBRHyTSgzuOK6U0vXb1w","https://i.picsum.photos/id/1002/4312/2868.jpg?hmac=5LlLE-NY9oMnmIQp7ms6IfdvSUQOzP_O3DPMWmyNxwo","https://i.picsum.photos/id/1003/1181/1772.jpg?hmac=oN9fHMXiqe9Zq2RM6XT-RVZkojgPnECWwyEF1RvvTZk","https://i.picsum.photos/id/1004/5616/3744.jpg?hmac=Or7EJnz-ky5bsKa9_frdDcDCR9VhCP8kMnbZV6-WOrY","https://i.picsum.photos/id/1005/5760/3840.jpg?hmac=2acSJCOwz9q_dKtDZdSB-OIK1HUcwBeXco_RMMTUgfY","https://i.picsum.photos/id/1006/3000/2000.jpg?hmac=x83pQQ7LW1UTo8HxBcIWuRIVeN_uCg0cG6keXvNvM8g","https://i.picsum.photos/id/1008/5616/3744.jpg?hmac=906z84ml4jhqPMsm4ObF9aZhCRC-t2S_Sy0RLvYWZwY","https://i.picsum.photos/id/1011/5472/3648.jpg?hmac=Koo9845x2akkVzVFX3xxAc9BCkeGYA9VRVfLE4f0Zzk"]
        ["http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171101181927887.jpg",
                      "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114171645011.jpg",
                      "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20171114172009707.png","https://images.unsplash.com/photo-1615220368123-9bb8faf4221b?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
                      "https://source.unsplash.com/collection/190727/1600x900",
                      "https://source.unsplash.com/weekly?water"
                      ]
    var counter = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
        startTimer()
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = urlImages.count
        pageControl.currentPage = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControl?.currentPage = Int(roundedIndex)
    }
    func startTimer(){
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
        
    }
    //MARK:-CollectionView Auto Scroll
 
    @objc func scrollToNextCell() {
        if counter < urlImages.count{
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
//        let cellSize = CGSize(width: frame.width, height: frame.height)
//        let contentOffset = collectionView.contentOffset
//        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }
    
    //MARK:- CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  BannerCarouselCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCarouselCollectionViewCell", for: indexPath) as! BannerCarouselCollectionViewCell
        let objData = urlImages[indexPath.row]
        cell.imgViewCarousel.contentMode = .scaleToFill
        if let imgUrl = URL(string: objData) {
            cell.imgViewCarousel.sd_setShowActivityIndicatorView(true)
            cell.imgViewCarousel.sd_setIndicatorStyle(.gray)
            cell.imgViewCarousel.sd_setImage(with: imgUrl, completed: nil)
        }
        cell.btnFullAction = { () in
        print(objData)
            let catOnly = false
            let catId  = "79"
            if catOnly == true{
                self.listDelegate?.goToCategoryDetail(id: Int(catId)!)
            }
            else{
                self.delegate?.openCarousel(url: objData)
            }
            
        }
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   //collectionView.frame.width/2.0
        return CGSize(width:collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collection View pressed at ::\(indexPath) ")
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
