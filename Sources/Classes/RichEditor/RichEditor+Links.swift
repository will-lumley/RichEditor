//
//  RichEditor+Links.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

public extension RichEditor {

    /**
     Inserts a clickable link into the NSTextView
     - parameter link: The URI/URL that will be opened upon the clicking of this link
     - parameter name: The text that will be displayed to the user
     - parameter position: The location of the NSTextView's string where the link will be
     inserted. If nil, the cursors position is used instead.
     */
    func insert(link: String, with name: String, at position: Int? = nil) {
        let attrString = NSMutableAttributedString(string: name)
        attrString.addAttribute(NSAttributedString.Key.link, value: link, range: name.fullRange)
        
        let insertionPosition = position ?? self.textView.selectedRange().location
        self.textView.textStorage!.insert(attrString, at: insertionPosition)
    }

}
