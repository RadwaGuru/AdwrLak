//
//  SocketIOManagerDefault.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import Foundation
import SocketIO

class SocketIOManagerDefault: NSObject, SocketIOManager {
    
    //MARK: - Instance Properties
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    var userId = "0"
    var APIKey = ""
    var defaults = UserDefaults.standard
    //MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    //MARK: - Instance Methods
    func establishConnection() {
        if let WhizChtApiKey = self.defaults.string(forKey: "WhizChatAPiKey") {
            APIKey = WhizChtApiKey
            print("=============-WhizChtApiKey::\(APIKey)===========")

        }
        print("----establishConnection")
        //"type":"gtChatPro"
        //"key_147wCAlzJQW8GWqkjXocIHlCoVbUYEe8B"
        manager = SocketManager(socketURL: URL(string: "https://socket.agilepusher.com:3000")!,config: [.log(false),.compress,.forcePolling(true),.forceWebsockets(true),.connectParams(["apiKey" : APIKey ,"website":Constants.URL.baseUrl
        ])])
        socket = manager?.defaultSocket
        manager?.forceNew = true
        manager?.reconnects = true
        manager?.reconnectWaitMax = 0
        manager?.reconnectWait = 0
        socket.connect()
        addHandlers()
        print("----\(socket.sid)")
        print("----connect request sent")
    }
    //    func establishConnection() {
    //        manager?.forceNew = true
    //        manager?.reconnects = true
    //        manager?.reconnectWaitMax = 0
    //        manager?.reconnectWait = 0
    //        socket.connect()
    //        addHandlers()
    //    }
    
    func closeConnection() {
        socket.disconnect()
        debugPrint("=========>>>>>>Socket Closed<<<<<<<<=========")
    }
    
    func connectToChat(with name: String) {
        socket.emit("connectUser", name)
    }
    func addHandlers() {
        
        socket.on(clientEvent: .connect) { [self]data, ack in
            debugPrint("----socket connected----------")
            print("---- handlers\(self.socket.handlers)")
            
            socket.on("agAskedToJoin")  {data,ack in
                debugPrint("---------------------:\(data[0]): \(data[1])------->>>>>>>>>>>>>>")
                
                if UserDefaults.standard.string(forKey: "senderId") == data[1] as? String {
                    debugPrint("yes it is cooreect for to connect you can move ahead---------------------:\(data[0]): \(data[1])------->>>>>>>>>>>>>>")
                    joinRoom(room: (data[0] as? String)!, sender: (data[1] as? String)!, receiver: "")
                    
                }
                
            }
            
            //            socket.on("agAskedToJoin")  {data,ack in
            ////                if UserDefaults.standard.string(forKey: "ReceiverCommunicationId") ==  data[1] as! String {
            ////                    debugPrint("yes it is cooreect for to connect you can move ahead---------------------------->>>>>>>>>>>>>>")
            ////
            //                }
            //                debugPrint("----------------------------------WELCOME to room with correct data \(data[1])--------------------")
            
            //                socket.emit("agRoomJoined", data[0] as! SocketData,"",data[1] as! SocketData)
            
            //            }
            //            socket.on("adInfoMessage"){data,ack in
            //                debugPrint("heelooooo")
            //            }
            //            socket.on("agGotNewMessage") { data,ack in
            //                debugPrint("---------------1-------------------WELCOME\(data)--------------------")
            //            }
            
            
            
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            debugPrint("socket disconnected-----\(data)----------")
        }
        
        socket.on(clientEvent: .error) {data, ack in
            debugPrint("error on socket-----\(data)-----")
        }
        
        socket.on(clientEvent: .reconnect) {data, ack in
            
            debugPrint("socket reconnecting----------")
        }
        socket.on("error") {data, ack in
            
        }
        
        socket.onAny {_ in
            
        }
        
        //        socket.on("agGotNewMessage") { data,ack in
        //            debugPrint("------------------hey boi --------------WELCOME agGotNewMessage\(data)--------------------")
        //        }
        //        agRoomJoined (emit it to join room with these params room, sender, receiver)
        
        
        
    }
    func startTyping(RoomName: String,Message here: String,Chat ID: String){
        socket.emit("agTyping", "RoomName","Message here","Chat ID")
        
    }
    func stopTyping(RoomName: String,Chat ID: String){
        socket.emit("agStopTyping", "RoomName" ,"Chat ID")
        
    }
    
    func joinRoom (room: String,sender: String,receiver: String){
        socket.emit("agRoomJoined", room,sender,receiver)
        
        //        isRoomJoin()
    }
    //    room: String,receiver: String
    func isRoomJoin(){
        
        socket.on("agAskedToJoin")  {data,ack in
            if UserDefaults.standard.string(forKey: "senderId") ==  (data[1] as! String) {
                debugPrint("isRoomJoin in fucntion ---------------------:\(data[0]): \(data[1])------->>>>>>>>>>>>>>")
                
            }
            
            //            self.socket.emit("agRoomJoined", room,receiver,"")
            //            debugPrint("----------------------------------WELCOME to room receiver shb correct data:: \(receiver):\(room)------------------")
            //            debugPrint("----------------------------------WELCOME to room with correct data \(data)--------------------")
            //            self.socket.on("agGotNewMessage") { data,ack in
            //                debugPrint("-------------------22--------------WELCOME agGotNewMessage\(data)--------------------")
            //            }
        }
        
        //
    }
    
    //    socket.emit('agInfoMessage', 'Message here);
    
    
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void) {
        socket.on("userList") { dataArray, _ in
            completionHandler(dataArray[0] as! [[String: Any]])
        }
    }
    
    func send(roomId: String,message: String,receiverID: String,ChatId: String) {
        //     socket.emit("agInfoMessage_dev", message)
        socket.emit("agSendMessage", roomId, message, receiverID, ChatId)
        
        
    }
    func sendImage(roomId: String,message: String,receiverID: String,ChatId: String) {
        //     socket.emit("agInfoMessage_dev", message)
        socket.emit("agSendMessage", roomId, message, receiverID, ChatId)
        
        
    }
    
    
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void) {
        //        socket.on("agInfoMessage_dev") { data,ack in
        //                  debugPrint("---------------1-------------------WELCOME\(data)--------------------")
        //              }
        
        
        //        socket.on("agGotNewMessage") { data,ack in
        //            debugPrint("-------------------22--------------WELCOME agGotNewMessage\(data)--------------------")
        //        }
        
        
        socket.on("agGotNewMessage") { dataArray, _ in
            
            var messageDict: [String: Any] = [:]
            
            messageDict["msg"] = dataArray[0] as! String
            messageDict["user"] = dataArray[1] as! String
            messageDict["chat_id"] = dataArray[2] as! String
            debugPrint("---------------agGotNewMessage Response\(dataArray)--------------------")
            completionHandler(messageDict)
        }
        
        
        //        socket.on("agInfoMessage_dev") { dataArray, _ in
        //            var messageDict: [String: Any] = [:]
        //
        //            messageDict["data"] = dataArray[0] as! String
        //
        //            completionHandler(messageDict)
        //        }
    }
}
