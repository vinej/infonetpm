//
//  ChatClient.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2018-02-08.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//
import Foundation
import Starscream

public class ChatClient : WebSocketDelegate{
    
    var socket: WebSocket?
    
    func connet(url: String) {
        /*
            var request = URLRequest(url: URL(string: "ws://localhost:8080/")!)
            request.timeoutInterval = 5
            request.setValue("someother protocols", forHTTPHeaderField: "Sec-WebSocket-Protocol")
            request.setValue("14", forHTTPHeaderField: "Sec-WebSocket-Version")
            request.setValue("Everything is Awesome!", forHTTPHeaderField: "My-Awesome-Header")
            let socket = WebSocket(request: request)
         */
        socket = WebSocket(url: URL(string: url)!)
        socket?.delegate = self
        socket?.connect()
    }
    
    public func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription ?? "")")
    }
    
    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("got some text: \(text)")
    }
    
    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
}

