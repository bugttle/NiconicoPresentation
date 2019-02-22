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
    init(menu: NSMenu, action: Selector) {
        super.init()
        
        let screens = NSScreen.screens
        for i in 0 ..< screens.count {
            let number = i + 1
            let a = screens[i].deviceDescription
            
            let displayName = screens[i].displayName()
            let item = NSMenuItem(title: String(format: "%d: %@", i, (displayName != nil) ? displayName! : "Unknown"),
                                  action: action,
                                  keyEquivalent: String(format: "%d", number))
            item.tag = i
            
            menu.insertItem(item, at: i)
        }
    }
}
