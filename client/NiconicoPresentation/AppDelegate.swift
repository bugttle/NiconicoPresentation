//
//  AppDelegate.swift
//  NiconicoPresentation
//
//  Created by Tsuruda, Ryo on 2018/10/25.
//  Copyright © 2018年 bugttle. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let URL = "http://localhost:8080"
    
    @IBOutlet weak var menu: NSMenu!
    
    var statusBarManager: StatusBarManager!
    var menuManager: MenuManager!
    var windowManager: WindowManager!
    var networkClient: NetworkClient!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let board = NSStoryboard(name: "Main", bundle: nil)
        let windowController = board.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
        
        statusBarManager = StatusBarManager(menu: menu)
        menuManager = MenuManager(menu: menu, action: #selector(self.onClickScreenSelectMenuItem))
        windowManager = WindowManager(window: windowController.window!)
        networkClient = NetworkClient(url: URL)
        networkClient.onPublish = {data, ack in
            data[0]
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

//    func onEvent(event: String) {
//        switch event {
//        case "publish":
//
//        case "keyEvent":
//        case "leftArrow":
//        case "rightArrow":
//        default:
//            <#code#>
//        }
//    }
    // MARK: - MenuItem actions
    
    @objc func onClickScreenSelectMenuItem(_ sender: NSMenuItem) {
        
        windowManager.postKeyboardEvent(key: KeyboardEvent.LeftArrow)
        windowManager.toScreen(at: sender.tag)
    }
    
    @IBAction func onClickConnectToServerMenuItem(_ sender: NSMenuItem) {
        networkClient.disconnect()
    }
    
    
}

