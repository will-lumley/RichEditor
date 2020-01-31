//
//  FontStyling.swift
//  RichEditor
//
//  Created by William Lumley on 20/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

public enum FontTrait
{
    case hasTrait
    case hasNoTrait
    case both
}

public struct FontStyling
{
    public fileprivate(set) var isBold  : Bool
    public fileprivate(set) var isUnbold: Bool
    
    public fileprivate(set) var isItalic  : Bool
    public fileprivate(set) var isUnitalic: Bool
    
    public fileprivate(set) var isUnderline  : Bool
    public fileprivate(set) var isUnunderline: Bool

    public fileprivate(set) var isStrikethrough  : Bool
    public fileprivate(set) var isUnstrikethrough: Bool
    
    public fileprivate(set) var fonts: [NSFont]
    
    public fileprivate(set) var textColours     : [NSColor]
    public fileprivate(set) var highlightColours: [NSColor]
    
    //MARK: - FontStyling
    init(attributedString: NSAttributedString)
    {
        self.textColours = attributedString.allTextColours()
        
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
        
        self.textColours      = attributedString.allTextColours()
        self.highlightColours = attributedString.allHighlightColours()
        
        self.fonts = attributedString.allFonts()
    }
    
    init(typingAttributes: [NSAttributedString.Key: Any])
    {
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

        if let textColour = typingAttributes[NSAttributedString.Key.foregroundColor] as? NSColor {
            self.textColours = [textColour]
        }

        if let highlightColour = typingAttributes[NSAttributedString.Key.backgroundColor] as? NSColor {
            self.highlightColours = [highlightColour]
        }

        if let font = typingAttributes[NSAttributedString.Key.font] as? NSFont {
            self.fonts = [font]
        }

        //print("Typing Attributes: \(typingAttributes)")
    }
    
    //MARK: - Functions
    /**
     Given an NSFontTraitMask, matches the correlating FontTrait enum that correlates with the provided argument
     - parameter nsFontTraitMask: The NSFontTraitMask that we need to match to a FontTrait enum
     - returns: A FontTrait enum that will correlate with the NSFontTraitMask
    */
    public func fontTraitFor(nsFontTraitMask: NSFontTraitMask) -> FontTrait
    {
        switch (nsFontTraitMask) {
            case .boldFontMask:
                return self.boldTrait()
            
            case .italicFontMask:
                return self.italicsTrait()
            
            default:
                fatalError("Failed to reach conclusion for determining correlating FontTrait and NSFontTraitMask. NSFontTraitMask: \(nsFontTraitMask)")
        }
    }
    
    public func boldTrait() -> FontTrait
    {
        //If we're ONLY bold
        if self.isBold && !self.isUnbold {
            return FontTrait.hasTrait
        }
        
        //If we're ONLY unbold
        else if !self.isBold && self.isUnbold {
            return FontTrait.hasNoTrait
        }
            
        //If we're BOTH bold and unbold
        else if self.isBold && self.isUnbold {
            return FontTrait.both
        }
        
        fatalError("Failed to reach conclusion for BoldTrait, for FontStyling: \(self)")
    }

    public func italicsTrait() -> FontTrait
    {
        //If we're ONLY italic
        if self.isItalic && !self.isUnitalic {
            return FontTrait.hasTrait
        }
            
        //If we're ONLY unitalic
        else if !self.isItalic && self.isUnitalic {
            return FontTrait.hasNoTrait
        }
            
        //If we're BOTH italic and unitalic
        else if self.isItalic && self.isUnitalic {
            return FontTrait.both
        }
        
        fatalError("Failed to reach conclusion for ItalicTrait, for FontStyling: \(self)")
    }

    public func underlineTrait() -> FontTrait
    {
        //If we're ONLY underline
        if self.isUnderline && !self.isUnunderline {
            return FontTrait.hasTrait
        }
            
        //If we're ONLY un-underline
        else if !self.isUnderline && self.isUnunderline {
            return FontTrait.hasNoTrait
        }
        
        //If we're BOTH underline and un-underline
        else if self.isUnderline && self.isUnunderline {
            return FontTrait.both
        }
        
        fatalError("Failed to reach conclusion for UnderlineTrait, for FontStyling: \(self)")
    }
    
    public func strikethroughTrait() -> FontTrait
    {
        //If we're ONLY strikethrough
        if self.isStrikethrough && !self.isUnstrikethrough {
            return FontTrait.hasTrait
        }
            
        //If we're ONLY un-strikethrough
        else if !self.isStrikethrough && self.isUnstrikethrough {
            return FontTrait.hasNoTrait
        }
            
        //If we're BOTH strikethrough and un-strikethrough
        else if self.isStrikethrough && self.isUnstrikethrough {
            return FontTrait.both
        }
        
        fatalError("Failed to reach conclusion for StrikethroughTrait, for FontStyling: \(self)")
    }
    
    public func trait(with key: NSAttributedString.Key) -> FontTrait
    {
        switch (key) {
            case .strikethroughStyle:
                return self.strikethroughTrait()
            
            case .underlineStyle:
                return self.underlineTrait()
            
            default:
                fatalError("NSAttributedString.Key has not been accounted for in FontTrait determination: \(key).")
        }
    }
}
