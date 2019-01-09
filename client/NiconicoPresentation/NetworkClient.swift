//
//  NetworkConnection.swift
//  NiconicoPresentation
//
//  Created by Tsuruda, Ryo on 2018/10/25.
//  Copyright © 2018年 bugttle. All rights reserved.
//

import Foundation
import SocketIO

class NetworkClient: NSObject {
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    var onEvent: ((String) -> Void)!
    
    var onPublish: NormalCallback?

    init(url: String) {
        super.init()
        
        self.manager = SocketManager(socketURL: URL(string: url)!, config: [.log(true), .compress])
        self.socket = manager.defaultSocket
        
//        self.onEvent = onEvent
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket connected")
        }

        socket.on("comment") {data, ack in
            data[0] as
            self.onPublish?(data,ack)
        }
        
        socket.on("currentAmount") {data, ack in
//            guard let cur = data[0] as? Double else { return }
//            
//            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                socket.emit("update", ["amount": cur + 2.50])
//            }
//            
//            ack.with("Got your currentAmount", "dude")
        }
//        
        socket.connect()
    }
    
   
    func connect() {
        self.socket.connect()
    }
    
    func disconnect() {
        self.socket.disconnect()
    }
}
