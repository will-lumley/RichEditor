//
//  RichEditor+Styling.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import AppKit

extension RichEditor {

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
        self.add(attributes: colourAttr, textApplicationType: self.textView.hasSelectedText ? .selected : .future)
    }
    
    /**
     Applies the highlight colour for the selected text, or the future text if no text is selected
    */
    func apply(highlightColour: NSColor) {
        let colourAttr = [NSAttributedString.Key.backgroundColor: highlightColour]
        self.add(attributes: colourAttr, textApplicationType: self.textView.hasSelectedText ? .selected : .future)
    }
    
    /**
     Applies the font for the selected text, or the future text if no text is selected
    */
    func apply(font: NSFont) {
        let fontAttr = [NSAttributedString.Key.font: font]
        self.add(attributes: fontAttr, textApplicationType: self.textView.hasSelectedText ? .selected : .future)
    }

    /**
     Applies the font for the selected text, or the future text if no text is selected
    */
    func apply(alignment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        let paragraphStyleAttr = [NSAttributedString.Key.paragraphStyle: paragraphStyle]

        // Apply this alignment to the paragraph the user is in, or the paragraph the user is highlighting
        let paragraphRange = self.textView.string.nsString.paragraphRange(for: self.textView.selectedRange())

        // Apply the text alignment to the current paragraph, and future paragraphs
        self.add(attributes: paragraphStyleAttr, textApplicationType: .range(range: paragraphRange))
        self.add(attributes: paragraphStyleAttr, textApplicationType: .future)
    }

}
