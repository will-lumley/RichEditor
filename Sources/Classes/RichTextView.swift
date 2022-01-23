//
//  RichTextView.swift
//  RichEditor
//
//  Created by William Lumley on 6/2/20.
//

import Foundation

internal protocol KeyboardShortcutDelegate {

    func commandPressed(character: RichEditor.CommandShortcut) -> Bool

}

public class RichTextView: NSTextView {

    // MARK: - Properties

    /// Allows the RichEditor to be aware of keyboard presses
    internal private(set) var keyboardShortcutDelegate: KeyboardShortcutDelegate?

    // MARK: - NSTextView

    init(frame frameRect: NSRect, textContainer container: NSTextContainer?, delegate: KeyboardShortcutDelegate) {
        self.keyboardShortcutDelegate = delegate
        super.init(frame: frameRect, textContainer: container)
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    fileprivate func setup() {
        if #available(OSX 10.14, *) {
            self.usesAdaptiveColorMappingForDarkAppearance = true
        }
    }

    override public func performKeyEquivalent(with event: NSEvent) -> Bool {
        // Only process our event if it's a keydown event
        if event.type != .keyDown {
            return super.performKeyEquivalent(with: event)
        }
        
        //If the command button was NOT pressed down
        if !event.modifierFlags.contains(.command) {
            return super.performKeyEquivalent(with: event)
        }
        
        guard let characters = event.charactersIgnoringModifiers else {
            return super.performKeyEquivalent(with: event)
        }

        guard let shortcut = RichEditor.CommandShortcut(rawValue: characters) else {
            return super.performKeyEquivalent(with: event)
        }

        guard let delegate = self.keyboardShortcutDelegate else {
            return super.performKeyEquivalent(with: event)
        }

        return delegate.commandPressed(character: shortcut)
    }
}
