//
//  NSScreen+DisplayName.swift
//  NiconicoPresentationPlayer
//
//  Created by Ryo Tsuruda on 2/22/19.
//  Copyright © 2019 bugttle. All rights reserved.
//

import AppKit

extension NSScreen {
    func displayName() -> String? {
        var name: String? = nil
        var object : io_object_t
        var serialPortIterator = io_iterator_t()
        let matching = IOServiceMatching("IODisplayConnect")
        
        let kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &serialPortIterator)
        guard kernResult == KERN_SUCCESS && serialPortIterator != 0 else {
            return nil
        }
        repeat {
            object = IOIteratorNext(serialPortIterator)
            let info = IODisplayCreateInfoDictionary(object, UInt32(kIODisplayOnlyPreferredName)).takeRetainedValue() as NSDictionary as! [String:AnyObject]
            if let productNames = info["DisplayProductName"] as? [String:String],
                let productName = productNames.first?.value {
                name = productName
                break
            }
            
        } while object != 0
        IOObjectRelease(serialPortIterator)
        return name
    }
}
