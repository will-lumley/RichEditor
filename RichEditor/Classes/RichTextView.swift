//
//  RichTextView.swift
//  RichEditor
//
//  Created by William Lumley on 6/2/20.
//

import Foundation

public class RichTextView: NSTextView
{
    //MARK: - NSTextView
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?)
    {
        super.init(frame: frameRect, textContainer: container)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
    }
    
    override public func performKeyEquivalent(with event: NSEvent) -> Bool
    {
        //Only process our event if it's a keydown event
        if event.type != .keyDown {
            return true
        }
        
        //If we've pressed our command button, let's see what other button was pressed
        if event.modifierFlags.contains(.command) {
            switch event.charactersIgnoringModifiers {
            case "b":
                print("CMD + B")
            default:()
            }
        }
        
        return true
    }
}
