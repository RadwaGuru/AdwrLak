//
//  ViewAttachmentImageViewController.swift
//  AdForest
//
//  Created by Apple on 19/01/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import FSPagerView
class ViewAttachmentImageViewController: UIViewController,FSPagerViewDataSource,FSPagerViewDelegate {
   
    
    
    
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgCancel: UIImageView!
    
    @IBOutlet weak var pagerView: FSPagerView!{didSet {
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.isInfinite = true
        self.pagerView.transformer = FSPagerViewTransformer(type: .coverFlow)
        let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let screenSize = UIScreen.main.bounds
    
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.pagerView.isInfinite = false
        self.pagerView.itemSize = FSPagerView.automaticSize
        self.pagerView.decelerationDistance = FSPagerView.automaticDistance
    }
}
    var imageAttachment: [String] = []

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         showBackButton()
        imgCancel.isHidden = true
        btnCancel.isHidden = true

    }
    
    
    @IBAction func BtnActionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageAttachment.count
            //(data?.catLocations.count)!

    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        if let imgUrl = URL(string: imageAttachment[index]) {
            
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setIndicatorStyle(.white)
            cell.imageView?.sd_setImage(with: imgUrl, completed: nil)
            cell.imageView?.contentMode = .scaleAspectFit
            cell.imageView?.clipsToBounds = true
            

        }


        return cell
    }
    

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)


        
    }

}

