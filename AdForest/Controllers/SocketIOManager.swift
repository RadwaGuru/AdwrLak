//
//  SocketIOManager.swift
//  AdForest
//
//  Created by Apple on 26/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//


import UIKit
import SocketIO
class SocketIOManager: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        askForNickname()

    }


    static let sharedInstance = SocketIOManager()
    var manager = SocketManager(socketURL: URL(string: "http://192.168.10.50:3000")!, config: [.log(true), .compress])
    var window:UIWindow!
   lazy var socket = manager.defaultSocket
   
    func connectToServerWithNickname(nickname: String, completionHandler: (_ userList: [[String: AnyObject]]?) -> Void) {
        socket.emit("connectUser", nickname)
        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(ack: dataArray[0] as! [[String: AnyObject]])
        }
    }
    func askForNickname() {
        let alertController = UIAlertController(title: "SocketChat", message: "Please enter a nickname:", preferredStyle: UIAlertControllerStyle.alert)
     
        alertController.addTextField(configurationHandler: nil)
     
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
     
        }
     
        alertController.addAction(OKAction)

        present(alertController, animated: true, completion: nil)

    }
    func establishConnection() {
        socket.connect()
    }
     
     
    func closeConnection() {
        socket.disconnect()
    }
}
