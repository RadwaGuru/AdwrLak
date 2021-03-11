//
//  OverlayView.swift
//  AdForest
//
//  Created by Apple on 12/01/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import JGProgressHUD
import OpalImagePicker
import Photos
import Alamofire
import JGProgressHUD
import NVActivityIndicatorView

protocol OpenWhizChatControllerDelegate {
    func openChatFromAttachment()
}
class WhizChatOverlayView: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate,OpalImagePickerControllerDelegate,NVActivityIndicatorViewable, CLLocationManagerDelegate {
    private lazy var uploadingProgressBar: JGProgressHUD = {
        let progressBar = JGProgressHUD(style: .dark)
        progressBar.indicatorView = JGProgressHUDRingIndicatorView()
        progressBar.textLabel.text = "Uploading"
        return progressBar
    }()
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var btnImageAttach: (()->())?
    var btnDocuAttach: (()->())?
    var imageUrl:URL?
    var imagePicker = UIImagePickerController()
    var photoArray = [UIImage]()
    var adID : String!
    var senderID : String!
    var receiverID : String!
    var msgType : String!
    var delegate : OpenWhizChatControllerDelegate?
    var chatAttachmentAllowed = false
    var chatAttachmentType = ""
    var chatImageSize = ""
    var chatDocSize = ""
    var chatAttachmentFormat : [String]!
    var headingPopUp = ""
    var imgLImitTxt = ""
    var docLimitTxt = ""
    var docTypeTxt = ""
    var imageSize: Int!
    var uploadImageTrueSize = false
    var fileSize = false
    var uploadImageHeading = ""
    var uploadDocumentHeading = ""
    var sizeFile = 0.0
    var uploadFileTrueSize = false
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let mainColor = UserDefaults.standard.string(forKey: "mainColor")
    let locationManager = CLLocationManager()
    var latitude : Double!
    var longitude : Double!
    
    
    var roomId = ""
    var senderId = ""
    var receiverId = ""
    var ChatId = ""
    var postId = ""
    var messageId = ""
    
    
    @IBOutlet weak var lblDocs: UILabel!
    @IBOutlet weak var lblImages: UILabel!
    @IBOutlet weak var btnImgDoc: UIButton!
    @IBOutlet weak var imgDoc: UIImageView!
    @IBOutlet weak var btnImgMedia: UIButton!
    @IBOutlet weak var imgMedia: UIImageView!
    @IBOutlet weak var containerAttachment: UIView!
    
    @IBOutlet weak var containerImg: UIView!
    
    @IBOutlet weak var containerMain: UIView!
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var containerLocation: UIView!
    @IBOutlet weak var lblLocationHeading: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    //    @IBOutlet weak var imageView: UIImageView!
    //    @IBOutlet weak var subscribeButton: UIView!
    
    @IBOutlet weak var lblHeading: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        lblHeading.text = headingPopUp
        adforest_getAttachmentData()
//        lblDocs.text = uploadDocumentHeading
//        lblImages.text = uploadImageHeading
        debugPrint("\(roomId): \(senderId): \(receiverId): \(ChatId): \(postId): \(messageId)")
        //        subscribeButton.roundCorners(.allCorners, radius: 10)
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    //MARK:- @IBActions
    @IBAction func ActionMediaAttachment(_ sender: Any) {
        adForest_openGallery()
    }
    @IBAction func btnLocationAction(_ sender: Any) {
        currentUserlocationManager()
    }
    
