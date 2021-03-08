//
//  SocketIOManager.swift
//  WebSockets
//
//  Created by Elina Batyrova on 08.10.2020.
//

import Foundation

protocol SocketIOManager {
    
    func establishConnection()
    func closeConnection()
    func connectToChat(with name: String)
    func observeUserList(completionHandler: @escaping ([[String: Any]]) -> Void)
    func send(roomId: String,message: String,receiverID: String,ChatId: String) 
    func joinRoom (room: String,sender: String,receiver: String)
    func observeMessages(completionHandler: @escaping ([String: Any]) -> Void)
    func startTyping(RoomName: String,Message here: String,Chat ID: String)
    func stopTyping(RoomName: String,Chat ID: String)


}
