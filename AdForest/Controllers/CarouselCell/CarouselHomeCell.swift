//
//  CarouselHomeCell.swift
//  AdForest
//
//  Created by Apple on 22/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import FSPagerView
class CarouselHomeCell: UITableViewCell,FSPagerViewDataSource,FSPagerViewDelegate  {

    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.delegate = self
            self.pagerView.dataSource = self
            self.pagerView.isInfinite = true
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
            let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            let screenSize = UIScreen.main.bounds
        
            let screenWidth = screenSize.width
            pagerView.itemSize = CGSize(width: screenWidth, height: 250).applying(transform)

//            self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
            self.pagerView.decelerationDistance = FSPagerView.automaticDistance
        }
    }
    let data = AddsHandler.sharedInstance.objHomeData
    var dataArray = [CatLocation]()
    var delegate : MarvelLocationCategoryDelegate?
    var  adsCOunt : String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return (data?.catLocations.count)!
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let objData  = data?.catLocations[index]
        if let imgUrl = URL(string: (objData?.img.encodeUrl())!) {
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setIndicatorStyle(.gray)
            cell.imageView?.sd_setImage(with: imgUrl, completed: nil)
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
        }
        
        adsCOunt = objData?.count
        print(adsCOunt)
        if let locationTitle = objData?.name {
            
            cell.textLabel?.text = "\(locationTitle) \(adsCOunt!)"
        }
        cell.imageView?.tag = (objData?.catId)!

        return cell
    }
    

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let idsArr = data?.catLocations[index]
        print(idsArr?.catId!)

//        self.delegate?.goToCLocationDetail(id:(idsArr?.catId!)!)


        
    }
}
