//
//  CollectionImageCell.swift
//  AdForest
//
//  Created by apple on 4/26/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

protocol imagesCount {
    func imgeCount(count:Int)
}
protocol ImageDeletedBooleanDelegate {
    func boolImageDeleted(imageDeleted:Bool)
}
protocol ImagesArrayDeletedDelegate {
    func adPotDeletedImagesArr(imgArray:[AdPostImageArray],imagesDeleted:Bool)
}
protocol remaningUploadImagesCount{
    func adpostUploadImagesRemaning(count:Int,message:String)
}
class CollectionImageCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Properties
    var isDrag : Bool = false
    var UiImagesArr = [UIImage]()
    var imageIdArrAd = [Int]()


    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    @IBOutlet weak var viewDragImage: UIView!
    @IBOutlet weak var lblArrangeImage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            if #available(iOS 11.0, *) {
                collectionView.dragInteractionEnabled = true
                collectionView.dragDelegate = self
                collectionView.dropDelegate = self
                collectionView.reorderingCadence = .immediate //default value - .immediate

            } else {
                // Fallback on earlier versions
            }
            collectionView.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    //MARK:- Properties
    var dataArray = [AdPostImageArray]()
    var imgDelteArr = [AdPostImageArray]()
    var imgDelete = false

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ad_id = 0
    var delegate:imagesCount?
    var delegate2:ImageDeletedBooleanDelegate?
    var delegate3:ImagesArrayDeletedDelegate?
    var delegateRemainingImages:remaningUploadImagesCount?
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }

    
    @available(iOS 11.0, *)
        private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
        {
            let items = coordinator.items
            if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
            {
                var dIndexPath = destinationIndexPath
                if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
                {
                    dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
                }
                
                collectionView.performBatchUpdates({
                    if collectionView === self.collectionView
                    {
                        
                        print(sourceIndexPath.row)
                        print(dIndexPath.row)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [dIndexPath])
                        self.dataArray.remove(at: sourceIndexPath.row)
                        self.dataArray.insert(item.dragItem.localObject as! AdPostImageArray, at: dIndexPath.row)
                        for data in dataArray{
                        let url = URL(string:data.thumb)
                        if let data = try? Data(contentsOf: url!)
                        {
                        let image: UIImage = UIImage(data: data)!
                        UiImagesArr.append(image)
                        }
                        }
                        print(UiImagesArr)

                    }

                   


                })
                
                coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
            
    }
    }
    @available(iOS 11.0, *)
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
      {
          collectionView.performBatchUpdates({
              var indexPaths = [IndexPath]()
              for (index, item) in coordinator.items.enumerated()
              {
                  let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                  if collectionView === self.collectionView
                  {
                      self.dataArray.insert(item.dragItem.localObject as! AdPostImageArray, at: indexPath.row)
                  }
                  else
                  {
                      self.dataArray.insert(item.dragItem.localObject as! AdPostImageArray, at: indexPath.row)
                  }
                  indexPaths.append(indexPath)
              }
              collectionView.insertItems(at: indexPaths)
          })
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK:- Collection View Delegate Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
            
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        
        let objData = dataArray[indexPath.row]
        
        for id in dataArray {
            if let imgId = id.imgId {
                imageIdArrAd.append(imgId)
            }
        }
        
        print(imageIdArrAd)
        
        if let imgUrl = URL(string: objData.thumb) {
            loadImage(from: imgUrl) { image in
                if let image = image {
                    cell.imgPictures.image = image
                } else {
                    // Handle the case when image loading fails
                    cell.imgPictures.image = nil
                }
            }
        }
        
        cell.btnDelete = { [weak self] in
            let param: [String: Any] = ["ad_id": self?.ad_id, "img_id": objData.imgId]
            self?.removeItem(index: indexPath.row)
            self?.imgDelete = true
            self?.adForest_deleteImage(param: param as NSDictionary)
        }
        
        // self.rotateImageAppropriately(cell.imgPictures.image)
        
        return cell
    }


    
    
    
    func rotateImageAppropriately(_ imageToRotate: UIImage?) -> UIImage? {
        //This method will properly rotate our image, we need to make sure that
        //We call this method everywhere pretty much...
        
        let imageRef = imageToRotate?.cgImage
        var properlyRotatedImage: UIImage?
        
        //if imageOrientationWhenAddedToScreen == 0 {
            //Don't rotate the image
            properlyRotatedImage = imageToRotate
        //}
 //       else if imageOrientationWhenAddedToScreen == 3 {
//
//            //We need to rotate the image back to a 3
//           if let imageRef = imageRef, let orientation = UIImage.Orientation(rawValue: 3) {                properlyRotatedImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: orientation)          }
        
//    }
      //     else if imageOrientationWhenAddedToScreen == 1 {
//
//            //We need to rotate the image back to a 1
            if let imageRef = imageRef, let orientation = UIImage.Orientation(rawValue: 1) {
                properlyRotatedImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: orientation)
            }
       // }
        
        return properlyRotatedImage
        
    }
    
    //Remove item at selected Index
    func removeItem(index: Int) {
        dataArray.remove(at: index)
        self.collectionView.reloadData()
    }
    
    
    
    //MARK:- API Call
    func adForest_deleteImage(param: NSDictionary) {
        let mainClass = AdPostImagesController()
        mainClass.showLoader()
        AddsHandler.adPostDeleteImages(param: param, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                self.imgDelteArr = successResponse.data.adImages
                self.dataArray = successResponse.data.adImages
                self.imgDelete = true
               
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDelegate.presentController(ShowVC: alert)
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.adPostImageDelete), object: nil, userInfo: nil)
                self.delegate?.imgeCount(count: successResponse.data.adImages.count)
                self.delegate3?.adPotDeletedImagesArr(imgArray: self.dataArray, imagesDeleted: true)
                self.collectionView.reloadData()

                print(successResponse.data.adImages.count)
                let param: [String: Any] = ["is_update": ""]
                print(param)
                self.adForest_adPost(param: param as NSDictionary)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDelegate.presentController(ShowVC: alert)
            }
            
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.appDelegate.presentController(ShowVC: alert)
        }
    }
    //MARK:- API Calls
    func adForest_adPost(param: NSDictionary) {
        print(param)
        AddsHandler.adPost(parameter: param, success: { (successResponse) in
            if successResponse.success {
            debugPrint("nowMe\(successResponse)")
                self.delegateRemainingImages?.adpostUploadImagesRemaning(count: successResponse.data.images.numbers, message:successResponse.data.images.message)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDelegate.presentController(ShowVC: alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.appDelegate.presentController(ShowVC: alert)
        }
    }
}

class ImagesCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var imgPictures: UIImageView!
    @IBOutlet weak var containerViewCross: UIView!
    @IBOutlet weak var imgDelete: UIImageView!
    
    //MARK:- Properties
    
    var btnDelete: (()->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }
    
   
    //MARK:- IBActions
    @IBAction func actionDelete(_ sender: Any) {
        self.btnDelete?()
    }
}

extension UIImage {
    
    func updateImageOrientionUpSide() -> UIImage? {
        if self.imageOrientation == .left {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
}
extension CollectionImageCell: UICollectionViewDragDelegate{
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.dataArray[indexPath.row]
        let itemProvider = NSItemProvider(object: item.thumb as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        isDrag = true
        return [dragItem]
    }
}
extension CollectionImageCell: UICollectionViewDropDelegate{
    @available(iOS 11.0, *)
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?)
        -> UICollectionViewDropProposal {
            if collectionView.hasActiveDrag{
                return UICollectionViewDropProposal(operation: .move ,intent: .insertAtDestinationIndexPath)

            }
            return UICollectionViewDropProposal(operation: .forbidden)

    }
    
     @available(iOS 11.0, *)
     func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
         var destinationIndexpath = IndexPath()
         if let indexPath = coordinator.destinationIndexPath{
             destinationIndexpath = indexPath
         }
         else{
             let row = collectionView.numberOfItems(inSection: 0)
             destinationIndexpath = IndexPath(item: row - 1 , section: 0)
         }
         if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator:coordinator , destinationIndexPath: destinationIndexpath ,collectionView: collectionView)
                print(destinationIndexpath)

//            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexpath, collectionView: collectionView)
                       
//            self.collectionView.reloadData()

         }
     }
}
    
    

