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
        
        for i in 0 ..< NSScreen.screens.count {
            let number = i + 1
            let item = NSMenuItem(title: String(format: "Screen %d", number),
                                  action: action,
                                  keyEquivalent: String(format: "%d", number))
            item.tag = i
            
            menu.insertItem(item, at: i)
        }
    }
}
