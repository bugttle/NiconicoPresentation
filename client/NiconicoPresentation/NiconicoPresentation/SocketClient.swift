//
//  SocketClient.swift
//  NiconicoPresentation
//
//  Created by bugttle on 3/7/15.
//  Copyright © 2015 bugttle. All rights reserved.
//

import Foundation
import SocketIO

class SocketClient: NSObject {
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    var onComment: ((String) -> Void)!
    var onLike: ((Int) -> Void)!
    var onKey: ((String) -> Void)!
    var onTest: (() -> Void)!
    
    var onPublish: NormalCallback?
    
    init(url: String) {
        super.init()
        
        self.manager = SocketManager(socketURL: URL(string: url)!, config: [.log(true), .compress])
        self.socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket connected")
        }
        socket.on("comment") {data, ack in
            guard let map = data[0] as? [String: String] else { return }
            self.onComment(map["text"]!);
        }
        socket.on("like") {data, ack in
            guard let map = data[0] as? [String: Int] else { return }
            self.onLike(map["count"]!);
        }
        socket.on("key") {data, ack in
            guard let map = data[0] as? [String: String] else { return }
            self.onKey(map["code"]!);
        }
        socket.on("test") {data, ack in
            self.onTest();
        }
        socket.connect()
    }
    
    
    func connect() {
        self.socket.connect()
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
}
