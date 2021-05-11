//
//  RichEditor+Stack.swift
//  Nimble
//
//  Created by Will Lumley on 30/1/20.
//

import Foundation
import AppKit

// MARK: - NSTextView Stack
/**
 StackOverflow: https://stackoverflow.com/a/45947994
*/
extension RichEditor {

    /**
     Creates and configures the NSTextView, NSTextContainer, NSTextStorage and NSLayoutManager objects
     - parameter isHorizontalScrollingEnabled: If true, the NSTextView will allow horizontal scrolling
    */
    internal func configureTextView(isHorizontalScrollingEnabled: Bool) {
        self.textStorage.addLayoutManager(self.layoutManager)
        self.layoutManager.addTextContainer(self.textContainer)
        
        let contentSize = self.scrollview.contentSize
        
        if isHorizontalScrollingEnabled {
            self.textContainer.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                      height: CGFloat.greatestFiniteMagnitude)
            self.textContainer.widthTracksTextView = false
        }
        else {
            self.textContainer.containerSize = CGSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
            self.textContainer.widthTracksTextView = true
        }
        
        self.textView.minSize = CGSize(width: 0, height: 0)
        self.textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        self.textView.isVerticallyResizable = true
        self.textView.isHorizontallyResizable = isHorizontalScrollingEnabled
        self.textView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        if isHorizontalScrollingEnabled {
            textView.autoresizingMask = [.width, .height]
        }
        else {
            textView.autoresizingMask = [.width]
        }
        
        self.textView.allowsUndo = true
        
        self.scrollview.borderType = .noBorder
        self.scrollview.hasVerticalScroller = true
        self.scrollview.hasHorizontalScroller = isHorizontalScrollingEnabled
        self.scrollview.documentView = self.textView
    }

}
