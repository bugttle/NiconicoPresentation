//
//  SystemStatusBar.swift
//  NiconicoPresentation
//
//  Created by Tsuruda, Ryo on 2018/10/25.
//  Copyright © 2018年 bugttle. All rights reserved.
//

import Foundation
import Cocoa

class StatusBarManager: NSObject {
    var statusItem: NSStatusItem!
    
    init(menu: NSMenu) {
        super.init()
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem.highlightMode = true;
        self.statusItem.title = ""
        self.statusItem.image = NSImage(named: "SystemIcon")
        self.statusItem.menu = menu
    }
}
