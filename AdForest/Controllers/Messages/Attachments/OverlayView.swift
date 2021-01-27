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
class OverlayView: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate,OpalImagePickerControllerDelegate,NVActivityIndicatorViewable {
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

    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    let mainColor = UserDefaults.standard.string(forKey: "mainColor")
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
    //    @IBOutlet weak var imageView: UIImageView!
    //    @IBOutlet weak var subscribeButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
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
        //        self.btnImageAttach?()
        print("ActionMediaAttachment")
        
        adForest_openGallery()
        //        let imagePickerConroller = UIImagePickerController()
        //        imagePickerConroller.delegate = self
        //        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        //            imagePickerConroller.sourceType = .photoLibrary
        //
        //        }else{
        //            let alert = UIAlertController(title:"objExtraTxt?.alertName", message: "message", preferredStyle: UIAlertController.Style.alert)
        //            let OkAction = UIAlertAction(title:" dataTabs.data.progressTxt.btnOk", style: UIAlertAction.Style.cancel, handler: nil)
        //            alert.addAction(OkAction)
        //            self.present(alert, animated: true, completion: nil)
        //        }
        //        self.present(imagePickerConroller,animated:true, completion:nil)
    }
    func adForest_openGallery() {
        //        let imagePickerConroller = UIImagePickerController()
        //        imagePickerConroller.delegate = self
        //        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
        //            imagePickerConroller.sourceType = .photoLibrary
        //            imagePickerConroller.modalPresentationStyle = .fullScreen
        //            imagePickerConroller.view.tintColor = .black
        //                //UIColor(hex:mainColor!)
        //
        //        }else{
        //            let alert = UIAlertController(title:"objExtraTxt?.alertName", message: "message", preferredStyle: UIAlertController.Style.alert)
        //            let OkAction = UIAlertAction(title:" dataTabs.data.progressTxt.btnOk", style: UIAlertAction.Style.cancel, handler: nil)
        //            alert.addAction(OkAction)
        //            self.present(alert, animated: true, completion: nil)
        //        }
        //        self.present(imagePickerConroller,animated:true, completion:nil)
        let imagePicker = OpalImagePickerController()
        imagePicker.navigationBar.tintColor = UIColor.white
        imagePicker.maximumSelectionsAllowed = 5
        //self.maximumImagesAllowed
        //         print(self.maximumImagesAllowed)
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
        // maximum message
        let configuration = OpalImagePickerConfiguration()
        configuration.maximumSelectionsAllowedMessage = NSLocalizedString("(objData?.data.images.message", comment: "")
        imagePicker.configuration = configuration
        imagePicker.imagePickerDelegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    //MARK:- Delegates For OPAL ImagePicker
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        print(images)
        if images.isEmpty {
        }
        else {
            self.photoArray = images
//            let param: [String: Any] = [ "ad_id": String(adID)]
            let parameter : [String: Any] = ["ad_id": adID, "sender_id": senderID, "receiver_id": receiverID, "type": msgType]
            print(parameter)
            self.adForest_uploadImages(param: parameter as NSDictionary, images: self.photoArray)
        }
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        self.dismissVC(completion: nil)
    }
    //MARK:- Delegates For UIImagePicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // To handle image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //            self.imagePickedBlock?(image)
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
//        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)

        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: options, in: .import)
        documentPicker.delegate = self
        documentPicker.view.tintColor = UIColor(hex:mainColor!)
        documentPicker.allowsMultipleSelection = true
        
        //.orange
        documentPicker.view.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
        documentPicker.modalPresentationStyle = .fullScreen
        //        self.present(documentPicker, animated: true, completion: nil)
        //        UINavigationBar.appearance().tintColor = .black
        present(documentPicker, animated: true) {
            UINavigationBar.appearance().tintColor = UIColor(hex:self.mainColor!)
            //.white
        }
        //        self.btnDocuAttach?()
    }
    
    
    //MARK:- Delegates For UIDocumentPicker
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: CIContext) {
            uiViewController.allowsMultipleSelection = true
        }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.saveFileToDocumentDirectory(document: url)
        print("Library document \(String(describing: url.standardizedFileURL))")
        
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let myURL = urls.first else {
//            return
//        }
        print("import result : \(urls)")

    }
          
    public func documentMenu(_ documentMenu:UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
//        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func saveFileToDocumentDirectory(document: URL) {
        print(document.pathExtension)
        if let fileUrl = FileManager.default.saveFileToDocumentDirectory(fileUrl: document, name: "my_cv_upload", extention: document.pathExtension) {
            print(fileUrl.pathExtension)
            
            //            let newURL = fileUrl
            //            if let fileURL = URL(string: newURL){
            //                    let fileUTI = UTI(withExtension: fileUrl.pathExtension)
            //                    switch fileUTI {
            //                    case .pdf:
            //                        print("add PDF Options")
            //                    case .jpeg:
            //                        print("add jpg Options")
            //                    case .png:
            //                        print("add png Options")
            //                    case .tiff:
            //                        print("add tiff Options")
            //                    case .gif:
            //                        print("add gif options")
            //                    case .spreadsheet:
            //                        print("add excel Options")
            //                    case .html:
            //                        print("add html options")
            //                    case .zipArchive:
            //                        print("add zip Options")
            //                        break
            //                    case .docx , .doc:
            //                        print("add dox options")
            //                    default:
            //                        print("default")
            //                    }
            
            //        }
            
            //            self.adforest_DownloadFiles(url: fileUrl as URL, to: fileUrl as URL){
            //                print("OK")
            //            }
            
            //self.uploadResume(documentUrl: fileUrl)
        }
    }
    
    //MARK:- DOwnload files
    func adforest_DownloadFiles(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .get)
        showLoader()
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                    
                    DispatchQueue.main.async {
                        self.perform(#selector(self.showSuccess), with: nil, afterDelay: 0.0)
                        self.stopAnimating()
                        
                    }
                }
                
            } else {
            }
        }
        task.resume()
    }
    
    @objc func showSuccess(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Downloaded Successfully"
        hud.detailTextLabel.text = nil
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.position = .bottomCenter
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.0)
    }
    
    
    //MARK:-End of Downlaod Task
    //MARK:- API Call
    
    //post images
    
    func adForest_uploadImages(param: NSDictionary, images: [UIImage]) {
        self.showLoader()
        uploadingProgressBar.progress = 0.0
        uploadingProgressBar.detailTextLabel.text = "0% Completed"
        uploadingProgressBar.show(in: view)
//
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            self.uploadingProgressBar.dismiss(animated: true)
            self.stopAnimating()
            if successResponse.success {
                self.stopAnimating()
                self.uploadingProgressBar.dismiss(animated: true)

//                self.imageArray = successResponse.data.adImages
//                self.imgCtrlCount = successResponse.data.adImages.count
                //add image id to array to send to next View Controller and hit to server
//                for item in self.imageArray {
//                    self.imageIDArray.append(item.imgId)
//                }
//                self.maximumImagesAllowed = successResponse.data.images.numbers
//                self.imagesMsg = successResponse.data.images.message
//
//                UserDefaults.standard.set( self.imagesMsg, forKey: "imgMsg")
//                self.tableView.reloadData()
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
        
        let url = Constants.URL.baseUrl+Constants.URL.messageAttachment
        print(url)
        NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            let currentProgress = Float(uploadProgress)/100
            self.uploadingProgressBar.detailTextLabel.text = "\(uploadProgress)% Completed"
            self.uploadingProgressBar.setProgress(currentProgress, animated: true)
        }, success: { (successResponse) in
//            let dictionary = successResponse as! [String: Any]
//            let objImg = AdPostImagesRoot(fromDictionary: dictionary)
//            success(objImg)
            
            self.stopAnimating()
            self.uploadingProgressBar.dismiss(animated: true)
            self.presentedViewController?.dismiss(animated: true, completion: nil)

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
class UTI: RawRepresentable, Equatable {
    
    /**
     The TagClass enum represents the supported tag classes.
     
     - fileExtension: kUTTagClassFilenameExtension
     - mimeType: kUTTagClassMIMEType
     - pbType: kUTTagClassNSPboardType
     - osType: kUTTagClassOSType
     */
    public enum TagClass: String {
        
        /// Equivalent to kUTTagClassFilenameExtension
        case fileExtension = "public.filename-extension"
        
        /// Equivalent to kUTTagClassMIMEType
        case mimeType = "public.mime-type"
        
        #if os (macOS)
        
        /// Equivalent to kUTTagClassNSPboardType
        case pbType =  "com.apple.nspboard-type"
        
        /// Equivalent to kUTTagClassOSType
        case osType =  "com.apple.ostype"
        #endif
        
        /// Convenience variable for internal use.
        
        fileprivate var rawCFValue: CFString {
            return self.rawValue as CFString
        }
    }
    
    public typealias RawValue = String
    public let rawValue: String
    
    
    /// Convenience variable for internal use.
    
    private var rawCFValue: CFString {
        
        return self.rawValue as CFString
    }
    
    // MARK: Initialization
    
    
    /**
     
     This is the designated initializer of the UTI class.
     
     - Parameters:
     - rawValue: A string that is a Universal Type Identifier, i.e. "com.foobar.baz" or a constant like kUTTypeMP3.
     - Returns:
     An UTI instance representing the specified rawValue.
     - Note:
     You should rarely use this method. The preferred way to initialize a known UTI is to use its static variable (i.e. UTI.pdf). You should make an extension to make your own types available as static variables.
     
     */
    
    public required init(rawValue: UTI.RawValue) {
        
        self.rawValue = rawValue
    }
    
    /**
     
     Initialize an UTI with a tag of a specified class.
     
     - Parameters:
     - tagClass: The class of the tag.
     - value: The value of the tag.
     - conformingTo: If specified, the returned UTI must conform to this UTI. If nil is specified, this parameter is ignored. The default is nil.
     - Returns:
     An UTI instance representing the specified rawValue. If no known UTI with the specified tags is found, a dynamic UTI is created.
     - Note:
     You should rarely need this method. It's usually simpler to use one of the specialized initialzers like
     ```convenience init?(withExtension fileExtension: String, conformingTo conforming: UTI? = nil)```
     */
    
    public convenience init(withTagClass tagClass: TagClass, value: String, conformingTo conforming: UTI? = nil) {
        
        let unmanagedIdentifier = UTTypeCreatePreferredIdentifierForTag(tagClass.rawCFValue, value as CFString, conforming?.rawCFValue)
        
        // UTTypeCreatePreferredIdentifierForTag only returns nil if the tag class is unknwown, which can't happen to us since we use an
        // enum of known values. Hence we can force-cast the result.
        
        let identifier = (unmanagedIdentifier?.takeRetainedValue() as String?)!
        
        self.init(rawValue: identifier)
    }
    
    /**
     
     Initialize an UTI with a file extension.
     
     - Parameters:
     - withExtension: The file extension (e.g. "txt").
     - conformingTo: If specified, the returned UTI must conform to this UTI. If nil is specified, this parameter is ignored. The default is nil.
     - Returns:
     An UTI corresponding to the specified values.
     **/
    
    public convenience init(withExtension fileExtension: String, conformingTo conforming: UTI? = nil) {
        
        self.init(withTagClass:.fileExtension, value: fileExtension, conformingTo: conforming)
    }
    
    /**
     
     Initialize an UTI with a MIME type.
     
     - Parameters:
     - mimeType: The MIME type (e.g. "text/plain").
     - conformingTo: If specified, the returned UTI must conform to this UTI. If nil is specified, this parameter is ignored. The default is nil.
     - Returns:
     An UTI corresponding to the specified values.
     */
    
    public convenience init(withMimeType mimeType: String, conformingTo conforming: UTI? = nil) {
        
        self.init(withTagClass:.mimeType, value: mimeType, conformingTo: conforming)
    }
    
    #if os(macOS)
    
    /**
     
     Initialize an UTI with a pasteboard type.
     - Important: **This function is de-facto deprecated!** The old cocoa pasteboard types ( `NSStringPboardType`, `NSPDFPboardType`, etc) have been deprecated in favour of actual UTIs, and the constants are not available anymore in Swift. This function only works correctly with the values of these old constants, but _not_ with the replacement values (like `NSPasteboardTypeString` etc), since these already are UTIs.
     - Parameters:
     - pbType: The pasteboard type (e.g. NSPDFPboardType).
     - conformingTo: If specified, the returned UTI must conform to this UTI. If nil is specified, this parameter is ignored. The default is nil.
     - Returns:
     An UTI corresponding to the specified values.
     */
    public convenience init(withPBType pbType: String, conformingTo conforming: UTI? = nil) {
        
        self.init(withTagClass:.pbType, value: pbType, conformingTo: conforming)
    }
    
    /**
     Initialize an UTI with a OSType.
     
     - Parameters:
     - osType: The OSType type as a string (e.g. "PDF ").
     - conformingTo: If specified, the returned UTI must conform to this UTI. If nil is specified, this parameter is ignored. The default is nil.
     - Returns:
     An UTI corresponding to the specified values.
     - Note:
     You can use the variable ```OSType.string``` to get a string from an actual OSType.
     */
    
    public convenience init(withOSType osType: String, conformingTo conforming: UTI? = nil) {
        
        self.init(withTagClass:.osType, value: osType, conformingTo: conforming)
    }
    
    #endif
    
    // MARK: Accessing Tags
    
    /**
     
     Returns the tag with the specified class.
     
     - Parameters:
     - tagClass: The tag class to return.
     - Returns:
     The requested tag, or nil if there is no tag of the specified class.
     */
    
    public func tag(with tagClass: TagClass) -> String? {
        
        let unmanagedTag = UTTypeCopyPreferredTagWithClass(self.rawCFValue, tagClass.rawCFValue)
        
        guard let tag = unmanagedTag?.takeRetainedValue() as String? else {
            return nil
        }
        
        return tag
    }
    
    /// Return the file extension that corresponds the the UTI. Returns nil if not available.
    
    public var fileExtension: String? {
        
        return self.tag(with: .fileExtension)
    }
    
    /// Return the MIME type that corresponds the the UTI. Returns nil if not available.
    
    public var mimeType: String? {
        
        return self.tag(with: .mimeType)
    }
    
    #if os(macOS)
    
    /// Return the pasteboard type that corresponds the the UTI. Returns nil if not available.
    
    public var pbType: String? {
        
        return self.tag(with: .pbType)
    }
    
    /// Return the OSType as a string that corresponds the the UTI. Returns nil if not available.
    /// - Note: you can use the ```init(with string: String)``` initializer to construct an actual OSType from the returnes string.
    
    public var osType: String? {
        
        return self.tag(with: .osType)
    }
    
    #endif
    
    /**
     
     Returns all tags of the specified tag class.
     
     - Parameters:
     - tagClass: The class of the requested tags.
     - Returns:
     An array of all tags of the receiver of the specified class.
     */
    
    public func tags(with tagClass: TagClass) -> Array<String> {
        
        let unmanagedTags = UTTypeCopyAllTagsWithClass(self.rawCFValue, tagClass.rawCFValue)
        
        guard let tags = unmanagedTags?.takeRetainedValue() as? Array<CFString> else {
            return []
        }
        
        return tags as Array<String>
    }
    
    // MARK: List all UTIs associated with a tag
    
    
    /**
     Returns all UTIs that are associated with a specified tag.
     
     - Parameters:
     - tag: The class of the specified tag.
     - value: The value of the tag.
     - conforming: If specified, the returned UTIs must conform to this UTI. If nil is specified, this parameter is ignored. The default is nil.
     - Returns:
     An array of all UTIs that satisfy the specified parameters.
     */
    
    public static func utis(for tag: TagClass, value: String, conformingTo conforming: UTI? = nil) -> Array<UTI> {
        
        let unmanagedIdentifiers = UTTypeCreateAllIdentifiersForTag(tag.rawCFValue, value as CFString, conforming?.rawCFValue)
        
        
        guard let identifiers = unmanagedIdentifiers?.takeRetainedValue() as? Array<CFString> else {
            return []
        }
        
        return identifiers.compactMap { UTI(rawValue: $0 as String) }
    }
    
    // MARK: Equality and Conformance to other UTIs
    
    /**
     
     Checks if the receiver conforms to a specified UTI.
     
     - Parameters:
     - otherUTI: The UTI to which the receiver is compared.
     - Returns:
     ```true``` if the receiver conforms to the specified UTI, ```false```otherwise.
     */
    
    public func conforms(to otherUTI: UTI) -> Bool {
        
        return UTTypeConformsTo(self.rawCFValue, otherUTI.rawCFValue) as Bool
    }
    
    public static func ==(lhs: UTI, rhs: UTI) -> Bool {
        
        return UTTypeEqual(lhs.rawCFValue, rhs.rawCFValue) as Bool
    }
    
    // MARK: Accessing Information about an UTI
    
    /// Returns the localized, user-readable type description string associated with a uniform type identifier.
    
    public var description: String? {
        
        let unmanagedDescription = UTTypeCopyDescription(self.rawCFValue)
        
        guard let description = unmanagedDescription?.takeRetainedValue() as String? else {
            return nil
        }
        
        return description
    }
    
    /// Returns a uniform type’s declaration as a Dictionary, or nil if if no declaration for that type can be found.
    
    public var declaration: [AnyHashable:Any]? {
        
        let unmanagedDeclaration = UTTypeCopyDeclaration(self.rawCFValue)
        
        guard let declaration = unmanagedDeclaration?.takeRetainedValue() as? [AnyHashable:Any] else {
            return nil
        }
        
        return declaration
    }
    
    /// Returns the location of a bundle containing the declaration for a type, or nil if the bundle could not be located.
    
    public var declaringBundleURL: URL? {
        
        let unmanagedURL = UTTypeCopyDeclaringBundleURL(self.rawCFValue)
        
        guard let url = unmanagedURL?.takeRetainedValue() as URL? else {
            return nil
        }
        
        return url
    }
    
    /// Returns ```true``` if the receiver is a dynamic UTI.
    
    public var isDynamic: Bool {
        
        return UTTypeIsDynamic(self.rawCFValue)
    }
}


// MARK: System defined UTIs

extension UTI {
    
    static       let  item                        =    UTI(rawValue:  kUTTypeItem                        as  String)
    static       let  content                     =    UTI(rawValue:  kUTTypeContent                     as  String)
    static       let  compositeContent            =    UTI(rawValue:  kUTTypeCompositeContent            as  String)
    static       let  message                     =    UTI(rawValue:  kUTTypeMessage                     as  String)
    static       let  contact                     =    UTI(rawValue:  kUTTypeContact                     as  String)
    static       let  archive                     =    UTI(rawValue:  kUTTypeArchive                     as  String)
    static       let  diskImage                   =    UTI(rawValue:  kUTTypeDiskImage                   as  String)
    static       let  data                        =    UTI(rawValue:  kUTTypeData                        as  String)
    static       let  directory                   =    UTI(rawValue:  kUTTypeDirectory                   as  String)
    static       let  resolvable                  =    UTI(rawValue:  kUTTypeResolvable                  as  String)
    static       let  symLink                     =    UTI(rawValue:  kUTTypeSymLink                     as  String)
    static       let  executable                  =    UTI(rawValue:  kUTTypeExecutable                  as  String)
    static       let  mountPoint                  =    UTI(rawValue:  kUTTypeMountPoint                  as  String)
    static       let  aliasFile                   =    UTI(rawValue:  kUTTypeAliasFile                   as  String)
    static       let  aliasRecord                 =    UTI(rawValue:  kUTTypeAliasRecord                 as  String)
    static       let  urlBookmarkData             =    UTI(rawValue:  kUTTypeURLBookmarkData             as  String)
    static       let  url                         =    UTI(rawValue:  kUTTypeURL                         as  String)
    static       let  fileURL                     =    UTI(rawValue:  kUTTypeFileURL                     as  String)
    static       let  text                        =    UTI(rawValue:  kUTTypeText                        as  String)
    static       let  plainText                   =    UTI(rawValue:  kUTTypePlainText                   as  String)
    static       let  utf8PlainText               =    UTI(rawValue:  kUTTypeUTF8PlainText               as  String)
    static       let  utf16ExternalPlainText      =    UTI(rawValue:  kUTTypeUTF16ExternalPlainText      as  String)
    static       let  utf16PlainText              =    UTI(rawValue:  kUTTypeUTF16PlainText              as  String)
    static       let  delimitedText               =    UTI(rawValue:  kUTTypeDelimitedText               as  String)
    static       let  commaSeparatedText          =    UTI(rawValue:  kUTTypeCommaSeparatedText          as  String)
    static       let  tabSeparatedText            =    UTI(rawValue:  kUTTypeTabSeparatedText            as  String)
    static       let  utf8TabSeparatedText        =    UTI(rawValue:  kUTTypeUTF8TabSeparatedText        as  String)
    static       let  rtf                         =    UTI(rawValue:  kUTTypeRTF                         as  String)
    static       let  html                        =    UTI(rawValue:  kUTTypeHTML                        as  String)
    static       let  xml                         =    UTI(rawValue:  kUTTypeXML                         as  String)
    static       let  sourceCode                  =    UTI(rawValue:  kUTTypeSourceCode                  as  String)
    static       let  assemblyLanguageSource      =    UTI(rawValue:  kUTTypeAssemblyLanguageSource      as  String)
    static       let  cSource                     =    UTI(rawValue:  kUTTypeCSource                     as  String)
    static       let  objectiveCSource            =    UTI(rawValue:  kUTTypeObjectiveCSource            as  String)
    @available( OSX 10.11, iOS 9.0, * )
    static       let  swiftSource                  =    UTI(rawValue:  kUTTypeSwiftSource                 as  String)
    static       let  cPlusPlusSource             =    UTI(rawValue:  kUTTypeCPlusPlusSource             as  String)
    static       let  objectiveCPlusPlusSource    =    UTI(rawValue:  kUTTypeObjectiveCPlusPlusSource    as  String)
    static       let  cHeader                     =    UTI(rawValue:  kUTTypeCHeader                     as  String)
    static       let  cPlusPlusHeader             =    UTI(rawValue:  kUTTypeCPlusPlusHeader             as  String)
    static       let  javaSource                  =    UTI(rawValue:  kUTTypeJavaSource                  as  String)
    static       let  script                      =    UTI(rawValue:  kUTTypeScript                      as  String)
    static       let  appleScript                 =    UTI(rawValue:  kUTTypeAppleScript                 as  String)
    static       let  osaScript                   =    UTI(rawValue:  kUTTypeOSAScript                   as  String)
    static       let  osaScriptBundle             =    UTI(rawValue:  kUTTypeOSAScriptBundle             as  String)
    static       let  javaScript                  =    UTI(rawValue:  kUTTypeJavaScript                  as  String)
    static       let  shellScript                 =    UTI(rawValue:  kUTTypeShellScript                 as  String)
    static       let  perlScript                  =    UTI(rawValue:  kUTTypePerlScript                  as  String)
    static       let  pythonScript                =    UTI(rawValue:  kUTTypePythonScript                as  String)
    static       let  rubyScript                  =    UTI(rawValue:  kUTTypeRubyScript                  as  String)
    static       let  phpScript                   =    UTI(rawValue:  kUTTypePHPScript                   as  String)
    static       let  json                        =    UTI(rawValue:  kUTTypeJSON                        as  String)
    static       let  propertyList                =    UTI(rawValue:  kUTTypePropertyList                as  String)
    static       let  xmlPropertyList             =    UTI(rawValue:  kUTTypeXMLPropertyList             as  String)
    static       let  binaryPropertyList          =    UTI(rawValue:  kUTTypeBinaryPropertyList          as  String)
    static       let  pdf                         =    UTI(rawValue:  kUTTypePDF                         as  String)
    static       let  rtfd                        =    UTI(rawValue:  kUTTypeRTFD                        as  String)
    static       let  flatRTFD                    =    UTI(rawValue:  kUTTypeFlatRTFD                    as  String)
    static       let  txnTextAndMultimediaData    =    UTI(rawValue:  kUTTypeTXNTextAndMultimediaData    as  String)
    static       let  webArchive                  =    UTI(rawValue:  kUTTypeWebArchive                  as  String)
    static       let  image                       =    UTI(rawValue:  kUTTypeImage                       as  String)
    static       let  jpeg                        =    UTI(rawValue:  kUTTypeJPEG                        as  String)
    static       let  jpeg2000                    =    UTI(rawValue:  kUTTypeJPEG2000                    as  String)
    static       let  tiff                        =    UTI(rawValue:  kUTTypeTIFF                        as  String)
    static       let  pict                        =    UTI(rawValue:  kUTTypePICT                        as  String)
    static       let  gif                         =    UTI(rawValue:  kUTTypeGIF                         as  String)
    static       let  png                         =    UTI(rawValue:  kUTTypePNG                         as  String)
    static       let  quickTimeImage              =    UTI(rawValue:  kUTTypeQuickTimeImage              as  String)
    static       let  appleICNS                   =    UTI(rawValue:  kUTTypeAppleICNS                   as  String)
    static       let  bmp                         =    UTI(rawValue:  kUTTypeBMP                         as  String)
    static       let  ico                         =    UTI(rawValue:  kUTTypeICO                         as  String)
    static       let  rawImage                    =    UTI(rawValue:  kUTTypeRawImage                    as  String)
    static       let  scalableVectorGraphics      =    UTI(rawValue:  kUTTypeScalableVectorGraphics      as  String)
    @available(OSX 10.12, iOS 9.1, watchOS 2.1, *)
    static       let  livePhoto                      =    UTI(rawValue:  kUTTypeLivePhoto                     as  String)
    @available(OSX 10.12, iOS 9.1, *)
    static       let  audiovisualContent          =    UTI(rawValue:  kUTTypeAudiovisualContent          as  String)
    static       let  movie                       =    UTI(rawValue:  kUTTypeMovie                       as  String)
    static       let  video                       =    UTI(rawValue:  kUTTypeVideo                       as  String)
    static       let  audio                       =    UTI(rawValue:  kUTTypeAudio                       as  String)
    static       let  quickTimeMovie              =    UTI(rawValue:  kUTTypeQuickTimeMovie              as  String)
    static       let  mpeg                        =    UTI(rawValue:  kUTTypeMPEG                        as  String)
    static       let  mpeg2Video                  =    UTI(rawValue:  kUTTypeMPEG2Video                  as  String)
    static       let  mpeg2TransportStream        =    UTI(rawValue:  kUTTypeMPEG2TransportStream        as  String)
    static       let  mp3                         =    UTI(rawValue:  kUTTypeMP3                         as  String)
    static       let  mpeg4                       =    UTI(rawValue:  kUTTypeMPEG4                       as  String)
    static       let  mpeg4Audio                  =    UTI(rawValue:  kUTTypeMPEG4Audio                  as  String)
    static       let  appleProtectedMPEG4Audio    =    UTI(rawValue:  kUTTypeAppleProtectedMPEG4Audio    as  String)
    static       let  appleProtectedMPEG4Video    =    UTI(rawValue:  kUTTypeAppleProtectedMPEG4Video    as  String)
    static       let  aviMovie                    =    UTI(rawValue:  kUTTypeAVIMovie                    as  String)
    static       let  audioInterchangeFileFormat  =    UTI(rawValue:  kUTTypeAudioInterchangeFileFormat  as  String)
    static       let  waveformAudio               =    UTI(rawValue:  kUTTypeWaveformAudio               as  String)
    static       let  midiAudio                   =    UTI(rawValue:  kUTTypeMIDIAudio                   as  String)
    static       let  playlist                    =    UTI(rawValue:  kUTTypePlaylist                    as  String)
    static       let  m3UPlaylist                 =    UTI(rawValue:  kUTTypeM3UPlaylist                 as  String)
    static       let  folder                      =    UTI(rawValue:  kUTTypeFolder                      as  String)
    static       let  volume                      =    UTI(rawValue:  kUTTypeVolume                      as  String)
    static       let  package                     =    UTI(rawValue:  kUTTypePackage                     as  String)
    static       let  bundle                      =    UTI(rawValue:  kUTTypeBundle                      as  String)
    static       let  pluginBundle                =    UTI(rawValue:  kUTTypePluginBundle                as  String)
    static       let  spotlightImporter           =    UTI(rawValue:  kUTTypeSpotlightImporter           as  String)
    static       let  quickLookGenerator          =    UTI(rawValue:  kUTTypeQuickLookGenerator          as  String)
    static       let  xpcService                  =    UTI(rawValue:  kUTTypeXPCService                  as  String)
    static       let  framework                   =    UTI(rawValue:  kUTTypeFramework                   as  String)
    static       let  application                 =    UTI(rawValue:  kUTTypeApplication                 as  String)
    static       let  applicationBundle           =    UTI(rawValue:  kUTTypeApplicationBundle           as  String)
    static       let  applicationFile             =    UTI(rawValue:  kUTTypeApplicationFile             as  String)
    static       let  unixExecutable              =    UTI(rawValue:  kUTTypeUnixExecutable              as  String)
    static       let  windowsExecutable           =    UTI(rawValue:  kUTTypeWindowsExecutable           as  String)
    static       let  javaClass                   =    UTI(rawValue:  kUTTypeJavaClass                   as  String)
    static       let  javaArchive                 =    UTI(rawValue:  kUTTypeJavaArchive                 as  String)
    static       let  systemPreferencesPane       =    UTI(rawValue:  kUTTypeSystemPreferencesPane       as  String)
    static       let  gnuZipArchive               =    UTI(rawValue:  kUTTypeGNUZipArchive               as  String)
    static       let  bzip2Archive                =    UTI(rawValue:  kUTTypeBzip2Archive                as  String)
    static       let  zipArchive                  =    UTI(rawValue:  kUTTypeZipArchive                  as  String)
    static       let  spreadsheet                 =    UTI(rawValue:  kUTTypeSpreadsheet                 as  String)
    static       let  presentation                =    UTI(rawValue:  kUTTypePresentation                as  String)
    static       let  database                    =    UTI(rawValue:  kUTTypeDatabase                    as  String)
    static       let  vCard                       =    UTI(rawValue:  kUTTypeVCard                       as  String)
    static       let  toDoItem                    =    UTI(rawValue:  kUTTypeToDoItem                    as  String)
    static       let  calendarEvent               =    UTI(rawValue:  kUTTypeCalendarEvent               as  String)
    static       let  emailMessage                =    UTI(rawValue:  kUTTypeEmailMessage                as  String)
    static       let  internetLocation            =    UTI(rawValue:  kUTTypeInternetLocation            as  String)
    static       let  inkText                     =    UTI(rawValue:  kUTTypeInkText                     as  String)
    static       let  font                        =    UTI(rawValue:  kUTTypeFont                        as  String)
    static       let  bookmark                    =    UTI(rawValue:  kUTTypeBookmark                    as  String)
    static       let  _3DContent                  =    UTI(rawValue:  kUTType3DContent                   as  String)
    static       let  pkcs12                      =    UTI(rawValue:  kUTTypePKCS12                      as  String)
    static       let  x509Certificate             =    UTI(rawValue:  kUTTypeX509Certificate             as  String)
    static       let  electronicPublication       =    UTI(rawValue:  kUTTypeElectronicPublication       as  String)
    static       let  log                         =    UTI(rawValue:  kUTTypeLog                         as  String)
    static       let  docx                        =    UTI(rawValue:  "org.openxmlformats.wordprocessingml.document")
    static       let  doc                         =    UTI(rawValue: "com.microsoft.word.doc")
}

#if os(OSX)

extension OSType {
    
    
    /// Returns the OSType encoded as a String.
    
    var string: String {
        
        let unmanagedString = UTCreateStringForOSType(self)
        
        return unmanagedString.takeRetainedValue() as String
    }
    
    
    /// Initializes a OSType from a String.
    ///
    /// - Parameter string: A String representing an OSType.
    
    init(with string: String) {
        
        self = UTGetOSTypeFromString(string as CFString)
    }
}
#endif