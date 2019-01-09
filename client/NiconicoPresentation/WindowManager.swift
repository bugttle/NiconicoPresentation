//
//  MainWindow.swift
//  NiconicoPresentation
//
//  Created by Tsuruda, Ryo on 2018/10/25.
//  Copyright © 2018年 bugttle. All rights reserved.
//

import Foundation
import Cocoa

class WindowManager: NSObject {
    var window: NSWindow!
    
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
        
        self.toScreen(screen: window.screen!)
    }
    
    func toScreen(at: Int) {
        let screens = NSScreen.screens
        if at < screens.count {
            self.window.setFrame(screens[at].visibleFrame, display: true, animate: false)
        }
    }
    
    func toScreen(screen: NSScreen) {
        self.window.setFrame(screen.visibleFrame, display: true, animate: false)
    }
    
    func addMessage() {
        
    }
    
    func showLike() {
        
    }
    
    func postKeyboardEvent(key: CGKeyCode) {
        KeyboardEvent.postKeyboardEvent(key: key)
    }
}
