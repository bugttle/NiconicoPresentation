//
//  LikeManager.swift
//  NiconicoPresentationPlayer
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
        self.likeCountTextField = self.createTextField(count: 0)
    }
    
    private func createTextField(count: Int) -> NSTextField {
        let text = NSTextField(frame: NSMakeRect(70, 30, 200, 40))
        text.font = NSFont.systemFont(ofSize: 40.0)
        text.isBezeled = false
        text.drawsBackground = false
        text.isEditable = false
        text.isSelectable = false
        text.usesSingleLineMode = true
        
        self.setCount(text: text, count: count)
        
        self.window.contentView?.addSubview(text)
        
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
        imageView.image = NSImage(named: "Like")
        
        var frame = imageView.frame
        frame.size = CGSize(width: 201, height: 160)
        imageView.frame = frame
        
        self.window.contentView?.addSubview(imageView)
        
//        var v = self.window.contentView
//        var a = self.window.contentView?.frame
//        self.window.contentView?.addSubview(imageView)
//        self.window.contentView?.addSubview(imageView, positioned: .below, relativeTo: self.likeCountTextField)
        
        self.setCount(text: self.likeCountTextField, count: count)
        
//        self.animate(imageView: imageView, textView: self.likeCountTextField, duration: TimeInterval(AnimationDuration))
    }
}
