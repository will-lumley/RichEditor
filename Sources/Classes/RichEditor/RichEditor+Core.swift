//
//  RichEditor+Core.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

internal extension RichEditor {

    /**
     Toggles a certain font trait (bold, italic, etc) for the RichTextView.
     If text is highlighted, then only the highlighted text will have its font toggled. If no text is highlighted
     then all 'future' text will have the new traits.
     
     - parameter trait: This is the trait that you want the font to adhere to
    */
    func toggleTextView(with fontTrait: NSFontTraitMask) {
        //Get the current font, and make a 'new' version of it, with the traits provided to us
        let currentFont = self.currentFont
        var newFont     = currentFont
        
        let fontStyling = self.fontStyling
        let fontStylingTrait = fontStyling.fontTraitFor(nsFontTraitMask: fontTrait)
        
        print("\nOldFont: \(currentFont)")
        switch (fontStylingTrait) {
            //If we're ONLY bold at the moment, let's make it unbold
            case .hasTrait:
                newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: fontTrait)
            
            //If we're ONLY unbold at the moment, let's make it bold
            case .hasNoTrait:
                newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: fontTrait)
            
            //If we're BOTH bold and unbold, we'll make it bold
            case .both:
                newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: fontTrait)
        }
        print("NewFont: \(newFont)\n")
        
        let updatedFontAttr = [NSAttributedString.Key.font: newFont]
        self.add(attributes: updatedFontAttr, onlyHighlightedText: self.textView.hasSelectedText)
        
        self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
        self.toolbarRichEditorDelegate?.fontStylingChanged(self.fontStyling)
    }
    
    /**
     Toggles a certain NSAttributeString.Key (underline, strikethrough, etc) for the RichTextView.
     If text is highlighted, then only the highlighted text will have its NSAttributedText toggled.
     If no text is highlighted then all 'future' text will have the new attributes.
     
     - parameter attribute: This is the trait that you want the NSAttributedString to adhere to
     - parameter negativeValue: This is the 'off' value for the attribute. If `attribute` was
     NSUnderlineStyle, then the negativeValue would be NSUnderlineStyle.styleNone.rawValue
     - parameter positiveValue: This is the 'on' value for the attribute. If `attribute` was
     NSUnderlineStyle, then the positive would be NSUnderlineStyle.styleSingle.rawValue
    */
    func toggleTextView(with attribute: NSAttributedString.Key, negativeValue: Any, positiveValue: Any) {
        let trait = self.fontStyling.trait(with: attribute)
        
        var newAttr = [NSAttributedString.Key: Any]()
        switch (trait) {
            case .hasTrait:
                newAttr = [attribute: negativeValue]
            
            case .hasNoTrait:
                newAttr = [attribute: positiveValue]
            
            case .both:
                newAttr = [attribute: positiveValue]
        }
        
        self.add(attributes: newAttr, onlyHighlightedText: self.textView.hasSelectedText)
        self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
        self.toolbarRichEditorDelegate?.fontStylingChanged(self.fontStyling)
    }
    
    /**
     Adds the provided NSAttributedString.Key attributes to the TextView. The attributes will either
     be applied to the text that is selected, or to all 'future' text. This is dependant on the
     onlyHighlightedText argument.
     - parameter attributes: The attributes that we wish to apply to our NSTextView
     - parameter onlyHighlightedText: If true, the attributes will be applied to only the highlighted
     text. If false, the attributes will be applied to all 'future' text
    */
    func add(attributes: [NSAttributedString.Key: Any], onlyHighlightedText: Bool) {
        //If we're only modifying the text that's highlighted
        if onlyHighlightedText {
            let selectedRange = self.textView.selectedRange()
            
            self.textStorage.addAttributes(attributes, range: selectedRange)
            
            //Create an attributed string out of ONLY the highlighted text
            guard let attr = self.textView.attributedSubstring(forProposedRange: selectedRange, actualRange: nil) else {
                return
            }
            
            //Ensure the UI is updated with the new FontStyling state's
            self.selectedTextFontStyling = FontStyling(attributedString: attr)
        }
        
        //If we're modifying all 'future' text
        else {
            //Get the existing TypingAttributes, and merge it into our new attributes dictionary
            var typingAttributes = self.textView.typingAttributes
            //print("Old TypingAttributes: \(typingAttributes)")
            
            typingAttributes.merge(newDict: attributes)
            //print("New TypingAttributes: \(typingAttributes)\n")
            
            self.textView.typingAttributes = typingAttributes
        }
        
        self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
        self.toolbarRichEditorDelegate?.fontStylingChanged(self.fontStyling)
    }

}
