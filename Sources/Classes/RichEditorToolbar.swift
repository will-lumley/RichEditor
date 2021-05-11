//
//  RichEditorToolbar.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import AppKit

class RichEditorToolbar: NSView {

    // MARK: - Properties

    

    // MARK: - NSView
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }
    
    /**
     Perform the initial setup operations to get a functional NSTextView running
    */
    fileprivate func setup() {
        self.layer?.backgroundColor = NSColor.red.cgColor
    }

}
