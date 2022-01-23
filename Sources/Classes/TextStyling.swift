//
//  TextStyling.swift
//  RichEditor
//
//  Created by William Lumley on 20/3/18.
//  Copyright © 2018 William Lumley. All rights reserved.
//

import Foundation
import AppKit

public struct TextStyling {

    public private(set) var isBold  : Bool
    public private(set) var isUnbold: Bool
    
    public private(set) var isItalic  : Bool
    public private(set) var isUnitalic: Bool
    
    public private(set) var isUnderline  : Bool
    public private(set) var isUnunderline: Bool

    public private(set) var isStrikethrough  : Bool
    public private(set) var isUnstrikethrough: Bool
    
    public private(set) var fonts: [NSFont]
    public private(set) var alignments: [NSTextAlignment]

    public private(set) var textColours     : [NSColor]
    public private(set) var highlightColours: [NSColor]

    public var boldTrait: TextStyling.Trait {
        //If we're ONLY bold
        if self.isBold && !self.isUnbold {
            return .isTrait
        }
        
        //If we're ONLY unbold
        else if !self.isBold && self.isUnbold {
            return .isNotTrait
        }
            
        //If we're BOTH bold and unbold
        else if self.isBold && self.isUnbold {
            return .both
        }
        
        fatalError("Failed to reach conclusion for BoldTrait, for TextStyling: \(self)")
    }

    public var italicsTrait: TextStyling.Trait {
        //If we're ONLY italic
        if self.isItalic && !self.isUnitalic {
            return .isTrait
        }
            
        //If we're ONLY unitalic
        else if !self.isItalic && self.isUnitalic {
            return .isNotTrait
        }
            
        //If we're BOTH italic and unitalic
        else if self.isItalic && self.isUnitalic {
            return .both
        }
        
        fatalError("Failed to reach conclusion for ItalicTrait, for TextStyling: \(self)")
    }

    public var underlineTrait: TextStyling.Trait {
        //If we're ONLY underline
        if self.isUnderline && !self.isUnunderline {
            return .isTrait
        }
            
        //If we're ONLY un-underline
        else if !self.isUnderline && self.isUnunderline {
            return .isNotTrait
        }
        
        //If we're BOTH underline and un-underline
        else if self.isUnderline && self.isUnunderline {
            return .both
        }
        
        fatalError("Failed to reach conclusion for UnderlineTrait, for TextStyling: \(self)")
    }
    
    public var strikethroughTrait: TextStyling.Trait {
        //If we're ONLY strikethrough
        if self.isStrikethrough && !self.isUnstrikethrough {
            return .isTrait
        }
            
        //If we're ONLY un-strikethrough
        else if !self.isStrikethrough && self.isUnstrikethrough {
            return .isNotTrait
        }
            
        //If we're BOTH strikethrough and un-strikethrough
        else if self.isStrikethrough && self.isUnstrikethrough {
            return .both
        }
        
        fatalError("Failed to reach conclusion for StrikethroughTrait, for TextStyling: \(self)")
    }
    
    // MARK: - TextStyling
    
    init(attributedString: NSAttributedString) {
        self.textColours = attributedString.allTextColours
        
        self.isBold   = attributedString.contains(trait: .boldFontMask)
        self.isUnbold = attributedString.doesNotContain(trait: .boldFontMask)
        
        self.isItalic   = attributedString.contains(trait: .italicFontMask)
        self.isUnitalic = attributedString.doesNotContain(trait: .italicFontMask)
        
        let underlineQualities = attributedString.check(attribute: NSAttributedString.Key.underlineStyle) {(rawValueAttr) -> Bool in
            return rawValueAttr == 0
        }
        self.isUnderline   = underlineQualities.atParts
        self.isUnunderline = underlineQualities.notAtParts
        
        let strikethroughQualities = attributedString.check(attribute: NSAttributedString.Key.strikethroughStyle) {(rawValueAttr) -> Bool in
            return rawValueAttr == 0
        }
        self.isStrikethrough   = strikethroughQualities.atParts
        self.isUnstrikethrough = strikethroughQualities.notAtParts
        
        self.textColours      = attributedString.allTextColours
        self.highlightColours = attributedString.allHighlightColours
        
        self.fonts = attributedString.allFonts
        self.alignments = attributedString.allAlignments
    }
    
    init(typingAttributes: [NSAttributedString.Key: Any]) {
        let font = typingAttributes[NSAttributedString.Key.font] as! NSFont
        
        self.isBold   = font.contains(trait: .boldFontMask)
        self.isUnbold = !self.isBold
        
        self.isItalic   = font.contains(trait: .italicFontMask)
        self.isUnitalic = !self.isItalic
        
        self.isUnderline = typingAttributes.check(attribute: NSAttributedString.Key.underlineStyle) {(rawAttr) -> Bool in
            return rawAttr == 0
        }
        self.isUnunderline = !self.isUnderline

        self.isStrikethrough = typingAttributes.check(attribute: NSAttributedString.Key.strikethroughStyle) {(rawAttr) -> Bool in
            return rawAttr == 0
        }
        self.isUnstrikethrough = !self.isStrikethrough

        self.textColours      = []
        self.highlightColours = []
        
        self.fonts = []
        self.alignments = []

        if let textColour = typingAttributes[NSAttributedString.Key.foregroundColor] as? NSColor {
            self.textColours = [textColour]
        }

        if let highlightColour = typingAttributes[NSAttributedString.Key.backgroundColor] as? NSColor {
            self.highlightColours = [highlightColour]
        }

        if let font = typingAttributes[NSAttributedString.Key.font] as? NSFont {
            self.fonts = [font]
        }

        if let paragraphStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
            self.alignments = [paragraphStyle.alignment]
        }

        //print("Typing Attributes: \(typingAttributes)")
    }
    
    // MARK: - Functions
    
    /**
     Given an NSFontTraitMask, matches the correlating Trait enum that correlates with the provided argument
     - parameter nsFontTraitMask: The NSFontTraitMask that we need to match to a Trait enum
     - returns: A Trait enum that will correlate with the NSFontTraitMask
    */
    public func fontTraitFor(nsFontTraitMask: NSFontTraitMask) -> TextStyling.Trait {
        switch (nsFontTraitMask) {
            case .boldFontMask:
                return self.boldTrait
            case .italicFontMask:
                return self.italicsTrait
            default:
                fatalError("Failed to reach conclusion for determining correlating Trait and NSFontTraitMask. NSFontTraitMask: \(nsFontTraitMask)")
        }
    }

    public func trait(with key: NSAttributedString.Key) -> TextStyling.Trait {
        switch (key) {
        case .strikethroughStyle:
            return self.strikethroughTrait

        case .underlineStyle:
            return self.underlineTrait

        default:
            fatalError("NSAttributedString.Key has not been accounted for in Trait determination: \(key).")
        }
    }

}

public extension TextStyling {

    enum Trait {
        case isTrait
        case isNotTrait
        case both
    }

}
