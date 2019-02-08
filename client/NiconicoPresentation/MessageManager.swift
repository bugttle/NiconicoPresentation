//
//  MessageManager.swift
//  NiconicoPresentation
//
//  Created by Tsuruda, Ryo on 2018/10/25.
//  Copyright © 2018年 bugttle. All rights reserved.
//

import Foundation
import Cocoa

class MessageManager: NSObject {
    var window: NSWindow!
    let MaxMessageLine = 10
    let AnimationDuration: Float = 3.5
    var messageCounts: Array<Int> = Array()
    
    var count = 0
    
    init(window: NSWindow) {
        super.init()
        self.window = window
    }
    
    private var messageHight: CGFloat {
        get {
            let screen = self.window.screen!
            return screen.visibleFrame.size.height / CGFloat(MaxMessageLine);
        }
    }
    
    private func nextLeastIndex() -> Int {
        var index = 0
        var min = 0
        for (i, value) in self.messageCounts.enumerated() {
            if value < min {
                min = value
                index = i;
            }
        }
        self.messageCounts[index] += 1
        return index
    }
    
    private func createTextField(message: String, at: Int) -> NSTextField {
        let height = self.messageHight
        let frame = self.window.screen!.visibleFrame
        let rect = NSMakeRect(0, frame.size.height - height * CGFloat(at + 1), frame.size.width, height)
        let text = NSTextField(frame: rect)
        text.font = NSFont.systemFont(ofSize: height)
        text.stringValue = message
        text.isBezeled = false
        text.drawsBackground = false;
        text.isEditable = false
        text.isSelectable = false
        text.usesSingleLineMode = true
        text.wantsLayer = true
        
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -3.0 as NSNumber,
            .strokeColor: NSColor.white,
            .foregroundColor: NSColor.black,
            ]
        text.attributedStringValue = NSAttributedString(string: message, attributes: attributes)
        return text
    }
    
    private func animate(view: NSView, width: CGFloat, duration: Float, at: Int) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            view.removeFromSuperview()
            self.messageCounts[at] -= 1
        })
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = CFTimeInterval(duration)
        animation.fromValue = view.frame.size.width as NSNumber?
        animation.toValue = -width as NSNumber?
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        view.layer?.add(animation, forKey: "moveByAnimation")
        CATransaction.commit()
    }
    
    func addMessage(text: String) {
        let index = self.nextLeastIndex()
        let text = self.createTextField(message: text, at: index)
        self.window.contentView?.addSubview(text)
        
        let size = text.attributedStringValue.sizeForWidth(width: CGFloat.greatestFiniteMagnitude, height: self.messageHight)
        if text.frame.size.width < size.width {
            text.setFrameSize(NSMakeSize(size.width, text.frame.size.height))
        }
        
        self.animate(view: text, width: size.width, duration: AnimationDuration, at: index)
    }
}
