//
//  NS(Attributed)String+Geometrics.swift
//  Tumbleweed
//
//  Created by Chloe Stars on 7/21/15.
//  Copyright © 2015 Chloe Stars. All rights reserved.
//  Fixed 10/25/18 for Swift 4.
//  Original credit : Jerry Krinock https://github.com/jerrykrinock/CategoriesObjC
//

import Cocoa

var gNSStringGeometricsTypesetterBehavior = NSLayoutManager.TypesetterBehavior.latestBehavior

extension NSAttributedString {
    func sizeForWidth(width: CGFloat, height: CGFloat) -> NSSize {
        var answer = NSZeroSize
        if self.length > 0 {
            let size = NSMakeSize(width, height)
            let textContainer = NSTextContainer(containerSize: size)
            let textStorage = NSTextStorage(attributedString: self)
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            layoutManager.hyphenationFactor = 0.0
            if gNSStringGeometricsTypesetterBehavior != NSLayoutManager.TypesetterBehavior.latestBehavior {
                layoutManager.typesetterBehavior = NSLayoutManager.TypesetterBehavior.latestBehavior
            }
            layoutManager.glyphRange(for: textContainer)
            
            answer = layoutManager.usedRect(for: textContainer).size
            
            let extraLineSize = layoutManager.extraLineFragmentRect.size
            if extraLineSize.height > 0 {
                answer.height -= extraLineSize.height
            }
            
            gNSStringGeometricsTypesetterBehavior = NSLayoutManager.TypesetterBehavior.latestBehavior
        }
        
        return answer
    }
    
    func heightForWidth(width: CGFloat) -> CGFloat {
        return self.sizeForWidth(width: width, height: CGFloat(Float.greatestFiniteMagnitude)).height
    }
    
    func widthForHeight(height: CGFloat) -> CGFloat {
        return self.sizeForWidth(width: CGFloat(Float.greatestFiniteMagnitude), height: height).width
    }
}
