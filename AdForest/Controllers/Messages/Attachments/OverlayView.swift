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

class OverlayView: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var btnImageAttach: (()->())?
    var btnDocuAttach: (()->())?
    var imageUrl:URL?
    var imagePicker = UIImagePickerController()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
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
        let imagePickerConroller = UIImagePickerController()
        imagePickerConroller.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePickerConroller.sourceType = .photoLibrary
            
        }else{
            let alert = UIAlertController(title:"objExtraTxt?.alertName", message: "message", preferredStyle: UIAlertController.Style.alert)
            let OkAction = UIAlertAction(title:" dataTabs.data.progressTxt.btnOk", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(OkAction)
            self.present(alert, animated: true, completion: nil)
        }
        self.present(imagePickerConroller,animated:true, completion:nil)
        //        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        //            imagePicker.delegate = self
        //            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //            self.appDel.presentController(ShowVC: imagePicker)
        //        }
        //        else {
        //
        //        }
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
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: options, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        //        self.btnDocuAttach?()
    }
    //MARK:- Delegates For UIDocumentPicker
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.saveFileToDocumentDirectory(document: url)
        print("Library document \(String(describing: url))")
        
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
        if let fileUrl = FileManager.default.saveFileToDocumentDirectory(fileUrl: document, name: "my_cv_upload", extention: ".pdf") {
            print(fileUrl)
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
        //        showLoader()
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                    
                    DispatchQueue.main.async {
                        self.perform(#selector(self.showSuccess), with: nil, afterDelay: 0.0)
                        //                        self.stopAnimating()
                        
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
