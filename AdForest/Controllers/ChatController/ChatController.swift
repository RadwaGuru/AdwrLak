//
//  ChatController.swift
//  AdForest
//
//  Created by apple on 3/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import JGProgressHUD

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UITextViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var oltName: UIButton!{
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltName.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnBlock: UIButton!
    
    @IBOutlet weak var containerViewTop: UIView! {
        didSet {
            containerViewTop.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgSent: UIImageView! {
        didSet {
            imgSent.tintImageColor(color: UIColor.white)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var heightConstraintTxtView: NSLayoutConstraint!
    @IBOutlet weak var heightContraintViewBottom: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        UserDefaults.standard.set("3", forKey: "fromNotification")
        if homeStyles == "home1"{
            appDelegate.moveToHome()
        }
        else if homeStyles == "home2"{
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "MultiHomeViewController") as! MultiHomeViewController
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
        else if homeStyles == "home3"{
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SOTabBarViewController") as! SOTabBarViewController
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
        
    }
    @IBOutlet weak var containerViewSendMessage: UIView! {
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                containerViewSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var buttonSendMessage: UIButton!{
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                buttonSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var imgMessage: UIImageView!
    
    @IBOutlet weak var containerViewBottom: UIView! {
        didSet {
            containerViewBottom.layer.borderWidth = 0.5
            containerViewBottom.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var txtMessage: UITextView!{
        didSet {
            txtMessage.layer.borderWidth = 0.5
            txtMessage.layer.borderColor = UIColor.lightGray.cgColor
            txtMessage.delegate = self
        }
    }
    
    
    
    //MARK:- Properties
    
    var settingObject = [String: Any]()
    let keyboardManager = IQKeyboardManager.sharedManager()
    let defaults = UserDefaults.standard
    var ad_id = ""
    var sender_id = ""
    var receiver_id = ""
    var messageType = ""
    var isBlocked :String?
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
    var imageUrlnew : URL?
    let documentInteractionController = UIDocumentInteractionController()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.showBackButton()
        self.refreshButton()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

        self.googleAnalytics(controllerName: "Chat Controller")
        documentInteractionController.delegate = self

        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        txtMessage.delegate = self
        if UserDefaults.standard.string(forKey: "fromNotification") == "1"{
            btnClose.isHidden = false
            topConstraint.constant += 10
            UserDefaults.standard.set("3", forKey: "fromNotification")

        }else{
            topConstraint.constant -= 30
            btnClose.isHidden = true
            UserDefaults.standard.set("3", forKey: "fromNotification")
        }
        
        self.textHeightConstraint = txtMessage.heightAnchor.constraint(equalToConstant: 40)
        self.textHeightConstraint.isActive = true
        self.adjustTextViewHeight()
        
        
        
        btnBlock.backgroundColor  = UIColor(hex: defaults.string(forKey: "mainColor")!)
        btnBlock.roundCornors()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            oltName.semanticContentAttribute = .forceRightToLeft
        }
        else{
            oltName.semanticContentAttribute = .forceLeftToRight

        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //                let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        //                print(parameter)
        //                self.adForest_getChatData(parameter: parameter as NSDictionary)
        //                self.showLoader()
        if messageType == "sent"{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        else{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id , "receiver_id": receiver_id , "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        
        
        keyboardHandling()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if Constants.isIphoneX == true{
        NotificationCenter.default.removeObserver(self)
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = true
        //}else{
        //keyboardManager.enable = true
        //keyboardManager.enableAutoToolbar = true
        //}
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
        slideVC.senderID  = sender_id
        slideVC.receiverID = receiver_id
        slideVC.msgType = messageType
        self.present(slideVC, animated: true, completion: nil)
    }

    func adjustTextViewHeight() {
        let fixedWidth = txtMessage.frame.size.width
        let newSize = txtMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height == 100 || newSize.height > 100{
            heightConstraintTxtView.constant = 100
            heightContraintViewBottom.constant = 100
            txtMessage.isScrollEnabled = true
        }else{
            self.textHeightConstraint.constant = newSize.height
            heightConstraintTxtView.constant = newSize.height
            heightContraintViewBottom.constant = newSize.height
        }
        self.view.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        
        self.adjustTextViewHeight()
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
    
    //MARK: - Custom
    
    func keyboardHandling(){
        
        //if Constants.isIphoneX == true  {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        keyboardManager.enable = false
        keyboardManager.enableAutoToolbar = false
        // }else{
        //keyboardManager.enable = true
        //keyboardManager.enableAutoToolbar = true
        //}
        
    }
    
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            if self.dataArray.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraint.constant = keyboardHeight
        }
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        //bottomConstraint.constant = 8
        // animateViewMoving(up: true, moveValue: 8)
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        // animateViewMoving(up: false, moveValue: 8)
        self.bottomConstraint.constant = 0
        //        if self.dataArray.count > 0 {
        //            self.tableView.scrollToRow(at: IndexPath.init(row:  self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
        //        }
        self.txtMessage.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextView) -> Bool {
        self.bottomConstraint.constant = 0
        self.txtMessage.resignFirstResponder()
        return true
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArray.count-1, section: 0)
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
        if messageType == "sent"{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        else{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id , "receiver_id": receiver_id , "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        
    }
    
    func adForest_populateData() {
        if UserHandler.sharedInstance.objSentOfferChatData != nil {
            let objData = UserHandler.sharedInstance.objSentOfferChatData
            
            if let addtitle = objData?.adTitle {
                self.oltName.setTitle(addtitle, for: .normal)
                oltName.underline()
            }
            if let price = objData?.adPrice.price {
                self.lblPrice.text = price
            }
            if let date = objData?.adDate {
                self.lblDate.text = date
            }
            
        }
    }
    
    func refreshButton() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        button.addTarget(self, action: #selector(onClickRefreshButton), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func onClickRefreshButton() {
        if messageType == "sent"{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        else{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id , "receiver_id": receiver_id , "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
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
            if messageType == "receive"{
                let parameter : [String: Any] = ["sender_id": receiver_id  , "recv_id": sender_id ]
                
                print(parameter)
                adForest_UnblockUserChat(parameters: parameter as NSDictionary)
                
            }
            else{
                
                let parameter : [String: Any] = ["sender_id": sender_id , "recv_id": receiver_id]
                print(parameter)
                adForest_UnblockUserChat(parameters: parameter as NSDictionary)
            }
            
        }
        else{
            if messageType == "receive"{
                let parameter : [String: Any] = ["sender_id": receiver_id  , "recv_id": sender_id ]
                print(parameter)
                adForest_blockUserChat(parameters: parameter as NSDictionary)
            }else{
                let parameter : [String: Any] = ["sender_id": sender_id , "recv_id": receiver_id]
                print(parameter)
                adForest_blockUserChat(parameters: parameter as NSDictionary)
            }
            
        }
        
    }
    //MARK:- Download Attachment Document Files
    func adforest_DownloadFiles(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let urlString = "http://www.africau.edu/images/default/sample.pdf"
//        let fileUrl = URL(string: "http://www.africau.edu/images/default/sample.pdf")!

        let url = URL(string: urlString)
        let fileName = String((url!.lastPathComponent)) as NSString
        // Create destination URL
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url:fileURL!)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
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
                            //Show UIActivityViewController to save the downloaded file
                            let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                            for indexx in 0..<contents.count {
                                if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                    let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    self.present(activityViewController, animated: true, completion: nil)
                                }
                            }
                        }
                        catch (let err) {
                            print("error: \(err)")
                        }
                    } catch (let writeError) {
                        print("Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                    
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()

//        let sessionConfig = URLSessionConfiguration.default
//        let session = URLSession(configuration: sessionConfig)
//        let request = try! URLRequest(url: url, method: .get)
//        showLoader()
//        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
//            if let tempLocalUrl = tempLocalUrl, error == nil {
//                // Success
//                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                    print("Success: \(statusCode)")
//
//                    DispatchQueue.main.async {
//                        self.perform(#selector(self.showSuccess), with: nil, afterDelay: 0.0)
//                        self.stopAnimating()
//
//                    }
//                }
//
//            } else {
//            }
//        }
//        task.resume()
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
    
    //MARK:- Table View Delegate Methods
    
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
            cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

            if userBlocked == true{
                cell.isHidden = true
            }
            
            if let message = objData.text {
                cell.txtMessage.text = message
//                cell.containerViewImg.isHidden = true
//                cell.imgprofileUserAttachment.isHidden = true
//                cell.containerViewDocsAttachments.isHidden  = true
//                cell.imgUserProfileDocs.isHidden = true
                //"https://picsum.photos/id/237/200/300"'
//                if objData.imgAttachment != nil{
//                    if let imgUrl = URL(string: objData.imgAttachment) {
//                        self.imageUrlnew = imgUrl
//                        cell.chatAttachmentImage.sd_setShowActivityIndicatorView(true)
//                        cell.chatAttachmentImage.sd_setIndicatorStyle(.gray)
//                        cell.chatAttachmentImage.sd_setImage(with: imgUrl, completed: nil)
//    //                    self.tableView.reloadData()
//
//
//                    }
//                }
//                print(objData.chatImages)
                cell.chatImgs = objData.chatImages
                cell.collageView.reload()
                cell.collectionView.reloadData()
//                cell.btnFullAction = { () in
////                    let imageView = sender.view as! UIImageView
//
//
//                        let newImageView = UIImageView(image: cell.chatAttachmentImage.image)
//                        newImageView.frame = UIScreen.main.bounds
//                        newImageView.backgroundColor = .black
//                        newImageView.contentMode = .scaleAspectFit
//                        newImageView.isUserInteractionEnabled = true
//                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
//                        newImageView.addGestureRecognizer(tap)
//                        self.view.addSubview(newImageView)
//                        self.navigationController?.isNavigationBarHidden = true
//                        self.tabBarController?.tabBar.isHidden = true
//
//                }
                let fileUrl = "https://www.w3.org/TR/PNG/iso_8859-1.txt"
                    //"http://www.africau.edu/images/default/sample.pdf"
//                let fileUrl = URL(string: "http://www.africau.edu/images/default/sample.pdf")!
                cell.lblFileName.text = "fileName.txt"
                cell.btnDownloadDocsAction =  {()in
                    /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                    self.storeAndShare(withURLString: fileUrl)
                    
//                    self.adforest_DownloadFiles(url: fileUrl as URL, to: fileUrl as URL){
//                        print("OK")
//                    }
                }
                if UserDefaults.standard.bool(forKey: "isRtl") {
                    let image = UIImage(named: "bubble_se")
                    cell.imgPicture.image = image!
                        .resizableImage(withCapInsets:
                                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.image = cell.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant

                }else{
                    let image = UIImage(named: "bubble_sent")
                    cell.imgPicture.image = image!
                        .resizableImage(withCapInsets:
                                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.image = cell.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                    cell.imgPicture.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
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
            //imgUserProfileDocs
            if let imgUrl = URL(string: objData.img) {
                cell.imgUserProfileDocs.sd_setShowActivityIndicatorView(true)
                cell.imgUserProfileDocs.sd_setIndicatorStyle(.gray)
                cell.imgUserProfileDocs.sd_setImage(with: imgUrl, completed: nil)
            }
            return cell
        }
        else {
            
            let cell: ReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)


            if userBlocked == true{
                cell.isHidden = true
            }
//            cell.containerReceiverAttachment.isHidden = true
//            cell.imgProfileReceiverAttachment.isHidden = true
//
            cell.lblFileName.text = "fileName.pdf"
            cell.chatImgs = objData.chatImages
            cell.btnDownloadAttachmentReceiverAction = { () in
                let fileUrl = "https://www.w3.org/TR/PNG/iso_8859-1.txt"
                    //"http://www.africau.edu/images/default/sample.pdf"
//                let fileUrl = URL(string: "http://www.africau.edu/images/default/sample.pdf")!
                    /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                    self.storeAndShare(withURLString: fileUrl)
                    
                
                
            }
//            if let imgUrl = URL(string: "https://homepages.cae.wisc.edu/~ece533/images/fruits.png") {
//                cell.imgReceiverAttachment.sd_setShowActivityIndicatorView(true)
//                cell.imgReceiverAttachment.sd_setIndicatorStyle(.gray)
//                cell.imgReceiverAttachment.sd_setImage(with: imgUrl, completed: nil)
////                    self.tableView.reloadData()
//
//            }
//            cell.btnFullReceiverAction = { () in
////                    let imageView = sender.view as! UIImageView
//
//
//                    let newImageView = UIImageView(image: cell.imgReceiverAttachment.image)
//                    newImageView.frame = UIScreen.main.bounds
//                    newImageView.backgroundColor = .black
//                    newImageView.contentMode = .scaleAspectFit
//                    newImageView.isUserInteractionEnabled = true
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
//                    newImageView.addGestureRecognizer(tap)
//                    self.view.addSubview(newImageView)
//                    self.navigationController?.isNavigationBarHidden = true
//                    self.tabBarController?.tabBar.isHidden = true
//            }
            if UserDefaults.standard.bool(forKey: "isRtl") {
                if let message = objData.text {
                    let image = UIImage(named: "bubble_sent")
                    cell.imgBackground.image = image!
                        .resizableImage(withCapInsets:
                                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                    
                }
            }else{
                if let message = objData.text {
                    let image = UIImage(named: "bubble_se")
                    cell.imgBackground.image = image!
                        .resizableImage(withCapInsets:
                                            UIEdgeInsetsMake(17, 21, 17, 21),
                                        resizingMode: .stretch)
                        .withRenderingMode(.alwaysTemplate)
                    cell.txtMessage.text = message
                    //let height = cell.heightConstraint.constant + 20
                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                    
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
    //MARK:-DismissFullscreenImage Action
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataArray.count && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            print(param)
            self.showLoader()
            self.adForest_loadMoreChat(parameter: param as NSDictionary)
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
        //        if isBlocked == "true"{
        //            print(blockMessage)
        //            let alert = Constants.showBasicAlert(message: blockMessage)
        //            self.presentVC(alert)
        //        }else{
        //            print("Not Blocked..")
        
        guard let messageField = txtMessage.text else {
            return
        }
//        if messageField == "" {
//
//        } else {
//            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": receiver_id, "receiver_id": sender_id, "type": messageType, "message": messageField]
//            print(parameter)
//            self.adForest_sendMessage(param: parameter as NSDictionary)
//            self.showLoader()
//        }
        
                if messageField == "" {
        
                } else {
                    if messageType == "sent"{
                        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": messageField]
        
                        print(parameter)
                        self.adForest_sendMessage(param: parameter as NSDictionary)
                        self.showLoader()
                    }
                    else{
                        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": messageField]
                        print(parameter)
                        self.adForest_sendMessage(param: parameter as NSDictionary)
                        self.showLoader()
                        }
        
                }
    }
    
    @IBAction func actionNotificationName(_ sender: UIButton) {
        if adDetailStyle == "style1"{
        let addDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
        addDetailVc.ad_id = Int(ad_id)!
        self.navigationController?.pushViewController(addDetailVc, animated: true)
            
        }
        else{
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MarvelAdDetailViewController") as! MarvelAdDetailViewController
            addDetailVC.ad_id = Int(ad_id)!
            self.navigationController?.pushViewController(addDetailVC, animated: true)
            
        }
        
    }
    
    //MARK:- API Call
    
    func adForest_getChatData(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { (successResponse) in
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
                self.adForest_populateData()
                self.tableView.reloadData()
                self.scrollToBottom()
                self.tableView.setEmptyMessage("")
                self.btnBlock.setTitle( self.btn_text, for: .normal)
                //                if isBlocked == "true"{
                //                          btnBlock.setTitle("UnBlock", for: .normal)
                //                      }else{
                //                           btnBlock.setTitle("Block", for: .normal)
                //                      }
            }
            else {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                self.tableView.reloadData()
                self.isBlocked = String(successResponse.data.isBlock)
                print(self.isBlocked)
                //self.tableView.backgroundView?.isHidden = true
                self.btn_text = successResponse.data.btnText
                self.btnBlock.setTitle( self.btn_text, for: .normal)
                self.tableView.setEmptyMessage(successResponse.message)
            }
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
            
        }
    }
    
    //Load More Chat
    func adForest_loadMoreChat(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { (successResponse) in
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
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //send message
    func adForest_sendMessage(param: NSDictionary) {
        UserHandler.sendMessage(parameter: param, success: { (successResponse) in
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
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adForest_blockUserChat(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.blockUserChat(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                // let alert = Constants.showBasicAlert(message: successResponse.message)
                // self.presentVC(alert)
                
                var ok = ""
                
                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)
                    
                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }
                
                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { (ok) in
                    
                    //                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                    //                                         print(parameter)
                    //                        self.userBlocked = true
                    //                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    
                    if self.messageType == "sent"{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.receiver_id , "receiver_id": self.sender_id , "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = true
                        
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                        
                    }
                    else{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = true
                        
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    }
                    
                }
                al.addAction(btnOk)
                self.presentVC(al)
                
                //self.btnBlock.setTitle("UnBlock", for: .normal)
                self.isBlocked = "true"
                
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
    func adForest_UnblockUserChat(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.UnblockUserChat(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                
                var ok = ""
                
                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)
                    
                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }
                
                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { (ok) in
                    
                    
                    
                    //                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                    //                    print(parameter)
                    
                    if self.messageType == "sent"{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id , "receiver_id": self.receiver_id , "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = false
                        
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                        
                    }
                    else{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.receiver_id, "receiver_id": self.sender_id, "type": self.messageType, "message": ""]
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
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

import CollageView
import NVActivityIndicatorView
import Alamofire
import SDWebImage

protocol ChatImageDisplay {
    func goToNextController(chatImgs: [String])
}
class SenderCell: UITableViewCell,CollageViewDataSource,CollageViewDelegate,NVActivityIndicatorViewable,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate{
   
    
    

    
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    var chatImgs : [String] = []
    fileprivate let images = [#imageLiteral(resourceName: "usa"), #imageLiteral(resourceName: "chat-2"), #imageLiteral(resourceName: "twitter"), #imageLiteral(resourceName: "googleSocial"),#imageLiteral(resourceName: "heart")]
                              //#imageLiteral(resourceName: "mirror"), #imageLiteral(resourceName: "amsterdam"), #imageLiteral(resourceName: "istanbul"), #imageLiteral(resourceName: "camera"), #imageLiteral(resourceName: "istanbul2"), #imageLiteral(resourceName: "mirror")];
    
    fileprivate var shownImagesCount = 4
    
    fileprivate var moreImagesCount: Int {
        get {
            return images.count - shownImagesCount
        }
    }
    var layoutDirection: CollageViewLayoutDirection = .horizontal
    var layoutNumberOfColomn: Int = 2
    var delegate : ChatImageDisplay?

//    fileprivate lazy var reOrderButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(title: "ReOrder", style: .plain, target: self, action: #selector(self.reOrderButtonTapped(sender: )))
//        return button
//    }()
    

    @IBOutlet weak var collageView: CollageView!{
        didSet{
            collageView.delegate    = self
            collageView.dataSource  = self
//            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
//
//
//                collageView.layer.borderWidth = 3
//                collageView.layer.cornerRadius = 5
//                collageView.layer.borderColor = UIColor.white.cgColor
//                    //Constants.hexStringToUIColor(hex: mainColor).cgColor
//            }

        }
    }
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewBg: UIView!
    let label =  UILabel()
//    var btnFullAction: (()->())?
    var btnDownloadDocsAction: (()->())?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet weak var btnDownloadDocs: UIButton!
    @IBOutlet weak var imgDownloadDocs: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var containerViewDocsAttachments: UIView!{
        didSet{
            

                containerViewDocsAttachments.layer.borderWidth = 1
                containerViewDocsAttachments.layer.cornerRadius = 10
                containerViewDocsAttachments.backgroundColor = UIColor.white
                containerViewDocsAttachments.layer.borderColor = UIColor.white.cgColor
            
        }
    }
    @IBOutlet weak var imgUserProfileDocs: UIImageView!{
        didSet{
            imgUserProfileDocs.round()

        }
    }
    @IBOutlet weak var imgprofileUserAttachment: UIImageView!{
        didSet {
            imgprofileUserAttachment.round()
        }
    }
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.round()
        }
    }
    @IBOutlet weak var containerViewImg: UIView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
            

            containerViewImg.layer.borderWidth = 1
            containerViewImg.layer.cornerRadius = 10
                containerViewImg.backgroundColor = UIColor.white
                containerViewImg.layer.borderColor = UIColor.white.cgColor
//                containerViewImg.addShadow()
                ///Constants.hexStringToUIColor(hex: mainColor).cgColor
            }
        }
    }
//    @IBOutlet weak var chatAttachmentImage: UIImageView!
//    @IBOutlet weak var btnOpenImage: UIButton!
    
//    override func loadView() {
//        super.loadView()
//        navigationItem.rightBarButtonItem = reOrderButton
//    }
    var Collimages =  [#imageLiteral(resourceName: "regfbicon"),#imageLiteral(resourceName: "chat_Selected"),#imageLiteral(resourceName: "chat-1"),#imageLiteral(resourceName: "home-1")]
     var displayImagesCount = 4

        //[UIImage]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        self.txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //self.imgPicture.layer.cornerRadius = 15
        self.imgPicture.clipsToBounds = true
//        collageView.isHidden = true
//
//        containerViewImg.isHidden = true
        collectionView.isHidden = true
        //imgPicture.backgroundColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)
//        getPhoto()
        //showIncomingMessage()
    }
    //MARK:-Actions
//    @IBAction func OpenImageAction(_ sender: Any) {
//        print("OpenImage")
//        self.btnFullAction?()
//    }
    
    @IBAction func BtnDownloadDocsAction(_ sender: Any) {
        print("Download Docs")
        self.btnDownloadDocsAction?()
    }
    // MARK: Button Actions
    
    @objc private func reOrderButtonTapped(sender: UIBarButtonItem) {
        
        sender.tag += 1
        if sender.tag%2 == 0 {
            layoutDirection = .horizontal
            layoutNumberOfColomn = 3
        } else {
            layoutDirection = .vertical
            layoutNumberOfColomn = 2
        }
        collageView.reload()
    }
    
    //
   
    
     var ImagesCount: Int {
        get {
            return chatImgs.count - displayImagesCount
        }
    }

    // MARK: - Table view data source
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(chatImgs.count)
        return chatImgs.count
    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }

    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let multiplier: CGFloat = UIDevice.current.modelName == "iPhone 5" ? 0.1 : 0.08
        //        let interSpacing = contentView.frame.width * multiplier
        //        let cellWidth = (contentView.frame.width - interSpacing * 2) / 3
        //        return .init(width: contentView.frame.width/2, height: cellWidth + 20)
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize/2, height: collectionViewSize/4)
//        let leftAndRightPaddings: CGFloat = 45.0
//                let numberOfItemsPerRow: CGFloat = 2.0
//
//                let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
//                return CGSize(width: width/2, height: width/2) // You can change width and height here as pr your requirement
    }

    // cell paddings
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
////        let leftRightPadding = contentView.frame.width * 0.05
////        return .init(top: 2, left: leftRightPadding, bottom: 2, right: leftRightPadding)
//        return UIEdgeInsetsMake(10, 0, 0, 10)
//
//    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    // reuse cell
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollageCollectionViewCell", for: indexPath) as! CollageCollectionViewCell
//        cell.updateCollectionViewCell(withUrl: photoStoreClass.storagePhoto[indexPath.row].urls.small)
//        cell.photoImageView.image = Collimages[indexPath.row]
        if let imgUrl = URL(string: chatImgs[indexPath.row]) {
            cell.photoImageView.sd_setShowActivityIndicatorView(true)
            cell.photoImageView.sd_setIndicatorStyle(.gray)
            cell.photoImageView.sd_setImage(with: imgUrl, completed: nil)
            
        }
        if indexPath.row == 3 {
//            if chatImgs.count
            if indexPath.row == shownImagesCount - 1 {
                cell.photoImageCount.text = "+\(ImagesCount)"

//                addBlackViewAndLabel(to: itemView)
            }

//            cell.photoImageCount.text = "4"
//            cell.photoImageCount.backgroundColor = UIColor.white
            cell.photoImageCount.textColor = UIColor.white
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = cell.photoImageView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.3
            cell.photoImageView.addSubview(blurEffectView)
//            cell.photoImageCount.font = cell.photoImageCount.font.withSize(20)
//
//            cell.photoImageCount.isHidden = false
        }
        else{
            cell.photoImageCount.isHidden = true
        }
//        cell.photoImageView.image = UIImage(contentsOfFile: chatImgs[indexPath.row])
//        cell.delegate = self
//        collectionView.reloadData()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryVC = storyboard.instantiateViewController(withIdentifier: "ViewAttachmentImageViewController") as! ViewAttachmentImageViewController
        print(chatImgs)
        categoryVC.imageAttachment = chatImgs

        UIApplication.shared.keyWindow?.rootViewController?.present(categoryVC, animated: true)
    
        
    }
    // pagination pages
//     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == photoStoreClass.storagePhoto.count - 1 {
//            receiveNewPage()
//        }
//    }
    
    
    //
    
    func notifyUser(message: String) -> Void {
        
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
        itemView.contentMode = .scaleAspectFit
//        if chatImgs.count != 0 {
//        let isIndexValid = chatImgs.indices.contains(index)
//                if isIndexValid {
//        if let imgUrl = URL(string:(chatImgs[index])) {
//            itemView.sd_setShowActivityIndicatorView(true)
//            itemView.sd_setIndicatorStyle(.gray)
//
//            do {
//                let url = URL(string: chatImgs[index])
//                print(url)
//                                //"https://verona-api.municipiumstaging.it/system/images/image/image/22/app_1920_1280_4.jpg")
//                let data = try Data(contentsOf: url!)
//                itemView.image = UIImage(data: data)
//            }
//
//            catch{
//                print(error)
//            }

//        if let boo = chatImgs[safe: index]{
//
//            do{
//                itemView.image = UIImage(contentsOfFile: boo)
//            }
//            catch{
//                print("asassa")
//
//            }
//
//        }
//        if let boo = chatImgs[safe: index]{
//            itemView.image = UIImage(contentsOfFile: boo)
//        }
//        else{
//            itemView.image = images[index]
//
//
//        }

//        if chatImgs[index].isEmpty {
//            print("empty\(index)")
//        }
//        else{
//            itemView.image = UIImage(contentsOfFile: chatImgs[index])
//        }
        //images[index]
        //UIImage(contentsOfFile: imgUrl.absoluteString)
                                        //chatImgs[index])
                
                            //images[index]

//            UIImageView(itemView.sd_setImage(with: imgUrl, completed: nil))
//                    self.tableView.reloadData()
            

//        }
//        if let imgUrl = URL(string:(chatImgs[index])) {
//            itemView.sd_setShowActivityIndicatorView(true)
//            itemView.sd_setIndicatorStyle(.gray)
//            itemView.image = UIImage(contentsOfFile:imgUrl)
////            itemView.sd_setImage(with: imgUrl, completed: nil)
//    }
//        imageFromServerURL(urlString: "imageUrlString") { (image, error) in
//
//            itemView.image = image
//        }

//        for item in chatImgs{
//            if item.contains(""){
//                collageView.isHidden = true
//                containerViewImg.isHidden = true
//                print("empty")
////                collageView.isHidden = false
////                itemView.image = UIImage(contentsOfFile: chatImgs[index])
//            }
//            else{
//                collageView.isHidden = false
//                containerViewImg.isHidden = false
//
////                itemView.image = UIImage(contentsOfFile: item)
//                do{
//                    let url = URL(string: item)
////                    print(url)
//                    let data = try Data(contentsOf: url!)
//                    itemView.image = UIImage(data: data)
//                    //UIImage(contentsOfFile: chatImgs[index])
//                    //            itemView.image = images[index]
//                    //                collageView.isHidden = true
//                    //                containerViewImg.isHidden = true
//                    //                print("empty")
//                }
//
//
//                catch{
//                    print(error)
//                }
//            }
//
//        }
        let arr = chatImgs
        let str1 = arr[optional: 1] // --> str1 is now Optional("bar")
//        itemView.image = arr[optional: 1]
    
        if let str2 = arr[optional: 2] {
            print(str2) // --> this still wouldn't run
        } else {
            print("No string found at that index") // --> this would be printed
        }

        //"http://i.imgur.com/w5rkSIj.jpg"
//        if chatImgs.isEmpty {
//            print("polo")
//        }
//        else{
//            Alamofire.request(chatImgs[index]).responseImage { response in
//                if let catPicture = response.result.value {
//                    print("image downloaded: \(catPicture)")
//                    itemView.image = catPicture
//                }
//            }
//        }
//        let catPictureURL = URL(string: "http://i.imgur.com/w5rkSIj.jpg")!
//            //URL(string: chatImgs[safe:index] ?? " ")
//        let emptyUrString  = URL(string: "")
//        //"http://i.imgur.com/w5rkSIj.jpg")! // We can force unwrap because we are 100% certain the constructor will not return nil in this case.
//
//        // Creating a session object with the default configuration.
//        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
//        let session = URLSession(configuration: .default)
//
//        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
//        let downloadPicTask = session.dataTask(with: catPictureURL ) { (data, response, error) in
//            // The download has finished.
//            if let e = error {
//                print("Error downloading cat picture: \(e)")
//            } else {
//                // No errors found.
//                // It would be weird if we didn't have a response, so check for that too.
//                if let res = response as? HTTPURLResponse {
//                    print("Downloaded cat picture with response code \(res.statusCode)")
//                    if let imageData = data {
//                        // Finally convert that Data into an image and do what you wish with it.
//                        let image = UIImage(data: imageData)
//                        // Do something with your image.
//                        itemView.image = image
//                    } else {
//                        print("Couldn't get image: Image is nil")
//                    }
//                } else {
//                    print("Couldn't get response code for some reason")
//                }
//            }
//        }
//        downloadPicTask.resume()
//        do{
//            let url = URL(string: chatImgs[safe: index]!)
////                    print(url)
//            let data = try Data(contentsOf: url!)
//            itemView.image = UIImage(data: data)
//            //UIImage(contentsOfFile: chatImgs[index])
//            //            itemView.image = images[index]
//            //                collageView.isHidden = true
//            //                containerViewImg.isHidden = true
//            //                print("empty")
//        }
//
//
//        catch{
//            print(error)
//        }
                ///images[index]
        
                //UIImage(contentsOfFile: chatImgs[index])
            
//        }
            //images[index]
        itemView.layer.borderWidth = 3
        let array = chatImgs
            //["Apples", "Peaches", "Plums"]
//apples!
        let isIndexValid = array.indices.contains(index)
        if isIndexValid {
            print("shtaka")
//            itemView.image = UIImage(contentsOfFile: array[index])
            if let url = NSURL(string: array[index])
                {
                if let data = NSData(contentsOf: url as URL)
                    {
                    itemView.image = UIImage(data: data as Data)
                    }
                }

//            itemView.image.imageFromUrl("https://robohash.org/123.png")

//            itemView.image.
            
        }
        else{
            print("Appel khaaa")
        }
//        if array.contains() {
//            print("We've got empty string ")
//        } else {
//            print("No apples here – sorry!")
//        }
//                                itemView.image = images[index]

        if index == shownImagesCount - 1 {
            addBlackViewAndLabel(to: itemView)
        }
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
    private func addBlackViewAndLabel(to view:UIView) {
        
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
    public func imageFromUrl(urlString: String) {

       
        
            }
    private func addConstraints(to view:UIView, parentView:UIView) {
        
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
        print(itemView.image)
//        let HomeVC = storyboard.instantiateViewController(withIdentifier: HomeController.className) as! HomeController

        let categoryVC = storyboard.instantiateViewController(withIdentifier: "ViewAttachmentImageViewController") as! ViewAttachmentImageViewController
        print(chatImgs)
        categoryVC.imageAttachment = chatImgs
            //UIImage(contentsOfFile: chatImgs[index])
            //UIImage(chatImgs)
            //images
//        categoryVC
//        cell.dataArray = catLocationsArray
//
//        categoryVC.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(categoryVC, animated: true)


//        notifyUser(message: message)
    }
    
}
import CollageView
class ReceiverCell: UITableViewCell,CollageViewDataSource,CollageViewDelegate {
    var chatImgs : [String] = []
    fileprivate let images = [#imageLiteral(resourceName: "usa"), #imageLiteral(resourceName: "chat-2"), #imageLiteral(resourceName: "twitter"), #imageLiteral(resourceName: "googleSocial"),#imageLiteral(resourceName: "heart")]
                              //#imageLiteral(resourceName: "mirror"), #imageLiteral(resourceName: "amsterdam"), #imageLiteral(resourceName: "istanbul"), #imageLiteral(resourceName: "camera"), #imageLiteral(resourceName: "istanbul2"), #imageLiteral(resourceName: "mirror")];
    
    fileprivate var shownImagesCount = 4
    
    fileprivate var moreImagesCount: Int {
        get {
            return chatImgs.count - shownImagesCount
        }
    }
    var layoutDirection: CollageViewLayoutDirection = .horizontal
    var layoutNumberOfColomn: Int = 2
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

//    fileprivate lazy var reOrderButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(title: "ReOrder", style: .plain, target: self, action: #selector(self.reOrderButtonTapped(sender: )))
//        return button
//    }()
    


    
    @IBOutlet weak var collageViewReceiverImages: CollageView!{
        didSet{
            collageViewReceiverImages.delegate    = self
            collageViewReceiverImages.dataSource  = self
//            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
//
//
//                collageViewReceiverImages.layer.borderWidth = 3
//                collageViewReceiverImages.layer.cornerRadius = 3
//                collageViewReceiverImages.layer.borderColor = Constants.hexStringToUIColor(hex: mainColor).cgColor
//            }

        }
    }
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var imgProfileDocumentReceiver: UIImageView!{
        didSet{
            imgProfileDocumentReceiver.round()
        }
    }
    @IBOutlet weak var BtnDocumentReceiverDownload: UIButton!
    @IBOutlet weak var containerDocumentReceiver: UIView!{
        didSet{
            containerDocumentReceiver.layer.borderWidth = 1
            containerDocumentReceiver.layer.cornerRadius = 10
            containerDocumentReceiver.backgroundColor = UIColor.white
            containerDocumentReceiver.layer.borderColor = UIColor.white.cgColor

        }
    }
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgIcon: UIImageView!{
        didSet{
            imgIcon.round()
        }
    }
    
    @IBOutlet weak var imgProfileReceiverAttachment: UIImageView!{
        didSet{
            imgProfileReceiverAttachment.round()
        }
    }
//    @IBOutlet weak var btnOpenreceiverAttachment: UIButton!
//    @IBOutlet weak var imgReceiverAttachment: UIImageView!
    @IBOutlet weak var containerReceiverAttachment: UIView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
          
            containerReceiverAttachment.layer.borderWidth = 1
            containerReceiverAttachment.layer.cornerRadius = 10
                containerReceiverAttachment.layer.borderColor = UIColor.white.cgColor
                containerReceiverAttachment.backgroundColor = UIColor.white
                //Constants.hexStringToUIColor(hex: mainColor).cgColor
            }
        }
    }
//    var btnFullReceiver Action: (()->())?
    var btnDownloadAttachmentReceiverAction: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //self.imgBackground.layer.cornerRadius = 15
        self.imgBackground.clipsToBounds = true
    }
    //MARK:- @IBAction
//    @IBAction func ActionOpenReceiverAttachment(_ sender: Any) {
//        self.btnFullReceiverAction?()
//    }
    
    
    @IBAction func actionDocumentDownlaodReceiverCell(_ sender: Any) {
        self.btnDownloadAttachmentReceiverAction?()

    }
    
    
    
    
    
//    @objc private func reOrderButtonTapped(sender: UIBarButtonItem) {
//
//        sender.tag += 1
//        if sender.tag%2 == 0 {
//            layoutDirection = .horizontal
//            layoutNumberOfColomn = 3
//        } else {
//            layoutDirection = .vertical
//            layoutNumberOfColomn = 2
//        }
//        collageView.reload()
//    }
    func notifyUser(message: String) -> Void {
        
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
//        if chatImgs.count != 0 {
//        let isIndexValid = chatImgs.indices.contains(index)
//                if isIndexValid {
//        if let imgUrl = URL(string:(chatImgs[index])) {
//            itemView.sd_setShowActivityIndicatorView(true)
//            itemView.sd_setIndicatorStyle(.gray)
//
//            do {
//                let url = URL(string: chatImgs[index])
//                print(url)
//                                //"https://verona-api.municipiumstaging.it/system/images/image/image/22/app_1920_1280_4.jpg")
//                let data = try Data(contentsOf: url!)
//                itemView.image = UIImage(data: data)
//            }
//
//            catch{
//                print(error)
//            }

//        if let boo = chatImgs[safe: index]{
//
//            do{
//                itemView.image = UIImage(contentsOfFile: boo)
//            }
//            catch{
//                print("asassa")
//
//            }
//
//        }
//        if let boo = chatImgs[safe: index]{
//            itemView.image = UIImage(contentsOfFile: boo)
//        }
//        else{
            itemView.image = images[index]


//        }

//        if chatImgs[index].isEmpty {
//            print("empty\(index)")
//        }
//        else{
//            itemView.image = UIImage(contentsOfFile: chatImgs[index])
//        }
        //images[index]
        //UIImage(contentsOfFile: imgUrl.absoluteString)
                                        //chatImgs[index])
                
                            //images[index]

//            UIImageView(itemView.sd_setImage(with: imgUrl, completed: nil))
//                    self.tableView.reloadData()
            

//        }
        
//            itemView.image = images[index]
        
                //UIImage(contentsOfFile: chatImgs[index])
            
//        }
            //images[index]
        itemView.layer.borderWidth = 3
      
        if index == shownImagesCount - 1 {
            addBlackViewAndLabel(to: itemView)
        }
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
    private func addBlackViewAndLabel(to view:UIView) {
        
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
    
    private func addConstraints(to view:UIView, parentView:UIView) {
        
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
        print(itemView.image)
//        let HomeVC = storyboard.instantiateViewController(withIdentifier: HomeController.className) as! HomeController

        let categoryVC = storyboard.instantiateViewController(withIdentifier: "ViewAttachmentImageViewController") as! ViewAttachmentImageViewController
//        print(chatImgs)
        categoryVC.imageAttachment = chatImgs
            //UIImage(contentsOfFile: chatImgs[index])
            //UIImage(chatImgs)
            //images
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
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex         = hex.substring(from: index)
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
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
        guard let navVC = self.navigationController else {
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

//extension Collection where Indices.Iterator.Element == Index {
//    subscript (safe index: Index) -> Iterator.Element? {
//        return indices.contains(index) ? self[index] : nil
//    }
//}
extension Collection {
    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}

//extension UIImageView {
//

        
        
        
        
//        if let url = NSURL(string: urlString) {
//            let request = NSURLRequest(url: url as URL)
//            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.mainQueue) {
//                (response: URLResponse!, data: NSData!, error: NSError!) -> Void in
//                self.image = UIImage(data: data as Data)
//            }
//        }
//    }
//}
