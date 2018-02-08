//
//  ChatRoomViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2018-02-08.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//
//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright (c) 2014 vluxe. All rights reserved.
//
import UIKit
import Starscream


class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WebSocketDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMessage: UITextView!
    var list : [Any?] = []
    var socket: WebSocket!

    public func addMessage(message: Any?) {
        self.list.append(message)
        self.tableView?.reloadData()
        UI( {
            let indexPath = IndexPath(row: self.list.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        })
    }
    
    public func setInternalObject() throws {
        throw NSError(domain: "my error description", code: 01 )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socket.write(string: "JY disconnectd")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
            self.socket.disconnect()
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/chat")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        
        viewMessage.textColor = .lightGray
        viewMessage.text = "Type your thoughts here..."
        viewMessage.delegate = self
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)
        
        let msg = (list[indexPath.row] as! String)
        cell.textLabel?.text = msg
        
        return cell
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if viewMessage.textColor == .lightGray && viewMessage.isFirstResponder {
            viewMessage.text = nil
            viewMessage.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //textView.resignFirstResponder()
            socket.write(string: viewMessage.text)
            viewMessage.text = ""
            return false
        }
        return true
    }

    func textViewDidEndEditing (_ textView: UITextView) {
        if viewMessage.text.isEmpty || viewMessage.text == "" {
            viewMessage.textColor = .lightGray
            viewMessage.text = "Type your thoughts here..."
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        socket.write(string: "JY connectd")
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        //if let e = error as? WSError {
        //    print("websocket is disconnected: \(e.message)")
        //} else if let e = error {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        addMessage(message: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if socket.isConnected {
            sender.title = "Connect"
            socket.write(string: "JY disconnectd")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                // Put your code which should be executed with a delay here
                self.socket.disconnect()
            })
            viewMessage.textColor = .lightGray
            viewMessage.text = "not connected"
            viewMessage.isEditable = false
        } else {
            sender.title = "Disconnect"
            socket.connect()
            viewMessage.isEditable = true
            viewMessage.textColor = .black
            viewMessage.text = ""
        }
    }
    
}
