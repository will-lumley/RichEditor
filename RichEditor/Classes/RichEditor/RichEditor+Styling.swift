//
//  RichEditor+Styling.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

public extension RichEditor {

    /**
     Toggles the bold attribute for the selected text, or the future text if no text is selected
    */
    func toggleBold() {
        self.toggleTextView(with: .boldFontMask)
    }

    /**
     Toggles the italics attribute for the selected text, or the future text if no text is selected
    */
    func toggleItalic() {
        self.toggleTextView(with: .italicFontMask)
    }
    
    /**
     Toggles the underline attribute for the selected text, or the future text if no text is selected
     - parameter style: The style of the underline that we want
    */
    func toggleUnderline(_ style: NSUnderlineStyle) {
        self.toggleTextView(with: .underlineStyle, negativeValue: 0, positiveValue: style.rawValue)
    }
    
    /**
     Toggles the strikethrough attribute for the selected text, or the future text if no text is selected
     - parameter style: The style of the strikethrough that we want
    */
    func toggleStrikethrough(_ style: NSUnderlineStyle) {
        self.toggleTextView(with: .strikethroughStyle, negativeValue: 0, positiveValue: style.rawValue)
    }
    
    /**
     Applies the text colour for the selected text, or the future text if no text is selected
    */
    func apply(textColour: NSColor) {
        let colourAttr = [NSAttributedString.Key.foregroundColor: textColour]
        self.add(attributes: colourAttr, onlyHighlightedText: self.textView.hasSelectedText)
    }
    
    /**
     Applies the highlight colour for the selected text, or the future text if no text is selected
    */
    func apply(highlightColour: NSColor) {
        let colourAttr = [NSAttributedString.Key.backgroundColor: highlightColour]
        self.add(attributes: colourAttr, onlyHighlightedText: self.textView.hasSelectedText)
    }
    
    /**
     Applies the font for the selected text, or the future text if no text is selected
    */
    func apply(font: NSFont) {
        let fontAttr = [NSAttributedString.Key.font: font]
        self.add(attributes: fontAttr, onlyHighlightedText: self.textView.hasSelectedText)
    }

}