    func adforest_getAttachmentData(){
        if chatAttachmentType == "images" {
            containerAttachment.isHidden = true
            lblDocs.isHidden = true
            btnImgDoc.isHidden = true
            imgDoc.isHidden = true
        }
        else if chatAttachmentType == "attachments" {
            lblImages.isHidden = true
            btnImgMedia.isHidden = true
            imgMedia.isHidden = true
            containerAttachment.topAnchor.constraint(equalTo: lblHeading.bottomAnchor,constant: 8).isActive = true
        }
        else{
            print("saasassassa")
        }
    }
    
    
    func adForest_openGallery() {
        let imagePicker = OpalImagePickerController()
        imagePicker.navigationBar.tintColor = UIColor.white
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        imagePicker.imagePickerDelegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func currentUserlocationManager(){
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            self.latitude =  locationManager.location?.coordinate.latitude
            self.longitude =  locationManager.location?.coordinate.longitude
            if (self.latitude != nil) && self.longitude != nil{
              getAddressFromLatLon(pdblLatitude: String(self.latitude), withLongitude: String(self.longitude))
            }
        }
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                    
                    
                }
        })
        
    }
    
    
    
    
    
    //MARK:- Delegates For OPAL ImagePicker
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
//        for item in images{
//            var imgData: NSData = NSData(data: UIImageJPEGRepresentation((item), 1)!)
//            // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
//            imageSize  = imgData.count
//            print("size of image in KB: %f ", Double(imageSize) / 1000.0)
//            let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: Int64(imageSize), countStyle: .file)
//            print("File Size Device selected: \(fileSizeWithUnit)")
//            let fileSizeWithUnit2 = ByteCountFormatter.string(fromByteCount: Int64(self.chatImageSize)!, countStyle: .file)
//            print("File Size Api: \(fileSizeWithUnit2)")
//            print(self.chatImageSize)
//
//            if !(imageSize < Int(self.chatImageSize)! || imageSize == Int(chatImageSize)){
//                let alert = Constants.showBasicAlert(message: self.imgLImitTxt)
//                self.presentedViewController?.dismiss(animated: true, completion: nil)
//                self.presentVC(alert)
//                uploadImageTrueSize = false
//                break
//            }
//            else{
//                uploadImageTrueSize = true
//
//            }
//        }
//        if uploadImageTrueSize == true {
            if images.isEmpty {
            }
            else {
                self.photoArray = images
                let parameter : [String: Any] = [
                    "chat_id": ChatId,"msg":"","session":self.senderId,"post_id":postId,"comm_id":self.receiverId,"messages_ids":messageId,"message_type":"image","upload_type":"image"]
                //,"images":self.photoArray
                                print(parameter)

                self.adForest_uploadImages(param: parameter as NSDictionary, images: self.photoArray)
            }
//            self.delegate?.openChatFromAttachment()
            
            presentedViewController?.dismiss(animated: true, completion: nil)
