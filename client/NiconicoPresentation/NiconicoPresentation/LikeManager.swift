//
//  LikeManager.swift
//  NiconicoPresentation
//
//  Created by bugttle on 3/7/15.
//  Copyright © 2015 bugttle. All rights reserved.
//

import Foundation
import Cocoa

class LikeManager: NSObject {
    var window: NSWindow!
    let AnimationDuration: Float = 2.0
    var likeCountTextField: NSTextField!
    
    init(window: NSWindow) {
        super.init()
        self.window = window
        likeCountTextField = self.createTextField(count: 0)
    }    
    
    private func createTextField(count: Int) -> NSTextField {
        let text = NSTextField(frame: NSMakeRect(70, 30, 200, 40))
        text.font = NSFont.systemFont(ofSize: 40.0)
        text.isBezeled = false
        text.drawsBackground = false
        text.isEditable = false
        text.isSelectable = false
        text.usesSingleLineMode = true
        
        setCount(text: text, count: count)
        
        return text;
    }
    
    private func setCount(text: NSTextField, count: Int) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -3.0 as NSNumber,
            .strokeColor: NSColor.white,
            .foregroundColor: NSColor.black,
            ]
        text.attributedStringValue = NSAttributedString(string: String(format: "%ld", count),
                                                        attributes: attributes)
    }
    
    private func animate(imageView: NSView, textView: NSView, duration: TimeInterval) {
        // Image
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = duration
            let animator = imageView.animator()
            animator.frame = NSOffsetRect(imageView.frame, 0, 100)
            animator.alphaValue = 0.0
        }) {
            imageView.removeFromSuperview()
        }
        
        // Text
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = duration
            let animator = textView.animator()
            animator.alphaValue = 0.0
        }, completionHandler: nil)
    }
    
    func showLike(count: Int) {
        let imageView = NSImageView(frame: NSMakeRect(0, 0, 200, 171))
        imageView.image = NSImage(named: "FacebookLike")
        self.window.contentView?.addSubview(imageView, positioned: .below, relativeTo: likeCountTextField)
        
        setCount(text: likeCountTextField, count: count)
        
        self.animate(imageView: imageView, textView: likeCountTextField, duration: TimeInterval(AnimationDuration))
    }
}
