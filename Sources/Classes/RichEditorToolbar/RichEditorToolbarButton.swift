//
//  RichEditorToolbarButton.swift
//  RichEditor
//
//  Created by William Lumley on 22/6/21.
//

import Cocoa

class RichEditorToolbarButton: NSButton {

    // MARK: - NSButton

    init(image: String) {
        super.init(frame: .zero)
        self.image = NSImage.podImage(named: image)

        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.isBordered = false

        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }

}
