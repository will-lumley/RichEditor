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
        
        let textStyling = self.textStyling
        let textStylingTrait = textStyling.fontTraitFor(nsFontTraitMask: fontTrait)

        //print("\nOldFont: \(currentFont)")
        switch (textStylingTrait) {
            //If we're ONLY bold at the moment, let's make it unbold
            case .isTrait:
                newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: fontTrait)
            
            //If we're ONLY unbold at the moment, let's make it bold
            case .isNotTrait:
                newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: fontTrait)

            //If we're BOTH bold and unbold, we'll make it bold
            case .both:
                newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: fontTrait)
        }
        //print("NewFont: \(newFont)\n")

        let updatedFontAttr = [NSAttributedString.Key.font: newFont]
        self.add(attributes: updatedFontAttr, textApplicationType: self.textView.hasSelectedText ? .selected : .future)

        self.richEditorDelegate?.fontStylingChanged(self.textStyling)
        self.toolbarRichEditorDelegate?.fontStylingChanged(self.textStyling)
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
     - parameter range: This is a property that allows users to override the default range that the attribute will be applied to, and to choose their own custom range.
    */
    func toggleTextView(with attribute: NSAttributedString.Key, negativeValue: Any, positiveValue: Any, range: NSRange? = nil) {
        let fontTrait = self.textStyling.trait(with: attribute)

        var newAttr = [NSAttributedString.Key: Any]()
        switch (fontTrait) {
            case .isTrait:
                newAttr = [attribute: negativeValue]
            
            case .isNotTrait:
                newAttr = [attribute: positiveValue]
            
            case .both:
                newAttr = [attribute: positiveValue]
        }

        // If the user has highlighted text, apply it to that range
        // If the user has not highlighted text, apply it to all future text
        // If the user has provided a range, use that instead
        var type: TextApplicationType = self.textView.hasSelectedText ? .selected : .future
        if let range = range {
            type = .range(range: range)
        }

        self.add(attributes: newAttr, textApplicationType: type)

        self.richEditorDelegate?.fontStylingChanged(self.textStyling)
        self.toolbarRichEditorDelegate?.fontStylingChanged(self.textStyling)
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

            //Ensure the UI is updated with the new TextStyling state's
            self.selectedTextFontStyling = TextStyling(attributedString: attr)

        case .range(let range):
            self.textStorage.addAttributes(attributes, range: range)
            
            //Create an attributed string out of ONLY the highlighted text
            guard let attr = self.textView.attributedSubstring(forProposedRange: range, actualRange: nil) else {
                return
            }
            
            //Ensure the UI is updated with the new TextStyling state's
            self.selectedTextFontStyling = TextStyling(attributedString: attr)

        case .future:
            //Get the existing TypingAttributes, and merge it into our new attributes dictionary
            var typingAttributes = self.textView.typingAttributes
            //print("Old TypingAttributes: \(typingAttributes)")

            typingAttributes.merge(newDict: attributes)
            //print("New TypingAttributes: \(typingAttributes)\n")
            
            self.textView.typingAttributes = typingAttributes

        }
        
        self.richEditorDelegate?.fontStylingChanged(self.textStyling)
        self.toolbarRichEditorDelegate?.fontStylingChanged(self.textStyling)
    }

}
