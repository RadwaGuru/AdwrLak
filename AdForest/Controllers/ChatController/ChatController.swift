//
//  ChatController.swift
//  AdForest
//
//  Created by apple on 3/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import IQKeyboardManagerSwift
import JGProgressHUD
import NVActivityIndicatorView
import UIKit

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UITextViewDelegate,OpenChatControllerDelegate {
   
    
    // MARK: - Outlets

    @IBOutlet weak var containerAttachments: UIView!
    @IBOutlet var btnAttachment: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var oltName: UIButton! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltName.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }

    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDate: UILabel!

    @IBOutlet var btnBlock: UIButton!

    @IBOutlet var containerViewTop: UIView! {
        didSet {
            containerViewTop.addShadowToView()
        }
    }

    @IBOutlet var imgSent: UIImageView! {
        didSet {
            imgSent.tintImageColor(color: UIColor.white)
        }
    }

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.addSubview(refreshControl)

//            tableView.tableFooterView = UIView(frame: .zero)
//            self.tableView.sectionHeaderHeight = 0.0
//            self.tableView.sectionFooterHeight = 0.0
        }
    }

    @IBOutlet var heightConstraintTxtView: NSLayoutConstraint!
    @IBOutlet var heightContraintViewBottom: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var btnClose: UIButton!
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        UserDefaults.standard.set("3", forKey: "fromNotification")
        if homeStyles == "home1" {
            appDelegate.moveToHome()
        } else if homeStyles == "home2" {
            let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "MultiHomeViewController") as! MultiHomeViewController
            navigationController?.pushViewController(tabBarVC, animated: true)
        } else if homeStyles == "home3" {
            let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "SOTabBarViewController") as! SOTabBarViewController
            navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }

    @IBOutlet var containerViewSendMessage: UIView! {
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                containerViewSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }

    @IBOutlet var buttonSendMessage: UIButton! {
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                buttonSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }

    @IBOutlet var imgMessage: UIImageView!

    @IBOutlet var containerViewBottom: UIView! {
        didSet {
            containerViewBottom.layer.borderWidth = 0.5
            containerViewBottom.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    @IBOutlet var txtMessage: UITextView! {
        didSet {
            txtMessage.layer.borderWidth = 0.5
            txtMessage.layer.borderColor = UIColor.lightGray.cgColor
            txtMessage.delegate = self
        }
    }

    // MARK: - Properties
    var settingObject = [String: Any]()
    let keyboardManager = IQKeyboardManager.sharedManager()
    let defaults = UserDefaults.standard
    var ad_id = ""
    var sender_id = ""
    var receiver_id = ""
    var messageType = ""
    var isBlocked: String?
    var blockMessage = ""
    var btn_text = ""
    var currentPage = 0
    var maximumPage = 0
    let textViewMaxHeight: CGFloat = 100
    var textHeightConstraint: NSLayoutConstraint!

    var dataArray = [SentOfferChat]()
    var reverseArray = [SentOfferChat]()

    var userBlocked = false
    var adDetailStyle: String = UserDefaults.standard.string(forKey: "adDetailStyle")!
    var homeStyles: String = UserDefaults.standard.string(forKey: "homeStyles")!
    var imageUrlnew: URL?
    let documentInteractionController = UIDocumentInteractionController()

    // MARK: - Properties for msg attachemnts

    var txtImgDoc = true
    var txtImg = true
    var txtDoc = true
    var docOnly = true
    var imgOnly = true
    var txtOnly = true

    var attachmentAllow = false
    var attachmentType = ""
    var chatImageSize = ""
    var chatDocSize = ""
    var attachmentFormat : [String]!
    var headingPopUp = ""
    var imgLImitTxt = ""
    var docLimitTxt = ""
    var docTypeTxt = ""
    var fileNameLabel = ""
    var uploadImageHeading = ""
    var uploadDocumentHeading = ""

    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
            for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red

        return refreshControl
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        showBackButton()
        refreshButton()
//        self.tableView.rowHeight = UITableViewAutomaticDimension - 20
//        self.tableView.estimatedRowHeight = 10

//        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

        googleAnalytics(controllerName: "Chat Controller")
        documentInteractionController.delegate = self

        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        txtMessage.delegate = self
        if UserDefaults.standard.string(forKey: "fromNotification") == "1" {
            btnClose.isHidden = false
            topConstraint.constant += 10
            UserDefaults.standard.set("3", forKey: "fromNotification")

        } else {
            topConstraint.constant -= 30
            btnClose.isHidden = true
            UserDefaults.standard.set("3", forKey: "fromNotification")
        }

        textHeightConstraint = txtMessage.heightAnchor.constraint(equalToConstant: 40)
        textHeightConstraint.isActive = true
        adjustTextViewHeight()

        btnBlock.backgroundColor = UIColor(hex: defaults.string(forKey: "mainColor")!)
        btnBlock.roundCornors()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            oltName.semanticContentAttribute = .forceRightToLeft
        } else {
            oltName.semanticContentAttribute = .forceLeftToRight
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //                let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        //                print(parameter)
        //                self.adForest_getChatData(parameter: parameter as NSDictionary)
        //                self.showLoader()
        if messageType == "sent" {
            let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            showLoader()
            adForest_getChatData(parameter: parameter as NSDictionary)
        } else {
            let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            showLoader()
            adForest_getChatData(parameter: parameter as NSDictionary)
        }

        keyboardHandling()
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // if Constants.isIphoneX == true{
        NotificationCenter.default.removeObserver(self)
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = true
        // }else{
        // keyboardManager.enable = true
        // keyboardManager.enableAutoToolbar = true
        // }
    }

    //    func textViewDidChange(_ textView: UITextView) {
    //        let fixedWidth = textView.frame.size.width
    //        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        var newFrame = textView.frame
    //        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    //        textView.frame = newFrame
    //    }

    @IBAction func ActionOpenAttachment(_ sender: Any) {
//        let controller = MessagesAttachmentsViewController()

//        let sheetController = SheetViewController(controller: controller)
//        let sheetController = SheetViewController(
//            controller: controller,
//            sizes: [.halfScreen, .fixed(200), .halfScreen])
//
//
//        self.present(sheetController, animated: true, completion: nil)

//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "MessagesAttachmentsViewController") as! MessagesAttachmentsViewController
//
//        self.present(newViewController, animated: true, completion: nil)
        showMiracle()
    }

    @objc func showMiracle() {
        let slideVC = OverlayView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.adID = ad_id
        slideVC.senderID = sender_id
        slideVC.receiverID = receiver_id
        slideVC.msgType = messageType
        slideVC.delegate = self
        slideVC.chatAttachmentAllowed = attachmentAllow
        slideVC.chatAttachmentType = attachmentType
        slideVC.chatImageSize = chatImageSize
        slideVC.chatDocSize = chatDocSize
        slideVC.chatAttachmentFormat = attachmentFormat
        slideVC.headingPopUp = headingPopUp
        slideVC.imgLImitTxt = imgLImitTxt
        slideVC.docLimitTxt = docLimitTxt
        slideVC.docTypeTxt = docTypeTxt
        slideVC.uploadImageHeading = uploadImageHeading
        slideVC.uploadDocumentHeading = uploadDocumentHeading
        present(slideVC, animated: true, completion: nil)
    }
    func openChatFromAttachment() {
        refreshTableView()
    }
    func adjustTextViewHeight() {
        let fixedWidth = txtMessage.frame.size.width
        let newSize = txtMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        if newSize.height == 100 || newSize.height > 100 {
            heightConstraintTxtView.constant = 100
            heightContraintViewBottom.constant = 100
            txtMessage.isScrollEnabled = true
        } else {
            textHeightConstraint.constant = newSize.height
            heightConstraintTxtView.constant = newSize.height
            heightContraintViewBottom.constant = newSize.height
        }
        view.layoutIfNeeded()
    }

    func textViewDidChange(_ textView: UITextView) {
        adjustTextViewHeight()
        //        print(textView.contentSize.height)
        //        if textView.contentSize.height >= self.textViewMaxHeight
        //        {
        //            textView.isScrollEnabled = true
        //        }
        //        else
        //        {
        //
        //
        //            heightConstraintTxtView.constant = textView.contentSize.height
        //            heightContraintViewBottom.constant = textView.contentSize.height
        //                textView.isScrollEnabled = false
        //
        //        }
    }

    // MARK: - Custom

    func keyboardHandling() {
        // if Constants.isIphoneX == true  {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        keyboardManager.enable = false
        keyboardManager.enableAutoToolbar = false
        // }else{
        // keyboardManager.enable = true
        // keyboardManager.enableAutoToolbar = true
        // }
    }

    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            tableView.contentInset.bottom = height
            tableView.scrollIndicatorInsets.bottom = height
            if dataArray.count > 0 {
                tableView.scrollToRow(at: IndexPath(row: dataArray.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomConstraint.constant = keyboardHeight
        }
    }

    func textViewDidBeginEditing(_ textField: UITextView) {
        // bottomConstraint.constant = 8
        // animateViewMoving(up: true, moveValue: 8)
    }

    func textViewDidEndEditing(_ textField: UITextView) {
        // animateViewMoving(up: false, moveValue: 8)
        bottomConstraint.constant = 0
        //        if self.dataArray.count > 0 {
        //            self.tableView.scrollToRow(at: IndexPath.init(row:  self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
        //        }
        txtMessage.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextView) -> Bool {
        bottomConstraint.constant = 0
        txtMessage.resignFirstResponder()
        return true
    }

    func showLoader() {
        startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue, messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }

    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArray.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    @objc func refreshTableView() {
        //                let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        //        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": receiver_id, "receiver_id": sender_id, "type": messageType, "message": ""]
        //
        //                print(parameter)
        //                self.adForest_getChatData(parameter: parameter as NSDictionary)
        //
        if messageType == "sent" {
            let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            showLoader()
            adForest_getChatData(parameter: parameter as NSDictionary)
        } else {
            let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            showLoader()
            adForest_getChatData(parameter: parameter as NSDictionary)
        }
    }

    func adForest_populateData() {
        if UserHandler.sharedInstance.objSentOfferChatData != nil {
            let objData = UserHandler.sharedInstance.objSentOfferChatData

            if let addtitle = objData?.adTitle {
                oltName.setTitle(addtitle, for: .normal)
                oltName.underline()
            }
            if let price = objData?.adPrice.price {
                lblPrice.text = price
            }
            if let date = objData?.adDate {
                lblDate.text = date
            }
        }
    }

    func refreshButton() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        } else {
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        button.addTarget(self, action: #selector(onClickRefreshButton), for: .touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }

    @objc func onClickRefreshButton() {
        if messageType == "sent" {
            let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            showLoader()
            adForest_getChatData(parameter: parameter as NSDictionary)
        } else {
            let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            showLoader()
            adForest_getChatData(parameter: parameter as NSDictionary)
        }
    }

    @IBAction func btnBlockClicked(_ sender: UIButton) {
        //        if isBlocked == "true"{
        //            let parameter : [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
        //            print(parameter)
        //            adForest_UnblockUserChat(parameters: parameter as NSDictionary)
        //        }else{
        //            let parameter : [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
        //            print(parameter)
        //            adForest_blockUserChat(parameters: parameter as NSDictionary)
        //        }
        if isBlocked == "true" {
            if messageType == "receive" {
                let parameter: [String: Any] = ["sender_id": receiver_id, "recv_id": sender_id]

                print(parameter)
                adForest_UnblockUserChat(parameters: parameter as NSDictionary)
            } else {
                let parameter: [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
                print(parameter)
                adForest_UnblockUserChat(parameters: parameter as NSDictionary)
            }
        } else {
            if messageType == "receive" {
                let parameter: [String: Any] = ["sender_id": receiver_id, "recv_id": sender_id]
                print(parameter)
                adForest_blockUserChat(parameters: parameter as NSDictionary)
            } else {
                let parameter: [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
                print(parameter)
                adForest_blockUserChat(parameters: parameter as NSDictionary)
            }
        }
    }

    // MARK: - Download Attachment Document Files

    func adforest_DownloadFiles(url: URL, to localUrl: URL, completion: @escaping () -> Void) {
        let urlString = "http://www.africau.edu/images/default/sample.pdf"
//        let fileUrl = URL(string: "http://www.africau.edu/images/default/sample.pdf")!

        let url = URL(string: urlString)
        let fileName = String(url!.lastPathComponent) as NSString
        // Create destination URL
        let documentsUrl: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        // Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: fileURL!)
        let task = session.downloadTask(with: request) { tempLocalUrl, response, error in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                DispatchQueue.main.async {
                    //                        self.perform(#selector(self.showSuccess), with: nil, afterDelay: 0.0)
                    //                        self.stopAnimating()
                    //
                    //                    }

                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        do {
                            // Show UIActivityViewController to save the downloaded file
                            let contents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                            for indexx in 0 ..< contents.count {
                                if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    self.present(activityViewController, animated: true, completion: nil)
                                }
                            }
                        } catch let err {
                            print("error: \(err)")
                        }
                    } catch let writeError {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }

    @objc func showSuccess() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Downloaded Successfully"
        hud.detailTextLabel.text = nil
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.position = .bottomCenter
        hud.show(in: view)
        hud.dismiss(afterDelay: 2.0)
    }

    // MARK: - Table View Delegate Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objData = dataArray[indexPath.row]
        if objData.type == "reply" {
            let cell: SenderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
//            cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)
            if userBlocked == true {
                cell.isHidden = true
            }
//            var txtImgDoc = true
//            var txtImg = true
//            var txtDoc = true
//            var docOnly = true
//            var imgOnly = true
//            var txtOnly = true

            // MARK: - CHAT Attachment Use Cases

            // For all 3 items
//            if txtImgDoc == true{
//                cell.imgPicture.isHidden = false
//                cell.txtMessage.isHidden = false
//                cell.imgProfile.isHidden = false
//                cell.containerViewImg.isHidden = false
//                cell.imgprofileUserAttachment.isHidden = true
//                cell.imgUserProfileDocs.isHidden = true
//                cell.collageView.isHidden = false
//                cell.containerViewDocsAttachments.isHidden = false
//
//            }
            //   For txtImg items

//            if txtImg == true {
//                cell.imgPicture.isHidden = false
//                cell.txtMessage.isHidden = false
//                cell.imgProfile.isHidden = false
//                cell.containerViewImg.isHidden = false
//                cell.collageView.isHidden = false
//                cell.containerViewDocsAttachments.isHidden = true
//                cell.imgprofileUserAttachment.isHidden = true
//                cell.imgUserProfileDocs.isHidden = true
//            }
            //   For txtDoc items

//            if txtDoc == true {
//                cell.imgPicture.isHidden = false
//                cell.txtMessage.isHidden = false
//                cell.imgProfile.isHidden = false
//                cell.containerViewImg.isHidden = true
//                cell.collageView.isHidden = true
//                cell.containerViewDocsAttachments.isHidden = false
//                cell.imgprofileUserAttachment.isHidden = true
//                cell.imgUserProfileDocs.isHidden = true
//                cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgPicture.bottomAnchor,constant: 4).isActive = true
//               cell.containerViewDocsAttachments.bottomAnchor.constraint(equalTo: cell.imgprofileUserAttachment.bottomAnchor,constant: 4).isActive = true
//
//            }
            // For Document Only

//            if docOnly == true {
//                cell.imgPicture.isHidden = true
//                cell.txtMessage.isHidden = true
//                cell.imgProfile.isHidden = false
//                cell.containerViewImg.isHidden = true
//                cell.collageView.isHidden = true
//                cell.containerViewDocsAttachments.isHidden = false
//                cell.imgprofileUserAttachment.isHidden = true
//                cell.imgUserProfileDocs.isHidden = true
//                cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgProfile.topAnchor, constant: 4).isActive = true
//
//                cell.containerViewDocsAttachments.bottomAnchor.constraint(equalTo: cell.imgProfile.bottomAnchor, constant: 12).isActive = true
//            }
            // for Image only
//            if imgOnly == true {
//                if objData.chatImages.isEmpty == false{
//                    cell.collageView.isHidden = false
//                    cell.containerViewImg.isHidden = false
//                    cell.imgprofileUserAttachment.isHidden = true
//                    cell.imgPicture.isHidden = true
//                    cell.txtMessage.isHidden = true
//                    cell.imgProfile.isHidden = false
//                    cell.imgprofileUserAttachment.isHidden = true
//                    cell.imgUserProfileDocs.isHidden = true
//                    cell.containerViewDocsAttachments.isHidden = true
//                    cell.containerViewImg.topAnchor.constraint(equalTo: cell.imgProfile.centerYAnchor).isActive = true
//
//                }
//                else{
//                    cell.collageView.isHidden = true
//                    cell.containerViewImg.isHidden = true
//                    cell.imgprofileUserAttachment.isHidden = true
//                    cell.imgPicture.isHidden = true
//                    cell.txtMessage.isHidden = true
//                    cell.imgProfile.isHidden = true
//                    cell.imgUserProfileDocs.isHidden = true
//                    cell.imgprofileUserAttachment.isHidden = true
//                    cell.containerViewDocsAttachments.isHidden = true
//
//                }
            ////                cell.txtMessage.isHidden = true
            ////                cell.containerViewDocsAttachments.addConstaintsToSuperview( leadingOffset: 44, topOffset: 12)
            ////                let constraints = [
            ////                    cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: self.view.topAnchor),
            ////                cell.containerViewDocsAttachments.leftAnchor.constraint(equalTo: cell.imgprofileUserAttachment.rightAnchor, constant: 40).isActive = true
//
            ////worlking one
            ////two kay liye attachment
            ////               cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.containerViewImg.bottomAnchor,constant: 4).isActive = true
            ////??
//                //working fo0r one attachemnt
            ////                    cell.containerViewDocsAttachments.bottomAnchor.constraint(equalTo: cell.imgprofileUserAttachment.bottomAnchor,constant: 4).isActive = true
            ////                    outerSquare.rightAnchor.constraint(equalTo: innerSquare.rightAnchor, constant: 40)
            ////                ]
//
            ////                NSLayoutConstraint.activate(constraints)
            ////                cell.translatesAutoresizingMaskIntoConstraints = false
            ////                elf.buttonGoogleLogin.translatesAutoresizingMaskIntoConstraints
            ////                cell.containerViewDocsAttachments.isHidden = true
            ////                cell.imgPicture.isHidden = true
            ////                cell.imgProfile.isHidden = true
            ////                cell.imgUserProfileDocs.isHidden = true
            ////                cell.containerViewImg.isHidden = true
            ////                cell.containerViewDocsAttachments.isHidden = true
//            }
           
//            if objData.hasImages == true && objData.hasFiles == true && objData.text != nil{
//                cell.imgPicture.isHidden = false
//                cell.txtMessage.isHidden = false
//                cell.imgProfile.isHidden = false
//                cell.containerViewImg.isHidden = false
//                cell.imgprofileUserAttachment.isHidden = true
//                cell.imgUserProfileDocs.isHidden = true
//                cell.collageView.isHidden = false
//                cell.containerViewDocsAttachments.isHidden = false
//                cell.containerViewDocsAttachments.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
//                cell.containerViewDocsAttachments.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
//                cell.containerViewImg.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
//                cell.containerViewImg.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
//            }
          
//            if objData.hasFiles == true && objData.text != nil && objData.hasImages == false {
//                cell.containerViewDocsAttachments.isHidden = false
//                cell.imgProfile.isHidden = false
//                cell.imgUserProfileDocs.isHidden = true
//                cell.btnDownloadDocsAction = { () in
//                    let fileUrls = objData.chatFiles
//                    for files in fileUrls!{
//                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
//                        self.storeAndShare(withURLString: files)
//
//                    }
//                }
//                cell.containerViewDocsAttachments.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
//                cell.containerViewDocsAttachments.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
////                cell.imgprofileUserAttachment.isHidden = false
//                cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgprofileUserAttachment.topAnchor).isActive = true
//
//                cell.containerViewDocsAttachments.bottomAnchor.constraint(equalTo: cell.imgprofileUserAttachment.bottomAnchor,constant: 8).isActive = true
//
////                cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgPicture.bottomAnchor,constant: 8).isActive = true
////                cell.containerViewDocsAttachments.bottomAnchor.constraint(equalTo: cell.imgProfile.bottomAnchor).isActive = true
//
//            }
//            else
//            cell.setup(indexPath.row + 1)
            if objData.hasImages == true && objData.hasFiles == true && objData.text != nil{
                cell.chatImgs = objData.chatImages
                cell.collageView.reload()
                cell.collageView.isHidden = false
                cell.containerViewImg.isHidden = false

                if let theFileName = objData.chatFiles{
                    for item in theFileName{
                        let fileUrl = URL(string: item)
                        let paths = fileUrl?.pathComponents
                        fileNameLabel = (paths?.last)!
                    }
                    cell.lblFileName.text =  fileNameLabel
                }
                cell.btnDownloadDocsAction = { () in
                    let fileUrls = objData.chatFiles
                    for files in fileUrls!{
                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                        self.storeAndShare(withURLString: files)

                    }
                }
                cell.imgPicture.isHidden = false
                cell.txtMessage.isHidden = false
                cell.imgProfile.isHidden = false
//                cell.containerViewImg.isHidden = false
                cell.imgprofileUserAttachment.isHidden = true
                cell.imgUserProfileDocs.isHidden = true
//                cell.collageView.isHidden = false
                cell.containerViewDocsAttachments.isHidden = false
                cell.containerViewDocsAttachments.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
                cell.containerViewDocsAttachments.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
                cell.containerViewImg.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
                cell.containerViewImg.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)

                cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.containerViewImg.bottomAnchor,constant: 8).isActive = true
            }
            else{
                cell.collageView.isHidden = true
                cell.containerViewImg.isHidden = true
                cell.containerViewDocsAttachments.isHidden = true
                cell.imgUserProfileDocs.isHidden = true
                cell.imgprofileUserAttachment.isHidden = true

            }
//            && !(objData.text.isEmpty) && objData.hasImages == false
//             if objData.hasFiles == true && !(objData.text.isEmpty) && objData.hasImages == false {
////                docOnly = false
//                if let theFileName = objData.chatFiles{
//                    for item in theFileName{
//                        let fileUrl = URL(string: item)
//                        let paths = fileUrl?.pathComponents
//                        fileNameLabel = (paths?.last)!
//                    }
//                    cell.lblFileName.text =  fileNameLabel
//                }
//                cell.btnDownloadDocsAction = { () in
//                    let fileUrls = objData.chatFiles
//                    for files in fileUrls!{
//                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
//                        self.storeAndShare(withURLString: files)
//
//                    }
//                }
//                cell.collageView.isHidden = true
//                cell.containerViewImg.isHidden = true
//                cell.imgPicture.isHidden = false
//                cell.txtMessage.isHidden = false
//                cell.imgProfile.isHidden = false
//                cell.imgUserProfileDocs.isHidden = true
//                cell.imgprofileUserAttachment.isHidden = true
//                cell.containerViewDocsAttachments.isHidden = false
//                cell.containerViewDocsAttachments.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
//                cell.containerViewDocsAttachments.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
//
////                cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgprofileUserAttachment.topAnchor,constant: 8).isActive = true
////                cell.containerViewDocsAttachments.bottomAnchor.constraint(equalTo: cell.imgprofileUserAttachment.bottomAnchor,constant: 12).isActive = true
//            }
            docOnly  = objData.hasFiles
            imgOnly = objData.hasImages
//            if docOnly == true  && objData.text != nil {
//                if objData.hasFiles == true{
//                    cell.containerViewDocsAttachments.isHidden = false
//                    //                cell.imgProfile.isHidden = true
//                    cell.imgProfile.isHidden = false
//                    cell.imgUserProfileDocs.isHidden = false
//                    cell.btnDownloadDocsAction = { () in
//                        let fileUrls = objData.chatFiles
//                        for files in fileUrls!{
//                            /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
//                            self.storeAndShare(withURLString: files)
//
//                        }
//                    }
//                    cell.containerViewDocsAttachments.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
//                    cell.containerViewDocsAttachments.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
//
////                    cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgPicture.bottomAnchor,constant: 8).isActive = true
////                    cell.containerViewDocsAttachments.bottomAnchor.constraint(equalTo: cell.imgprofileUserAttachment.bottomAnchor,constant: 5).isActive = true
//                    //                cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgProfile.centerYAnchor).isActive = true
//                }
//                else{
//                    cell.containerViewDocsAttachments.isHidden = true
//                    cell.imgProfile.isHidden = false
//                    cell.imgUserProfileDocs.isHidden = true
//                }
//            }
             
            if objData.hasImages == true  {
               cell.containerViewImg.isHidden = false
               cell.collageView.isHidden = false
               cell.imgUserProfileDocs.isHidden = true
                cell.imgProfile.isHidden = false
                cell.imgprofileUserAttachment.isHidden = false
               cell.containerViewDocsAttachments.isHidden = true
               

//                cell.imgProfile.isHidden = false
               cell.chatImgs = objData.chatImages
               cell.collageView.reload()
               cell.containerViewImg.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
               cell.containerViewImg.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
               cell.containerViewImg.topAnchor.constraint(equalTo: cell.imgPicture.bottomAnchor,constant: 8).isActive = true
           }
             if objData.hasImages == true && !(objData.text.isEmpty) && objData.hasFiles == false {
                cell.containerViewImg.isHidden = false
                cell.collageView.isHidden = false
                cell.imgUserProfileDocs.isHidden = true

                cell.imgProfile.isHidden = false
                cell.chatImgs = objData.chatImages
                cell.collageView.reload()
                cell.containerViewImg.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
                cell.containerViewImg.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
                cell.containerViewImg.topAnchor.constraint(equalTo: cell.imgPicture.bottomAnchor,constant: 8).isActive = true
            }
//            else{
//                cell.containerViewImg.isHidden = true
//                cell.collageView.isHidden = true
//            }
//            else if objData.hasImages == true && objData.hasFiles == false && objData.text.isEmpty {
//                cell.containerViewImg.isHidden = false
//                cell.collageView.isHidden = false
//                cell.imgProfile.isHidden = false
//                cell.imgprofileUserAttachment.isHidden = false
//
//                cell.chatImgs = objData.chatImages
//                cell.collageView.reload()
//                cell.containerViewImg.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
//                cell.containerViewImg.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
////                cell.containerViewImg.topAnchor.constraint(equalTo: cell.imgProfile.centerYAnchor).isActive = true
////                cell.containerViewImg.bottomAnchor.constraint(equalTo: cell.imgProfile.bottomAnchor
////                ).isActive = true
////                cell.containerViewImg.topAnchor.constraint(equalTo: cell.imgProfile.centerYAnchor).isActive = true
////                cell.containerViewImg.bottomAnchor.constraint(equalTo: cell.imgProfile.bottomAnchor).isActive = true
//            }else{
//                cell.containerViewImg.isHidden = true
//                cell.collageView.isHidden = true
////                cell.imgProfile.isHidden = false
//
//
//            }
            if objData.hasFiles == true{
                if let theFileName = objData.chatFiles{
                    for item in theFileName{
                        let fileUrl = URL(string: item)
                        let paths = fileUrl?.pathComponents
                        fileNameLabel = (paths?.last)!
                    }
                     cell.lblFileName.text =  fileNameLabel
                }
            }
            
            if objData.hasFiles == true{
                cell.imgProfile.isHidden = false
                cell.imgUserProfileDocs.isHidden = false
//                cell.imgprofileUserAttachment.isHidden = false
                cell.containerViewDocsAttachments.isHidden = false
                cell.btnDownloadDocsAction = { () in
                    let fileUrls = objData.chatFiles
                    for files in fileUrls!{
                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                        self.storeAndShare(withURLString: files)

                    }
                }
                cell.containerViewDocsAttachments.layer.borderColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1).cgColor
                cell.containerViewDocsAttachments.backgroundColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1)
//                    cell.containerViewDocsAttachments.topAnchor.constraint(equalTo: cell.imgProfile.bottomAnchor).isActive = true
//
               
            }
            else{
                cell.imgProfile.isHidden = true
                cell.containerViewDocsAttachments.isHidden = true
            }
            
            if let message = objData.text {
                    cell.txtMessage.text = message
                    if UserDefaults.standard.bool(forKey: "isRtl") {
                        if !objData.text.isEmpty {

                        let image = UIImage(named: "bubble_se")
                        cell.imgPicture.image = image!
                            .resizableImage(withCapInsets:
                                UIEdgeInsetsMake(17, 21, 17, 21),
                                resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell.imgPicture.image = cell.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                        cell.imgPicture.tintColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1) // (hex:"D4FB79")
                        cell.txtMessage.text = message
                        // let height = cell.heightConstraint.constant + 20
                        cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        cell.imgPicture.isHidden = false
                        cell.txtMessage.isHidden = false
                        cell.imgProfile.isHidden = false

                }else{

                    cell.imgPicture.isHidden = true
                    cell.txtMessage.isHidden = true
                    cell.imgProfile.isHidden = true

                }
               

                } else {
                    if !objData.text.isEmpty {
                        let image = UIImage(named: "bubble_sent")
                        cell.imgPicture.image = image!
                            .resizableImage(withCapInsets:
                                UIEdgeInsetsMake(17, 21, 17, 21),
                                resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell.imgPicture.image = cell.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                        cell.imgPicture.tintColor = UIColor(red: 216 / 255, green: 238 / 255, blue: 160 / 255, alpha: 1) // (hex:"D4FB79")
                        cell.txtMessage.text = message
                        // let height = cell.heightConstraint.constant + 20
                        cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        cell.imgPicture.isHidden = false
                        cell.txtMessage.isHidden = false
                        cell.imgProfile.isHidden = false
                    }else{
                        cell.imgPicture.isHidden = true
                        cell.txtMessage.isHidden = true
                        cell.imgProfile.isHidden = true

                    }
                    
                }
            }
            if let imgUrl = URL(string: objData.img) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            if let imgUrl = URL(string: objData.img) {
                cell.imgprofileUserAttachment.sd_setShowActivityIndicatorView(true)
                cell.imgprofileUserAttachment.sd_setIndicatorStyle(.gray)
                cell.imgprofileUserAttachment.sd_setImage(with: imgUrl, completed: nil)
            }
            // imgUserProfileDocs
            if let imgUrl = URL(string: objData.img) {
                cell.imgUserProfileDocs.sd_setShowActivityIndicatorView(true)
                cell.imgUserProfileDocs.sd_setIndicatorStyle(.gray)
                cell.imgUserProfileDocs.sd_setImage(with: imgUrl, completed: nil)
            }
            return cell
        } else {
            let cell: ReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
//            cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)
            if userBlocked == true {
                cell.isHidden = true
            }

            //            var txtImgDoc = true
            //            var txtImg = true
            //            var txtDoc = true
            //            var docOnly = true
            //            var imgOnly = true
            //            var txtOnly = true

            // MARK: - CHAT Attachment Use Cases

            // For all 3 items
//                        if txtImgDoc == true{
//                            cell.imgBackground.isHidden = false
//                            cell.txtMessage.isHidden = false
//                            cell.imgIcon.isHidden = false
//                            cell.containerReceiverAttachment.isHidden = false
//                            cell.imgProfileReceiverAttachment.isHidden = true
//                            cell.imgProfileDocumentReceiver.isHidden = true
//                            cell.collageViewReceiverImages.isHidden = false
//                            cell.containerDocumentReceiver.isHidden = false
//
//                        }
            //   For txtImg items

//                        if txtImg == true {
//                            cell.imgBackground.isHidden = false
//                            cell.txtMessage.isHidden = false
//                            cell.imgIcon.isHidden = false
//                            cell.containerReceiverAttachment.isHidden = false
//                            cell.collageViewReceiverImages.isHidden = false
//                            cell.containerDocumentReceiver.isHidden = true
//                            cell.imgProfileReceiverAttachment.isHidden = true
//                            cell.imgProfileDocumentReceiver.isHidden = true
//                        }
            //   For txtDoc items

//                        if txtDoc == true {
//                            cell.imgBackground.isHidden = false
//                            cell.txtMessage.isHidden = false
//                            cell.imgIcon.isHidden = false
//                            cell.containerReceiverAttachment.isHidden = true
//                            cell.collageViewReceiverImages.isHidden = true
//                            cell.containerDocumentReceiver.isHidden = false
//                            cell.imgProfileReceiverAttachment.isHidden = true
//                            cell.imgProfileDocumentReceiver.isHidden = true
//                            cell.containerDocumentReceiver.topAnchor.constraint(equalTo: cell.imgBackground.bottomAnchor,constant: 4).isActive = true
//                           cell.containerDocumentReceiver.bottomAnchor.constraint(equalTo: cell.imgProfileReceiverAttachment.bottomAnchor,constant: 4).isActive = true
//
//                        }
            // For Document Only

//            if objData.hasFiles == true {
//                cell.imgBackground.isHidden = true
//                cell.txtMessage.isHidden = true
//                cell.imgIcon.isHidden = false
//                cell.containerReceiverAttachment.isHidden = true
//                cell.collageViewReceiverImages.isHidden = true
//                cell.containerDocumentReceiver.isHidden = false
//                cell.imgProfileReceiverAttachment.isHidden = true
//                cell.imgProfileDocumentReceiver.isHidden = true
//                cell.containerDocumentReceiver.topAnchor.constraint(equalTo: cell.imgIcon.centerYAnchor).isActive = true
//            }
//             for Image only
//                        if imgOnly == true {
//                            if objData.chatImages.isEmpty == false{
//                                cell.collageViewReceiverImages.isHidden = false
//                                cell.containerReceiverAttachment.isHidden = false
//                                cell.imgProfileReceiverAttachment.isHidden = true
//                                cell.imgBackground.isHidden = true
//                                cell.txtMessage.isHidden = true
//                                cell.imgIcon.isHidden = false
//                                cell.imgProfileDocumentReceiver.isHidden = true
//                                cell.containerDocumentReceiver.isHidden = true
//
//                            }
//                            else{
//                                cell.collageViewReceiverImages.isHidden = true
//                                cell.containerReceiverAttachment.isHidden = true
//                                cell.imgProfileReceiverAttachment.isHidden = true
//                                cell.imgBackground.isHidden = true
//                                cell.txtMessage.isHidden = true
//                                cell.imgIcon.isHidden = true
//                                cell.imgProfileDocumentReceiver.isHidden = true
//                                cell.containerDocumentReceiver.isHidden = true
//
//                            }
//                        }
            if objData.hasFiles == true{
                if let theFileName = objData.chatFiles{
                    for item in theFileName{
                        let fileUrl = URL(string: item)
                        let paths = fileUrl?.pathComponents
                        fileNameLabel = (paths?.last)!
                    }

                     cell.lblFileName.text =  fileNameLabel
                }

            }

//            cell.lblFileName.text = "fileName.pdf"
            if objData.hasFiles == true{
                cell.imgIcon.isHidden = true
                cell.imgProfileDocumentReceiver.isHidden = false
                cell.imgProfileReceiverAttachment.isHidden = true
                cell.containerDocumentReceiver.isHidden = false
                cell.btnDownloadAttachmentReceiverAction = { () in
                    let fileUrls = objData.chatFiles
                    for files in fileUrls!{
                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                        self.storeAndShare(withURLString: files)

                    }
                }
//                cell.containerDocumentReceiver.topAnchor.constraint(equalTo: cell.imgProfileReceiverAttachment.topAnchor).isActive = true
            }
            else{
//                cell.imgIcon.isHidden = true
                cell.containerDocumentReceiver.isHidden = true
            }
            if objData.hasImages {
                cell.containerReceiverAttachment.isHidden = false
                cell.collageViewReceiverImages.isHidden = false
                cell.imgIcon.isHidden = true
                cell.imgProfileDocumentReceiver.isHidden = true
                cell.imgProfileReceiverAttachment.isHidden = false
                print(objData.chatImages)
                cell.chatImgs = objData.chatImages
                cell.collageViewReceiverImages.reload()
//                cell.collageViewReceiverImages.topAnchor.constraint(equalTo: cell.imgIcon.bottomAnchor,constant: -18).isActive = true
//                cell.containerReceiverAttachment.topAnchor.constraint(equalTo: cell.imgIcon.bottomAnchor,constant: -18).isActive = true
            }else{
                cell.imgIcon.isHidden = true
                cell.containerReceiverAttachment.isHidden = true
                cell.collageViewReceiverImages.isHidden = true
            }
            if UserDefaults.standard.bool(forKey: "isRtl") {
                if !objData.text.isEmpty {
                    if let message = objData.text {
                        let image = UIImage(named: "bubble_sent")
                        cell.imgBackground.image = image!
                            .resizableImage(withCapInsets:
                                UIEdgeInsetsMake(17, 21, 17, 21),
                                resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell.txtMessage.text = message
                        // let height = cell.heightConstraint.constant + 20
                        cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        cell.imgBackground.isHidden = false
                        cell.txtMessage.isHidden = false
                        cell.imgIcon.isHidden = false
                        cell.imgProfileDocumentReceiver.isHidden = true
                        cell.imgProfileReceiverAttachment.isHidden = true
                    }
                }
                else{
                    cell.imgBackground.isHidden = true
                    cell.txtMessage.isHidden = true
                    
                }
                
            } else {
                if !objData.text.isEmpty {
                    if let message = objData.text {
                        let image = UIImage(named: "bubble_se")
                        cell.imgBackground.image = image!
                            .resizableImage(withCapInsets:
                                UIEdgeInsetsMake(17, 21, 17, 21),
                                resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell.txtMessage.text = message
                        // let height = cell.heightConstraint.constant + 20
                        cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        cell.imgBackground.isHidden = false
                        cell.txtMessage.isHidden = false
                        cell.imgIcon.isHidden = false
                        cell.imgProfileDocumentReceiver.isHidden = true
                        cell.imgProfileReceiverAttachment.isHidden = true

                    }
                }
                else{
                    cell.imgBackground.isHidden = true
                    cell.txtMessage.isHidden = true
//                    cell.imgIcon.isHidden = true

                }
               
            }

            if let imgUrl = URL(string: objData.img) {
                cell.imgIcon.sd_setShowActivityIndicatorView(true)
                cell.imgIcon.sd_setIndicatorStyle(.gray)
                cell.imgIcon.sd_setImage(with: imgUrl, completed: nil)
            }
            if let imgUrl = URL(string: objData.img) {
                cell.imgProfileReceiverAttachment.sd_setShowActivityIndicatorView(true)
                cell.imgProfileReceiverAttachment.sd_setIndicatorStyle(.gray)
                cell.imgProfileReceiverAttachment.sd_setImage(with: imgUrl, completed: nil)
            }
            if let imgUrl = URL(string: objData.img) {
                cell.imgProfileDocumentReceiver.sd_setShowActivityIndicatorView(true)
                cell.imgProfileDocumentReceiver.sd_setIndicatorStyle(.gray)
                cell.imgProfileDocumentReceiver.sd_setImage(with: imgUrl, completed: nil)
            }
            return cell
        }
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataArray.count && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            print(param)
            showLoader()
            adForest_loadMoreChat(parameter: param as NSDictionary)
        }
    }

    // MARK: - IBActions

    @IBAction func actionSendMessage(_ sender: UIButton) {
        guard let messageField = txtMessage.text else {
            return
        }

        if messageField == "" {
        } else {
            if messageType == "sent" {
                let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": messageField]

                print(parameter)
                adForest_sendMessage(param: parameter as NSDictionary)
                showLoader()
            } else {
                let parameter: [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": messageField]
                print(parameter)
                adForest_sendMessage(param: parameter as NSDictionary)
                showLoader()
            }
        }
    }

    @IBAction func actionNotificationName(_ sender: UIButton) {
        if adDetailStyle == "style1" {
            let addDetailVc = storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
            addDetailVc.ad_id = Int(ad_id)!
            navigationController?.pushViewController(addDetailVc, animated: true)
        } else {
            let addDetailVC = storyboard?.instantiateViewController(withIdentifier: "MarvelAdDetailViewController") as! MarvelAdDetailViewController
            addDetailVC.ad_id = Int(ad_id)!
            navigationController?.pushViewController(addDetailVC, animated: true)
        }
    }

    // MARK: - API Call

    func adForest_getChatData(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { successResponse in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat
                print(successResponse.data.isBlock)
                self.isBlocked = String(successResponse.data.isBlock)
                print(self.isBlocked)
                self.btn_text = successResponse.data.btnText
                self.dataArray = self.reverseArray.reversed()
               

                self.attachmentAllow = successResponse.data.messageSettings.attachmentAllowed
                self.attachmentType = successResponse.data.messageSettings.attachmentType
                self.chatImageSize = successResponse.data.messageSettings.imageSize
                self.chatDocSize = successResponse.data.messageSettings.attachmentSize
                self.attachmentFormat = successResponse.data.messageSettings.attachmentformat
                self.headingPopUp = successResponse.data.messageSettings.headingPopUp
                self.imgLImitTxt = successResponse.data.messageSettings.imgLImitTxt
                self.docLimitTxt = successResponse.data.messageSettings.docLimitTxt
                self.docTypeTxt = successResponse.data.messageSettings.docTypeTxt
                self.uploadImageHeading = successResponse.data.messageSettings.uploadImageHeading
                self.uploadDocumentHeading = successResponse.data.messageSettings.uploadDocumentHeading
                if self.attachmentAllow == false{
                    self.containerAttachments.isHidden = true
                }
                else{
                    self.containerAttachments.isHidden = false
                }
                self.adForest_populateData()
                self.tableView.reloadData()
                self.scrollToBottom()
                self.tableView.setEmptyMessage("")
                self.btnBlock.setTitle(self.btn_text, for: .normal)
            } else {
                // let alert = Constants.showBasicAlert(message: successResponse.message)
                // self.presentVC(alert)
                self.tableView.reloadData()
                self.isBlocked = String(successResponse.data.isBlock)
                print(self.isBlocked)
                // self.tableView.backgroundView?.isHidden = true
                self.btn_text = successResponse.data.btnText
                self.btnBlock.setTitle(self.btn_text, for: .normal)
                self.tableView.setEmptyMessage(successResponse.message)
            }

        }) { error in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    // Load More Chat
    func adForest_loadMoreChat(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { successResponse in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(successResponse)
            if successResponse.success {
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat

                self.dataArray.append(contentsOf: self.reverseArray.reversed())
                self.tableView.reloadData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { error in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    // send message
    func adForest_sendMessage(param: NSDictionary) {
        UserHandler.sendMessage(parameter: param, success: { successResponse in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.txtMessage.text = ""
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat

                self.dataArray = self.reverseArray.reversed()
                self.tableView.reloadData()
                self.scrollToBottom()
                self.heightConstraintTxtView.constant = 40
                self.heightContraintViewBottom.constant = 40
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { error in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    func adForest_blockUserChat(parameters: NSDictionary) {
        showLoader()
        UserHandler.blockUserChat(parameter: parameters, success: { successResponse in
            self.stopAnimating()
            if successResponse.success {
                // let alert = Constants.showBasicAlert(message: successResponse.message)
                // self.presentVC(alert)

                var ok = ""

                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String: Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)

                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }

                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { _ in

                    //                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                    //                                         print(parameter)
                    //                        self.userBlocked = true
                    //                        self.adForest_getChatData(parameter: parameter as NSDictionary)

                    if self.messageType == "sent" {
                        let parameter: [String: Any] = ["ad_id": self.ad_id, "sender_id": self.receiver_id, "receiver_id": self.sender_id, "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = true

                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    } else {
                        let parameter: [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = true

                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    }
                }
                al.addAction(btnOk)
                self.presentVC(al)

                // self.btnBlock.setTitle("UnBlock", for: .normal)
                self.isBlocked = "true"

            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { error in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    func adForest_UnblockUserChat(parameters: NSDictionary) {
        showLoader()
        UserHandler.UnblockUserChat(parameter: parameters, success: { successResponse in
            self.stopAnimating()
            if successResponse.success {
                // let alert = Constants.showBasicAlert(message: successResponse.message)
                // self.presentVC(alert)

                var ok = ""

                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String: Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)

                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }

                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { _ in

                    //                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                    //                    print(parameter)

                    if self.messageType == "sent" {
                        let parameter: [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = false

                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    } else {
                        let parameter: [String: Any] = ["ad_id": self.ad_id, "sender_id": self.receiver_id, "receiver_id": self.sender_id, "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = false

                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    }
                    //                    self.adForest_getChatData(parameter: parameter as NSDictionary)
                }
                al.addAction(btnOk)
                self.presentVC(al)

                // self.btnBlock.setTitle("Block", for: .normal)
                self.isBlocked = "false"

            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { error in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

import Alamofire
import CollageView
import NVActivityIndicatorView
import SDWebImage

protocol ChatImageDisplay {
    func goToNextController(chatImgs: [String])
}

class SenderCell: UITableViewCell, CollageViewDataSource, CollageViewDelegate, NVActivityIndicatorViewable {
    var chatImgs: [String] = []
    fileprivate var shownImagesCount = 4

    fileprivate var moreImagesCount: Int {
        return chatImgs.count - shownImagesCount
    }

    var layoutDirection: CollageViewLayoutDirection = .horizontal
    var layoutNumberOfColomn: Int = 2
    var delegate: ChatImageDisplay?

    @IBOutlet var collageView: CollageView! {
        didSet {
            collageView.delegate = self
            collageView.dataSource = self
            
        }
    }

    @IBOutlet var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!

    @IBOutlet var viewBg: UIView!
    let label = UILabel()
    var btnDownloadDocsAction: (() -> Void)?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet var attachmentContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet var btnDownloadDocs: UIButton!
    @IBOutlet var imgDownloadDocs: UIImageView!
    @IBOutlet var lblFileName: UILabel!
    @IBOutlet var containerViewDocsAttachments: UIView! {
        didSet {
            containerViewDocsAttachments.layer.borderWidth = 1
            containerViewDocsAttachments.layer.cornerRadius = 10
            containerViewDocsAttachments.backgroundColor = UIColor.white
            containerViewDocsAttachments.layer.borderColor = UIColor.white.cgColor
        }
    }

    @IBOutlet var imgUserProfileDocs: UIImageView! {
        didSet {
            imgUserProfileDocs.round()
        }
    }

    @IBOutlet var imgprofileUserAttachment: UIImageView! {
        didSet {
            imgprofileUserAttachment.round()
        }
    }

    @IBOutlet var imgPicture: UIImageView!
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var imgProfile: UIImageView! {
        didSet {
            imgProfile.round()
        }
    }

    @IBOutlet var containerViewImg: UIView! {
        didSet {
            containerViewImg.layer.borderWidth = 1
            containerViewImg.layer.cornerRadius = 10
            containerViewImg.backgroundColor = UIColor.white
            containerViewImg.layer.borderColor = UIColor.white.cgColor
        }
    }
//
//    @IBOutlet weak var heightConstraintMainContainerNew: NSLayoutConstraint!
//    @IBOutlet weak var mainContainer: UIView!{
//        didSet{
//            mainContainer.backgroundColor = UIColor.red
//            mainContainer.layer.borderWidth = 5
//            mainContainer.layer.borderColor = UIColor.systemYellow.cgColor
//        }
//    }
    var displayImagesCount = 4
//    var stackView = UIStackView()

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        imgPicture.clipsToBounds = true
        collageView.isHidden = true
        containerViewImg.isHidden = true
        containerViewDocsAttachments.isHidden = true
        imgUserProfileDocs.isHidden = true
        imgprofileUserAttachment.isHidden = true

//        configureStackView()
    }
//    func setup(_ numButtons: Int) -> Void {
//
//        // cells are reused, so remove any previously created buttons
//        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//
//        for i in 1...numButtons {
//            let b = UIButton(type: .system)
//            b.setTitle("Button \(i)", for: .normal)
//            b.backgroundColor = .blue
//            b.setTitleColor(.white, for: .normal)
//            stackView.addArrangedSubview(b)
//
//        }
//
//    }
//
//    func configureStackView(){
//        contentView.addSubview(stackView)
//        stackView.axis = .vertical
//        stackView.backgroundColor = UIColor.red
//        stackView.spacing = 20
//
//
//    }
    // MARK: Button Actions

    @IBAction func BtnDownloadDocsAction(_ sender: Any) {
        print("Download Docs")
        btnDownloadDocsAction?()
    }

    var ImagesCount: Int {
        return chatImgs.count - displayImagesCount
    }

    func collageView(_ collageView: CollageView, configure itemView: CollageItemView, at index: Int) {
        // MAGIC is in this code block
        // You can prepare your item here also,
        // You can fetch Images from Remote here!,
        // Customize UI for item, and etc..
        itemView.contentMode = .scaleAspectFill

        itemView.layer.borderWidth = 3
//        itemView.layer.cornerRadius = 3
        let array = chatImgs
        let isIndexValid = array.indices.contains(index)
        if isIndexValid {
//            collageView.isHidden = false
//            containerViewImg.isHidden = false

            if let url = NSURL(string: array[index]) {
                itemView.imageView.sd_setShowActivityIndicatorView(true)
                itemView.imageView.sd_setIndicatorStyle(.gray)
                itemView.imageView.sd_setImage(with: url as URL, completed: nil)
            }
        } else {
        }
//        if index == shownImagesCount - 1 {
//            addBlackViewAndLabel(to: itemView)
//        }
    }

    func collageViewNumberOfTotalItem(_ collageView: CollageView) -> Int {
        return shownImagesCount
    }

    func collageViewNumberOfRowOrColoumn(_ collageView: CollageView) -> Int {
        return layoutNumberOfColomn
    }

    func collageViewLayoutDirection(_ collageView: CollageView) -> CollageViewLayoutDirection {
        return layoutDirection
    }

    // Helpers
    private func addBlackViewAndLabel(to view: UIView) {
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.4
        view.addSubview(blackView)

        addConstraints(to: blackView, parentView: view)

        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "+\(moreImagesCount)"
        view.addSubview(label)

        addConstraints(to: label, parentView: view)
    }

    private func addConstraints(to view: UIView, parentView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let horConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,
                                               toItem: parentView, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal,
                                               toItem: parentView, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                               toItem: parentView, attribute: .width,
                                               multiplier: 1, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal,
                                               toItem: parentView, attribute: .height,
                                               multiplier: 1, constant: 0.0)

        parentView.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])
    }

    func collageView(_ collageView: CollageView, didSelect itemView: CollageItemView, at index: Int) {
        let message = "didSelect at index:  \(index), rowIndex: \(String(describing: itemView.collageItem!.rowIndex))"
        let categoryVC = storyboard.instantiateViewController(withIdentifier: "ViewAttachmentImageViewController") as! ViewAttachmentImageViewController
        print(chatImgs)
        categoryVC.imageAttachment = chatImgs
        UIApplication.shared.keyWindow?.rootViewController?.present(categoryVC, animated: true)
    }
}

import Alamofire
import CollageView
import NVActivityIndicatorView
import SDWebImage

class ReceiverCell: UITableViewCell, CollageViewDataSource, CollageViewDelegate {
    var chatImgs: [String] = []
    fileprivate let images = [#imageLiteral(resourceName: "usa"), #imageLiteral(resourceName: "chat-2"), #imageLiteral(resourceName: "twitter"), #imageLiteral(resourceName: "googleSocial"), #imageLiteral(resourceName: "heart")]
    // #imageLiteral(resourceName: "mirror"), #imageLiteral(resourceName: "amsterdam"), #imageLiteral(resourceName: "istanbul"), #imageLiteral(resourceName: "camera"), #imageLiteral(resourceName: "istanbul2"), #imageLiteral(resourceName: "mirror")];

    fileprivate var shownImagesCount = 4

    fileprivate var moreImagesCount: Int {
        return chatImgs.count - shownImagesCount
    }

    var layoutDirection: CollageViewLayoutDirection = .horizontal
    var layoutNumberOfColomn: Int = 2
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

//    fileprivate lazy var reOrderButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(title: "ReOrder", style: .plain, target: self, action: #selector(self.reOrderButtonTapped(sender: )))
//        return button
//    }()

    @IBOutlet var collageViewReceiverImages: CollageView! {
        didSet {
            collageViewReceiverImages.delegate = self
            collageViewReceiverImages.dataSource = self
//            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
//
//
//                collageViewReceiverImages.layer.borderWidth = 3
//                collageViewReceiverImages.layer.cornerRadius = 3
//                collageViewReceiverImages.layer.borderColor = Constants.hexStringToUIColor(hex: mainColor).cgColor
//            }
        }
    }

    @IBOutlet var lblFileName: UILabel!
    @IBOutlet var imgProfileDocumentReceiver: UIImageView! {
        didSet {
            imgProfileDocumentReceiver.round()
        }
    }

    @IBOutlet var BtnDocumentReceiverDownload: UIButton!
    @IBOutlet var containerDocumentReceiver: UIView! {
        didSet {
            containerDocumentReceiver.layer.borderWidth = 1
            containerDocumentReceiver.layer.cornerRadius = 10
            containerDocumentReceiver.backgroundColor = UIColor.white
            containerDocumentReceiver.layer.borderColor = UIColor.white.cgColor
        }
    }

    @IBOutlet var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!

    @IBOutlet var imgBackground: UIImageView!
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var viewBg: UIView!
    @IBOutlet var imgIcon: UIImageView! {
        didSet {
            imgIcon.round()
        }
    }

    @IBOutlet var imgProfileReceiverAttachment: UIImageView! {
        didSet {
            imgProfileReceiverAttachment.round()
        }
    }

//    @IBOutlet weak var btnOpenreceiverAttachment: UIButton!
//    @IBOutlet weak var imgReceiverAttachment: UIImageView!
    @IBOutlet var containerReceiverAttachment: UIView! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                containerReceiverAttachment.layer.borderWidth = 1
                containerReceiverAttachment.layer.cornerRadius = 10
                containerReceiverAttachment.layer.borderColor = UIColor.white.cgColor
                containerReceiverAttachment.backgroundColor = UIColor.white
                // Constants.hexStringToUIColor(hex: mainColor).cgColor
            }
        }
    }

//    var btnFullReceiver Action: (()->())?
    var btnDownloadAttachmentReceiverAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        // self.imgBackground.layer.cornerRadius = 15
        imgBackground.clipsToBounds = true
        containerDocumentReceiver.isHidden = true
        imgProfileDocumentReceiver.isHidden = true
        imgProfileReceiverAttachment.isHidden = true
        containerReceiverAttachment.isHidden = true
        collageViewReceiverImages.isHidden = true
    }

    // MARK: - @IBAction

    @IBAction func actionDocumentDownlaodReceiverCell(_ sender: Any) {
        btnDownloadAttachmentReceiverAction?()
    }

    func notifyUser(message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)

        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)

        alert.addAction(cancelAction)

        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }

    func collageView(_ collageView: CollageView, configure itemView: CollageItemView, at index: Int) {
        // MAGIC is in this code block
        // You can prepare your item here also,
        // You can fetch Images from Remote here!,
        // Customize UI for item, and etc..
        itemView.contentMode = .scaleToFill
        let array = chatImgs
        let isIndexValid = array.indices.contains(index)
        if isIndexValid {
            if let url = NSURL(string: array[index]) {
                itemView.imageView.sd_setShowActivityIndicatorView(true)
                itemView.imageView.sd_setIndicatorStyle(.gray)
                itemView.imageView.sd_setImage(with: url as URL, completed: nil)
            }
        } else {
            
        }
        itemView.layer.borderWidth = 3

//        if index == shownImagesCount - 1 {
//            addBlackViewAndLabel(to: itemView)
//        }
    }

    func collageViewNumberOfTotalItem(_ collageView: CollageView) -> Int {
        return shownImagesCount
    }

    func collageViewNumberOfRowOrColoumn(_ collageView: CollageView) -> Int {
        return layoutNumberOfColomn
    }

    func collageViewLayoutDirection(_ collageView: CollageView) -> CollageViewLayoutDirection {
        return layoutDirection
    }

    // Helpers
    private func addBlackViewAndLabel(to view: UIView) {
        let blackView = UIView()
        blackView.backgroundColor = .black
        blackView.alpha = 0.4
        view.addSubview(blackView)

        addConstraints(to: blackView, parentView: view)

        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "+\(moreImagesCount)"
        view.addSubview(label)

        addConstraints(to: label, parentView: view)
    }

    private func addConstraints(to view: UIView, parentView: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        let horConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal,
                                               toItem: parentView, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal,
                                               toItem: parentView, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                               toItem: parentView, attribute: .width,
                                               multiplier: 1, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal,
                                               toItem: parentView, attribute: .height,
                                               multiplier: 1, constant: 0.0)

        parentView.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])
    }

    func collageView(_ collageView: CollageView, didSelect itemView: CollageItemView, at index: Int) {
        let message = "didSelect at index:  \(index), rowIndex: \(String(describing: itemView.collageItem!.rowIndex))"
//        print(itemView.image)
//        let HomeVC = storyboard.instantiateViewController(withIdentifier: HomeController.className) as! HomeController

        let categoryVC = storyboard.instantiateViewController(withIdentifier: "ViewAttachmentImageViewController") as! ViewAttachmentImageViewController
//        print(chatImgs)
        categoryVC.imageAttachment = chatImgs

        // UIImage(contentsOfFile: chatImgs[index])
        // UIImage(chatImgs)
        // images
//        categoryVC
//        cell.dataArray = catLocationsArray
//
//        categoryVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(categoryVC, animated: true)

//        notifyUser(message: message)
    }
}

public extension UIColor {
    convenience init(hex: String) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex: String = hex

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = hex.substring(from: index)
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch hex.characters.count {
            case 3:
                red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                blue = CGFloat(hexValue & 0x00F) / 15.0
            case 4:
                red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                alpha = CGFloat(hexValue & 0x000F) / 15.0
            case 6:
                red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(hexValue & 0x0000FF) / 255.0
            case 8:
                red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(hexValue & 0x000000FF) / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension ChatController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension ChatController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
//        documentInteractionController.presentPreview(animated: true)
        documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
    }

    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
        }.resume()
    }
}

extension ChatController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = navigationController else {
            return self
        }
        return navVC
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }

    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return indices.contains(i) ? self[i] : nil
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) { // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }

    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) { // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIView {
    func addConstaintsToSuperview(leadingOffset: CGFloat, topOffset: CGFloat) {
        guard superview != nil else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false

        leadingAnchor.constraint(equalTo: superview!.leadingAnchor,
                                 constant: leadingOffset).isActive = true

        topAnchor.constraint(equalTo: superview!.topAnchor,
                             constant: topOffset).isActive = true
    }

    func addConstaints(height: CGFloat, width: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}
