//
//  KeyboardEvent.swift
//  NiconicoPresentation
//
//  Created by bugttle on 3/7/15.
//  Copyright © 2015 bugttle. All rights reserved.
//

import Foundation

class KeyboardEvent: NSObject {
    // Reference: <Carbon/Carbon.h>
    static let LeftArrow: CGKeyCode = 0x7B  //kVK_LeftArrow                 = 0x7B,
    static let RightArrow: CGKeyCode = 0x7C //kVK_RightArrow                = 0x7C,
    static let DownArrow: CGKeyCode = 0x7D  //kVK_DownArrow                 = 0x7D,
    static let UpArrow: CGKeyCode = 0x7E    //kVK_UpArrow                   = 0x7E

    static func postKeyboardEvent(key: CGKeyCode) {
        let source = CGEventSource(stateID: .hidSystemState)
        
        let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
        let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)
        
        keyDownEvent?.post(tap: .cghidEventTap)
        keyUpEvent?.post(tap: .cghidEventTap)
    }
}
