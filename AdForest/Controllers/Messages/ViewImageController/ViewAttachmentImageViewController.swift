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
    
    
    
    
    @IBOutlet weak var pagerView: FSPagerView!{didSet {
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.isInfinite = true
        self.pagerView.transformer = FSPagerViewTransformer(type: .cubic)
        let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        let screenSize = UIScreen.main.bounds
    
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        self.pagerView.isInfinite = false
//        pagerView.itemSize = CGSize(width: 400, height: 500)
        self.pagerView.itemSize = FSPagerView.automaticSize

            //.applying(transform)

//        pagerView.itemSize = CGSize(width: screenWidth, height: screenHeight).applying(transform)

//            self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
        self.pagerView.decelerationDistance = FSPagerView.automaticDistance
    }
}
//    @IBOutlet weak var photoSliderView: PhotoSliderView!{
//        didSet{
//            photoSliderView.isHidden = true
//        }
//    }
    
    var imageAttachment: [String] = []
        //[UIImage]()
    let data = AddsHandler.sharedInstance.objHomeData

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         showBackButton()
        // Static setup
//        let images = [#imageLiteral(resourceName: "pak"),#imageLiteral(resourceName: "menu-1"),#imageLiteral(resourceName: "home-1"),#imageLiteral(resourceName: "instagram"),#imageLiteral(resourceName: "heart")]
//        photoSliderView.configure(with: imageAttachment)
        print(imageAttachment)

    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageAttachment.count
            //(data?.catLocations.count)!

    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        let objData  = data?.catLocations[index]
//        if let imgUrl = URL(string: (objData?.img.encodeUrl())!) {
//            cell.imageView?.sd_setShowActivityIndicatorView(true)
//            cell.imageView?.sd_setIndicatorStyle(.gray)
//            cell.imageView?.sd_setImage(with: imgUrl, completed: nil)
//            cell.imageView?.contentMode = .scaleAspectFill
//            cell.imageView?.clipsToBounds = true
//        }
        if let imgUrl = URL(string: imageAttachment[index]) {
            
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setIndicatorStyle(.white)
            cell.imageView?.sd_setImage(with: imgUrl, completed: nil)
//            cell.imageView?.image = UIImage(contentsOfFile: objData)
            cell.imageView?.contentMode = .scaleAspectFit
            cell.imageView?.clipsToBounds = true
//                    self.tableView.reloadData()
            

        }
//        let objData = imageAttachment[index]
//        cell.imageView?.image = UIImage(contentsOfFile: objData)
//        cell.imageView?.contentMode = .scaleAspectFit
//        cell.imageView?.clipsToBounds = true
//        cell.imageView?.enableZoom()
//
//        adsCOunt = objData?.count
//        print(adsCOunt)
//        if let locationTitle = objData?.name {
//
//            cell.textLabel?.text = "\(locationTitle) \(adsCOunt!)"
//        }
//        cell.imageView?.tag = (objData?.catId)!

        return cell
    }
    

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
//        let idsArr = data?.catLocations[index]
//        print(idsArr?.catId!)

//        self.delegate?.goToCLocationDetail(id:(idsArr?.catId!)!)


        
    }

}
extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
