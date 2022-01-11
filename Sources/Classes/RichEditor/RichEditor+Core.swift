//
//  RichEditor+Core.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

enum TextApplicationType {
    case selected
    case range(range: NSRange)
    case future
}

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
        print("NewFont: \(newFont)")

        let updatedFontAttr = [NSAttributedString.Key.font: newFont]
        self.add(attributes: updatedFontAttr, textApplicationType: self.textView.hasSelectedText ? .selected : .future)

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
        // If this attribute is a font trait
        if let fontTrait = self.fontStyling.trait(with: attribute) {
            var newAttr = [NSAttributedString.Key: Any]()
            switch (fontTrait) {
                case .hasTrait:
                    newAttr = [attribute: negativeValue]
                
                case .hasNoTrait:
                    newAttr = [attribute: positiveValue]
                
                case .both:
                    newAttr = [attribute: positiveValue]
            }

            let applicationType = self.textView.hasSelectedText ? TextApplicationType.selected : TextApplicationType.future
            self.add(attributes: newAttr, textApplicationType: applicationType)
        }

        // If this is a paragraph style
        else if attribute == .paragraphStyle {
            let paragraphRange = self.textView.string.nsString.paragraphRange(for: self.textView.selectedRange())
            self.add(attributes: [attribute: positiveValue], textApplicationType: .range(range: paragraphRange))
        }

        // If this is something else
        else {
            self.add(attributes: [attribute: positiveValue], textApplicationType: .future)
        }

        self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
        self.toolbarRichEditorDelegate?.fontStylingChanged(self.fontStyling)
    }
    
    /**
     Adds the provided NSAttributedString.Key attributes to the TextView. The attributes will either
     be applied to the text that is selected, or to all 'future' text. This is dependant on the
     selected argument.
     - parameter attributes: The attributes that we wish to apply to our NSTextView
     - parameter textApplicationType: Determines how the effects of the NSAttributedString.Key will be applied to our TextViews string
    */
    func add(attributes: [NSAttributedString.Key: Any], textApplicationType: TextApplicationType) {

        switch textApplicationType {
        case .selected:
            let selectedRange = self.textView.selectedRange()
            
            self.textStorage.addAttributes(attributes, range: selectedRange)
            
            //Create an attributed string out of ONLY the highlighted text
            guard let attr = self.textView.attributedSubstring(forProposedRange: selectedRange, actualRange: nil) else {
                return
            }
            
            //Ensure the UI is updated with the new FontStyling state's
            self.selectedTextFontStyling = FontStyling(attributedString: attr)

        case .range(let range):
            self.textStorage.addAttributes(attributes, range: range)
            
            //Create an attributed string out of ONLY the highlighted text
            guard let attr = self.textView.attributedSubstring(forProposedRange: range, actualRange: nil) else {
                return
            }
            
            //Ensure the UI is updated with the new FontStyling state's
            self.selectedTextFontStyling = FontStyling(attributedString: attr)

        case .future:
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
