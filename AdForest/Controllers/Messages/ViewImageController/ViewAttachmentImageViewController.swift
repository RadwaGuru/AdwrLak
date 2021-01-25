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
        if let imgUrl = URL(string: imageAttachment[index]) {
            
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setIndicatorStyle(.white)
            cell.imageView?.sd_setImage(with: imgUrl, completed: nil)
//            cell.imageView?.image = UIImage(contentsOfFile: objData)
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
import UIKit
import SDWebImage

// collection view cell on main window
class CollageCollectionViewCell: UICollectionViewCell {
    
    var delegate: SenderCell?

    // set image view and add gesture to it
    public lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    public lazy var photoImageCount: UILabel = {
        let lblCount = UILabel(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        lblCount.translatesAutoresizingMaskIntoConstraints = false
        lblCount.isUserInteractionEnabled = true
//        lblCountimageView.clipsToBounds = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return lblCount
    }()
    
    // handler tap to zoom
//    @objc private func handleZoomTap(tapGesture: UITapGestureRecognizer) {
//        guard let imageView = tapGesture.view as? UIImageView else { return }
////        delegate?.performZoomForImageView(imageView)
//    }
    
    // layout collectionViewCell subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(photoImageCount)
        photoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        photoImageCount.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        photoImageCount.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       
//        photoImageCount.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        photoImageCount.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
//    func updateCollectionViewCell(image:[UIImage]) {
//        // SDWebImage library func, for retrieve photos
////        photoImageView.sd_setImage(with: image.description, completed: nil)
//        photoImageView.image = image[0]
//    }
    // update collectionViewCell with new data
//    func updateCollectionViewCell(withUrl url: URL) {
//        // SDWebImage library func, for retrieve photos
//        photoImageView.sd_setImage(with: url, completed: nil)
//    }
    
}

// determine used device
public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4", "iPhone6,1", "iPhone6,2", "iPhone8,4":
            return "iPhone 5"
            
        case "iPhone7,2", "iPhone8,1", "iPhone9,1", "iPhone9,3", "iPhone10,1", "iPhone10,4":
            return "iPhone 6,7,8"
            
        case "iPhone7,1", "iPhone8,2", "iPhone9,2", "iPhone9,4", "iPhone10,2", "iPhone10,5":
            return "iPhone Plus"
            
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
            
        default:
            return identifier
        }
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
