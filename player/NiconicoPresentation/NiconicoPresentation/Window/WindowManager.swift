//
//  WindowManager.swift
//  NiconicoPresentation
//
//  Created by bugttle on 3/7/15.
//  Copyright © 2015 bugttle. All rights reserved.
//

import Foundation
import Cocoa

class WindowManager: NSObject {
    var window: NSWindow!
    
    var messageManager: MessageManager!
    var likeManager: LikeManager!
    
    init(window: NSWindow) {
        super.init()
        
        self.window = window
        window.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle, .fullScreenAuxiliary]
        window.level = NSWindow.Level.screenSaver
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.ignoresMouseEvents = true
        window.hasShadow = false
        window.styleMask = NSWindow.StyleMask.borderless
        
        self.toScreen(at: 0)  // send to default screen
        
        messageManager = MessageManager(window: window)
        likeManager = LikeManager(window: window)
    }
    
    func toScreen(at: Int) {
        let screens = NSScreen.screens
        if at < screens.count {
            self.toScreen(screen: screens[at])
        }
    }
    
    func toScreen(screen: NSScreen) {
        self.window.setFrame(screen.visibleFrame, display: true, animate: false)
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
    }
}
