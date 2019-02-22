//
//  PlayerWindowController.swift
//  NiconicoPresentationPlayer
//
//  Created by Ryo Tsuruda on 2/21/19.
//  Copyright © 2019 bugttle. All rights reserved.
//

import Foundation
import Cocoa

final class PlayerWindowController: NSWindowController {
    var messageManager: MessageManager!
    var likeManager: LikeManager!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window!.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle, .fullScreenAuxiliary]
        window!.titleVisibility = .hidden
        window!.titlebarAppearsTransparent = true
        window!.level = NSWindow.Level.screenSaver
        window!.isOpaque = false
        window!.backgroundColor = NSColor.clear
        window!.ignoresMouseEvents = true
        window!.hasShadow = false
        window!.styleMask = [.fullSizeContentView, .borderless]
        
        self.toScreen(screen: NSScreen.main!) // use launched screen

        messageManager = MessageManager(window: window!)
        likeManager = LikeManager(window: window!)
    }
    
    func toScreen(at: Int) {
        let screens = NSScreen.screens
        if at < screens.count {
            self.toScreen(screen: screens[at])
        }
    }
    
    func toScreen(screen: NSScreen) {
        let menu = NSApplication.shared.mainMenu
        let menuBarHeight = (menu != nil) ? menu!.menuBarHeight : CGFloat(0.0)
        let frame = CGRect(
            x: screen.frame.origin.x,
            y: screen.frame.origin.y,
            width: screen.frame.width,
            height: screen.frame.height - menuBarHeight)
        self.window!.setFrame(frame, display: true, animate: false)
    }
    
    func addMessage(text: String) {
        messageManager.addMessage(text: text)
    }
    
    func showLike(count: Int) {
        likeManager.showLike(count: count)
    }
    
    func postKeyboardEvent(key: CGKeyCode) {
        KeyboardEvent.postKeyboardEvent(key: key)
    }
    
    func doScreenTest() {
    }}
