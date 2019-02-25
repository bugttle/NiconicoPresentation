//
//  NSScreen+DisplayName.swift
//  NiconicoPresentationPlayer
//
//  Created by Ryo Tsuruda on 2/22/19.
//  Copyright © 2019 bugttle. All rights reserved.
//

import Cocoa

extension NSScreen {
    public var displayID: CGDirectDisplayID {
        get {
            let key = NSDeviceDescriptionKey("NSScreenNumber")
            return self.deviceDescription[key] as! CGDirectDisplayID
        }
    }
    
    
    public var displayName: String {
        get {
            var name = "Unknow"
            var object : io_object_t
            var serialPortIterator = io_iterator_t()
            let matching = IOServiceMatching("IODisplayConnect")
            
            let kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &serialPortIterator)
            if kernResult == KERN_SUCCESS && serialPortIterator != 0 {
                repeat {
                    object = IOIteratorNext(serialPortIterator)
                    let displayInfo = IODisplayCreateInfoDictionary(object, UInt32(kIODisplayOnlyPreferredName)).takeRetainedValue() as NSDictionary as! [String:AnyObject]
                    
                    guard
                        displayInfo[kDisplayVendorID] as? UInt32 == CGDisplayVendorNumber(self.displayID),
                        displayInfo[kDisplayProductID] as? UInt32 == CGDisplayModelNumber(self.displayID),
                        displayInfo[kDisplaySerialNumber] as? UInt32 ?? 0 == CGDisplaySerialNumber(self.displayID)
                    else {
                        continue
                    }
                    if let productName = displayInfo["DisplayProductName"] as? [String:String],
                        let firstKey = Array(productName.keys).first {
                        name = productName[firstKey]!
                        break
                    }
                } while object != 0
            }
            IOObjectRelease(serialPortIterator)
            return name
        }
    }    
}
