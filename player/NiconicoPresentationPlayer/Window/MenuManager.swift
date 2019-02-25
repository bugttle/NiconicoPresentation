//
//  MenuManager.swift
//  NiconicoPresentationPlayer
//
//  Created by bugttle on 3/7/15.
//  Copyright © 2015 bugttle. All rights reserved.
//

import Foundation
import Cocoa

class MenuManager: NSObject {
    var menu: NSMenu!
    var action: Selector!
    
    init(menu: NSMenu, action: Selector) {
        super.init()
        
        self.menu = menu
        self.action = action
        self.registerForDisplayChangeNotifications()

        self.updateScreenNames()
    }
    
    func updateScreenNames() {
        let displayID = NSScreen.main?.displayID
        
        let screens = NSScreen.screens
        for i in 0 ..< screens.count {
            let screen = screens[i]
            let number = i + 1
            let item = NSMenuItem(title: String(format: "%d: %@", number, screen.displayName),
                                  action: (screen.displayID == displayID) ? nil : self.action,
                                  keyEquivalent: String(format: "%d", number))
            item.tag = i
            
            self.menu.insertItem(item, at: i)
        }
    }
    
    @objc func handleDisplayChanges(notification: NSNotification) {
        self.menu.items.removeAll()
        self.updateScreenNames()
    }
    
    func registerForDisplayChangeNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDisplayChanges(notification:)),
                                               name: NSNotification.Name(rawValue: "NSWindowDidChangeScreenNotification"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDisplayChanges(notification:)),
                                               name: NSNotification.Name(rawValue: "NSApplicationDidChangeScreenParametersNotification"),
                                               object: nil)
    }
    
}
