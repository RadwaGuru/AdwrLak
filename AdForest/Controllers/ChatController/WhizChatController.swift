//
//  WhizChatController.swift
//  AdForest
//
//  Created by Apple on 04/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

struct MessageData {
    
    let text: String
}

//struct WhizChatMessagesBoxChatList {
//
//    let text: String
//}

class WhizChatController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate {
     var messages: [WhizChatMessagesBoxChatList] = [] {
        didSet {
            let text: String
            tableView.reloadData()

        }
    }

    private var socketManager = Managers.socketManager

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtMessage: UITextView!
    {
        didSet {
            txtMessage.layer.borderWidth = 0.5
            txtMessage.layer.borderColor = UIColor.lightGray.cgColor
            txtMessage.delegate = self
        }
    }
    @IBOutlet weak var heightConstraintTxtView: NSLayoutConstraint!
    @IBOutlet weak var heightContraintViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnOpenSmilies: UIButton!
    @IBOutlet weak var imgSimiles: UIImageView!
    @IBOutlet weak var containerViewSmilies: UIView!
    @IBOutlet weak var imgBtnSendMessage: UIImageView!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var containerViewSendMessage: UIView!
    @IBOutlet weak var btnAttachments: UIButton!
    @IBOutlet weak var containerViewAttachments: UIView!
    @IBOutlet weak var containerViewBottom: UIView!
    
    //MARK:- Properties
    let keyboardManager = IQKeyboardManager.sharedManager()
    var dataArray = ["hi","there","listen","Come here"]
    var dataArr = ["hey","where?","hello","Yes please!"]
    var roomId = ""
    var senderId = ""
    var receiverId = ""
    var ChatId = ""
    var devMsg = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showBackButton()
        self.hideKeyboard()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //        let bounds = self.navigationController!.navigationBar.bounds
        //        let height: CGFloat = 50 //whatever height you want to add to the existing height
        
        //        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 40, width: bounds.width, height: bounds.height + height)
        
        self.navigationItem.titleView = setTitle(title: "Farwa", subtitle: "LastSeen 2:30.00 am")
        //        initUI()
        BlockButton()
        socketManager.establishConnection()
        
        Timer.every(5.second) {
            self.startObservingMessages()
        }
//        txtMessage.setTextWithTypeAnimation(typedText: self.txtMessage.text, characterDelay:  10) //less delay is faster

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let parameter : [String: Any] = ["chat_id": ChatId]
        getChatMesages(param: parameter as NSDictionary)
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
    //MARK:-Actions
    @IBAction func actionSendMessage(_ sender: Any) {
        
        socketManager.joinRoom(room: roomId, sender: senderId, receiver: receiverId)
        
        
        socketManager.send(roomId: roomId, message: self.txtMessage.text, receiverID: receiverId, ChatId: self.ChatId)

    }
   
   
    
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
                self.tableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
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
         self.bottomConstraint.constant = 0
        self.setTypingIndicatorVisible(false)

