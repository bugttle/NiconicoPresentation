//
//  AppDelegate.swift
//  NiconicoPresentation
//
//  Created by bugttle on 3/7/15.
//  Copyright © 2015 bugttle. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let URL = "http://localhost:8080"
    
    @IBOutlet weak var menu: NSMenu!
    
    var statusBarManager: StatusBarManager!
    var menuManager: MenuManager!
    var windowManager: WindowManager!
    var socketClient: SocketClient!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        
        self.statusBarManager = StatusBarManager(menu: menu)
        self.menuManager = MenuManager(menu: menu, action: #selector(self.onClickScreenSelectMenuItem))
        self.windowManager = WindowManager(window: windowController.window!)
        
        self.socketClient = self.createSocketIO(url: URL)
        self.socketClient.connect()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        self.socketClient.disconnect()
    }
    
    func createSocketIO(url: String) -> SocketClient! {
        let client = SocketClient(url: url)
        client.onComment = {comment in
            self.windowManager.addMessage(text: comment)
        }
        client.onLike = {like in
            self.windowManager.showLike(count: like)
        }
        client.onKey = {key in
            switch key {
            case "LeftArrow":
                self.windowManager.postKeyboardEvent(key: KeyboardEvent.LeftArrow)
                break
            case "RightArrow":
                self.windowManager.postKeyboardEvent(key: KeyboardEvent.RightArrow)
                break
            default:
                break
            }
        }
        client.onTest = {
            self.windowManager.doScreenTest()
        }
        return client
    }
    
    // MARK: - MenuItem actions
    
    @objc func onClickScreenSelectMenuItem(_ sender: NSMenuItem) {
        self.windowManager.toScreen(at: sender.tag)
    }
    
    @IBAction func onClickConnectToServerMenuItem(_ sender: NSMenuItem) {
        self.socketClient.disconnect()
    }
}