//        }
        
        
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        self.dismissVC(completion: nil)
    }
    //MARK:- Delegates For UIImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // To handle image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            saveFileToDocumentDirectory(image: image)
        } else{
            print("Something went wrong in  image")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveFileToDocumentDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveFileToDocumentsDirectory(image: image, name: "profile_img", extention: ".png") {
            self.imageUrl = savedUrl
            print("Library Image \(String(describing: imageUrl))")
        }
    }
    
    func removeFileFromDocumentsDirectory(fileUrl: URL) {
        _ = FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
    }
    @IBAction func ActionAttachment(_ sender: Any) {
        print("ActionAttachment")
        let options = [kUTTypePDF as String, kUTTypeZipArchive  as String, kUTTypePNG as String, kUTTypeJPEG as String, kUTTypeText  as String, kUTTypePlainText as String]
        
        
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: options, in: .import)
        documentPicker.delegate = self
        documentPicker.view.tintColor = UIColor(hex:mainColor!)
        documentPicker.view.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
    
        documentPicker.modalPresentationStyle = .fullScreen
        present(documentPicker, animated: true) {
            UINavigationBar.appearance().tintColor = UIColor(hex:self.mainColor!)
        }
    }
    
    
    //MARK:- Delegates For UIDocumentPicker
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: CIContext) {
        uiViewController.allowsMultipleSelection = true
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.saveFileToDocumentDirectory(document: url)
        print("Library document \(String(describing: url.standardizedFileURL))")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func saveFileToDocumentDirectory(document: URL) {
        if let fileUrl = FileManager.default.saveFileToDocumentDirectory(fileUrl: document, name: "File", extention: document.pathExtension) {
//            if chatAttachmentFormat.contains(document.pathExtension){
//
//                fileSize = true
//            }else{
//                fileSize = false
//            }
//            if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: document.path) {
//                if let bytes = fileAttributes[.size] as? Int64 {
//
//
//                    let bcf = ByteCountFormatter()
//                    bcf.allowedUnits = [.useKB]
//                    bcf.countStyle = .file
//                    let string = bcf.string(fromByteCount: bytes)
//                    print(string)
//                }
//            }
//            do {
//                let attribute = try FileManager.default.attributesOfItem(atPath: document.path)
//                if let size = attribute[FileAttributeKey.size] as? NSNumber {
//                    sizeFile =  size.doubleValue / 1000000.0
//                    print(sizeFile)
//                    let fileSizeWithUnit = ByteCountFormatter.string(fromByteCount: Int64(sizeFile), countStyle: .decimal)
//                    print("File Size: \(fileSizeWithUnit)")
//                }
//            } catch {
//                print("Error: \(error)")
//            }
//            if  String(sizeFile) < chatDocSize || String(sizeFile) == chatDocSize {
//                uploadFileTrueSize = true
//            }
//            else{
//                uploadFileTrueSize = false
//            }
//
//            if fileSize == true && uploadFileTrueSize == true {
                let parameter : [String: Any] = [
                    "chat_id": ChatId,"msg":"","session":self.senderId,"post_id":postId,"comm_id":self.receiverId,"messages_ids":messageId,"message_type":"file","upload_type":"file"]
                                print(parameter)
                adForest_uploadFileDocs(param: parameter as NSDictionary, file: document)
                
//            }
//            else{
//                let alert = Constants.showBasicAlert(message: "\(docLimitTxt):\(docTypeTxt)")
//                self.presentVC(alert)
//            }
        }
    }
    
    //MARK:- API Call
    
    //MARK:- Post Images
    
    func adForest_uploadImages(param: NSDictionary, images: [UIImage]) {
        self.showLoader()
        uploadingProgressBar.progress = 0.0
        uploadingProgressBar.detailTextLabel.text = "0% Completed"
        uploadingProgressBar.show(in: view)
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in
            
        }, success: { (successResponse) in
            if successResponse.success {
                self.stopAnimating()
                self.uploadingProgressBar.dismiss(animated: true)
                
            }
            else {
                self.stopAnimating()
                self.uploadingProgressBar.dismiss(animated: true)
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            self.uploadingProgressBar.dismiss(animated: true)
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adPostUploadImages(parameter: NSDictionary , imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.SendmessagesWhizChatBox
        print(url)
        NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            let currentProgress = Float(uploadProgress)/100
            self.uploadingProgressBar.detailTextLabel.text = "\(uploadProgress)% Completed"
            self.uploadingProgressBar.setProgress(currentProgress, animated: true)
        }, success: { (successResponse) in
            self.stopAnimating()
            self.uploadingProgressBar.dismiss(animated: true)
            self.delegate?.openChatFromAttachment()
            self.dismiss(animated: true, completion: nil)
            print(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            print("false")
            
        }
    }
    
    //MARK:- Uplaod File
    
    func adForest_uploadFileDocs(param: NSDictionary, file: URL) {
        self.showLoader()
        uploadingProgressBar.progress = 0.0
        uploadingProgressBar.detailTextLabel.text = "0% Completed"
        uploadingProgressBar.show(in: view)
        msgUploadFiles(parameter: param, fileURL: file, fileName: "File", uploadProgress: { (uploadProgress) in
            
        }, success: { (successResponse) in
            self.uploadingProgressBar.dismiss(animated: true)
            self.stopAnimating()
            if successResponse.success {
                self.stopAnimating()
                self.uploadingProgressBar.dismiss(animated: true)
                
            }
            else {
                self.stopAnimating()
                self.uploadingProgressBar.dismiss(animated: true)
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            self.uploadingProgressBar.dismiss(animated: true)
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
    
    func msgUploadFiles(parameter: NSDictionary , fileURL: URL, fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.SendmessagesWhizChatBox
        print(url)
        NetworkHandler.upload(url: url, fileUrl: fileURL, fileName: fileName, params: parameter as! Parameters, uploadProgress: {(uploadProgress) in
            
            let currentProgress = Float(uploadProgress)/100
            self.uploadingProgressBar.detailTextLabel.text = "\(uploadProgress)% Completed"
            self.uploadingProgressBar.setProgress(currentProgress, animated: true)
            
            
        }, success: {(successResponse) in
            self.stopAnimating()
            
            self.uploadingProgressBar.dismiss(animated: true)
            self.delegate?.openChatFromAttachment()
            self.dismiss(animated: true, completion: nil)
            
            print("true")
            
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            print("false")
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    
    
}
