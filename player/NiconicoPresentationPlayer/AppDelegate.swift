//
//  AppDelegate.swift
//  NiconicoPresentationPlayer
//
//  Created by bugttle on 3/7/15.
//  Copyright © 2015 bugttle. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let URL = "http://localhost:8080/"
    
    @IBOutlet weak var menu: NSMenu!
    
    var windowController: PlayerWindowController!
    var statusBarManager: StatusBarManager!
    var menuManager: MenuManager!
    var socketClient: SocketClient!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let board = NSStoryboard(name: "Main", bundle: nil)
        self.windowController = board.instantiateController(withIdentifier: "MainWindow") as? PlayerWindowController
        
//        let window = windowController.window!
//        let a = window.title
//
////        windowController.showWindow(nil)
////        windowController.window?.makeMain()
//
//        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
//        //        window.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle, .fullScreenAuxiliary]
//        window.level = NSWindow.Level.screenSaver
//        window.isOpaque = false
//        window.backgroundColor = NSColor.clear
//        window.ignoresMouseEvents = true
//        window.hasShadow = false
//        window.styleMask = NSWindow.StyleMask.borderless

        
        self.statusBarManager = StatusBarManager(menu: menu)
        self.menuManager = MenuManager(menu: menu, action: #selector(self.onClickScreenSelectMenuItem))
//
        self.socketClient = self.createSocketIO(url: URL)
        self.socketClient.connect()
//

    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        self.socketClient.disconnect()
    }
    
    func createSocketIO(url: String) -> SocketClient! {
        let client = SocketClient(url: url)
        client.onComment = {comment in
            self.windowController.addMessage(text: comment)
        }
        client.onLike = {like in
            self.windowController.showLike(count: like)
        }
        client.onKey = {key in
            switch key {
            case "LeftArrow":
                self.windowController.postKeyboardEvent(key: KeyboardEvent.LeftArrow)
                break
            case "RightArrow":
                self.windowController.postKeyboardEvent(key: KeyboardEvent.RightArrow)
                break
            default:
                break
            }
        }
        client.onTest = {
            self.windowController.doScreenTest()
        }
        return client
    }
    
    // MARK: - MenuItem actions
    
    @objc func onClickScreenSelectMenuItem(_ sender: NSMenuItem) {
        self.windowController.toScreen(at: sender.tag)
    }
    
    @IBAction func onClickConnectToServerMenuItem(_ sender: NSMenuItem) {
        self.socketClient.disconnect()
    }
}

