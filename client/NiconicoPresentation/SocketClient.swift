//
//  NetworkConnection.swift
//  NiconicoPresentation
//
//  Created by Tsuruda, Ryo on 2018/10/25.
//  Copyright © 2018年 bugttle. All rights reserved.
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
            guard let comment = data[0] as? String else { return }
            self.onComment(comment);
        }
        socket.on("like") {data, ack in
            guard let like = data[0] as? Int else { return }
            self.onLike(like);
        }
        socket.on("key") {data, ack in
            guard let key = data[0] as? String else { return }
            self.onKey(key);
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