        self.txtMessage.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextView) -> Bool {
        self.bottomConstraint.constant = 0
        self.txtMessage.resignFirstResponder()
        return true
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
        createTypingIndicator()
        socketManager.startTyping(RoomName: "RoomName",Message: "Messagehere",Chat: "Chat ID")
//        func stopTyping(RoomName: String,Chat ID: String){
//            socket.emit("agStopTyping", "RoomName" ,"Chat ID")
//
//        }

        self.setTypingIndicatorVisible(true)

    }
    
    func updateCharacterCount() {
      
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 485)
        label.textAlignment = .center
        label.text = "I'm a test label"
        self.view.addSubview(label)

    }
    

    
    private var typingIndicatorBottomConstraint: NSLayoutConstraint!
    
    private func createTypingIndicator() {
      let typingIndicator = TypingIndicatorView(receiverName: "Farwa")
        view.insertSubview(typingIndicator, belowSubview: self.tableView)
      
      typingIndicatorBottomConstraint = typingIndicator.bottomAnchor.constraint(
        equalTo: containerViewBottom.topAnchor,
        // Set the constant to 16 at start. This means that the top of the
        // typing indicator will be below the top of the text area.
        constant: 16)
      typingIndicatorBottomConstraint.isActive = true

      NSLayoutConstraint.activate([
        typingIndicator.heightAnchor.constraint(equalToConstant: 20),
        typingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26)
      ])

    }
    
    private func setTypingIndicatorVisible(_ isVisible: Bool) {
      let constant: CGFloat = isVisible ? -16 : 16
      UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
        self.typingIndicatorBottomConstraint.constant = constant
        self.view.layoutIfNeeded()
        debugPrint("insides")

      })
        debugPrint("asasdad")
    }
    
    
    func BlockButton() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "reject"), for: .normal)
        button.tintColor = UIColor.white
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        //        button.addTarget(self, action: #selector(onClickRefreshButton), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    
    func initUI() {
        
        let rect:CGRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 64, height: 64))
        
        let titleView:UIView = UIView.init(frame: rect)
        /* image */
        let image:UIImage = UIImage.init(named: "blackuser")!
        let image_view:UIImageView = UIImageView.init(image: image)
        image_view.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        image_view.center = CGPoint.init(x: titleView.center.x, y: titleView.center.y - 10)
        image_view.layer.cornerRadius = image_view.bounds.size.width / 2.0
        image_view.layer.masksToBounds = true
        titleView.addSubview(image_view)
        
        /* label */
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 30, width: 64, height: 24))
        label.text = "Hello"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        titleView.addSubview(label)
        
        self.navigationItem.titleView = titleView
        
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    //MARK:- Title for Nav bar
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        // Create the image view
        //        let image = UIImageView()
        //        image.image = UIImage(named: "blackuser")
        //        image.layer.borderWidth = 0.5
        //        image.layer.masksToBounds = false
        //        image.layer.borderColor = UIColor.lightGray.cgColor
        //        image.layer.cornerRadius = image.frame.size.width / 2
        //        image.clipsToBounds = true
        //        // To maintain the image's aspect ratio:
        //        let imageAspect = image.image!.size.width/image.image!.size.height
        //        // Setting the image frame so that it's immediately before the text:
        //        image.frame = CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y, width: titleLabel.frame.size.height*imageAspect, height: titleLabel.frame.size.height)
        //        image.contentMode = UIViewContentMode.scaleAspectFit
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        //        titleView.addSubview(image)
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }
    //MARK: -
    
    func startObservingMessages() {
        socketManager.observeMessages(completionHandler: { [weak self] data in
            debugPrint(data)
//            let text = data["data"] as! String
//            let message = WhizChatMessagesBoxChatList(fromDictionary: data)
//            for item in data {
//                self?.messages.append(item.value as! WhizChatMessagesBoxChatList)
//            }
//            let message = WhizChatMessagesBoxChatList(text: data[0] as? String)

//            debugPrint(text)
//            self!.devMsg = text
//            for item in data {
//                let msg = item.value as? WhizChatMessagesBoxChatList
//                self?.messages.append(msg!)
//
//            }

//            let msgData = [data]
//            debugPrint(msgData[0].first as Any)
//            let dd = msgData[0].first as Any
            //            for item in data{
            //                let message = WhizChatMessagesBoxChatList(fromDictionary: item.value as? [String: Any])
            //                var orderRequestUserValues : [String : AnyObject]   = [ :]
            //                self?.messages.append(message)
            //
            //
            //            }
//            var chal = data["msg"]
//            let message = WhizChatMessagesBoxChatList(fromDictionary: data.first?.value as! [String : Any] ).chatMessage
//            self?.messages.append(chal)
//            let message = WhizChatMessagesBoxChatList(fromDictionary:chal as? [String:Any])
            let message = WhizChatMessagesBoxChatList(fromDictionary: data as! [String : Any])
//            res["Array"] as? [[String: Any]]
            debugPrint(message)

            self?.messages.append(message)

//
        })
    }

    //MARK:-TableView Delegates
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell: SenderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell

        if message.isReply == "message-sender-box"{
            
            cell.backgroundColor = UIColor.groupTableViewBackground
            
            let image = UIImage(named: "bubble_sent")
            cell.imgPicture.image = image!
                .resizableImage(withCapInsets:
                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
            cell.imgPicture.image = cell.imgPicture.image?.withRenderingMode(.alwaysTemplate)
            cell.imgPicture.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
            cell.txtMessage.text = message.chatMessage
            cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
            cell.imgProfile.image = UIImage(named: "blackuser")
            tableView.rowHeight = UITableViewAutomaticDimension
            
        }
        else{
            let cellw: ReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cellw.backgroundColor = UIColor.groupTableViewBackground
            
            let images = UIImage(named: "bubble_se")
            cellw.imgBackground.image = images!
                .resizableImage(withCapInsets:
                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
            cellw.txtMessage.text = message.msg
                
                //self.devMsg
                //
            cellw.bgImageHeightConstraint.constant += cellw.heightConstraint.constant
            tableView.rowHeight = UITableViewAutomaticDimension
            
        
        return cellw
        }
        return cell

    }
    
    
   
    //MARK:-API CALLS
    
   
    
    func getChatMesages(param: NSDictionary) {
        UserHandler.WhizChatChatMessageBox(parameter: param, success: { (successResponse) in
            if successResponse.success {
                self.messages = successResponse.data.ChatMessagesList
                self.roomId = successResponse.data.LiveRoomData
                self.senderId =  successResponse.data.SenderId
                self.receiverId = successResponse.data.communicationId
                UserDefaults.standard.set(self.senderId, forKey: "senderId")

                self.tableView.reloadData()
                self.scrollToBottom()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
extension UILabel {
    func setTextWithTypeAnimation(typedText: String, characterDelay: TimeInterval = 5.0) {
        text = ""
        var writingTask: DispatchWorkItem?
        writingTask = DispatchWorkItem { [weak weakSelf = self] in
            for character in typedText {
                DispatchQueue.main.async {
                    weakSelf?.text!.append(character)
                }
                Thread.sleep(forTimeInterval: characterDelay/100)
            }
        }
        
        if let task = writingTask {
            let queue = DispatchQueue(label: "typespeed", qos: DispatchQoS.userInteractive)
            queue.asyncAfter(deadline: .now() + 0.05, execute: task)
        }
    }
    
}
