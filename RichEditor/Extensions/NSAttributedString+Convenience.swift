//
//  NSAttributedString+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 20/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension NSAttributedString
{
    /**
     Determines the attributes for the whole complete NSAttributedString
     - returns: The attributes, in the form of a dictionary, for the whole NSAttributedString
     */
    public var attributes: [NSAttributedString.Key: Any] {
        return self.attributes(at: 0, longestEffectiveRange: nil, in: self.string.fullRange)
    }
    
    //MARK: - Basic Attribute Fetching
    /**
     Collects all the types of the attribute that we're after
     - parameter attribute: The NSAttributedString.Key values we're searching for
     - returns: An array of all the values that correlated with the provided attribute key
    */
    fileprivate func all(of attribute: NSAttributedString.Key) -> [Any]
    {
        var allValues = [Any]()
        let fullRange = self.string.fullRange
        let options   = NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired
        
        self.enumerateAttribute(attribute, in: fullRange, options: options, using: {(valueOpt, range, stop) in
            if let value = valueOpt {
                allValues.append(value)
            }
        })
        
        return allValues
    }
    
    /**
     Calculates all the various fonts that exist within this NSAttributedString
     - returns: All NSFonts that are used in this NSAttributedString
    */
    public func allFonts() -> [NSFont]
    {
        var fonts = [NSFont]()
        self.enumerateAttribute(NSAttributedString.Key.font, in: self.string.fullRange, options: .longestEffectiveRangeNotRequired, using: {(value, range, stop) in
            let font = value as! NSFont
            fonts.append(font)
        })
        
        return fonts
    }
    
    /**
     Calculates all the text colours that are used in this attributed string
     - returns: An array of NSColors, representing all the text colours in this attributed string
     */
    public func allTextColours() -> [NSColor]
    {
        var colours = [NSColor]()
        self.enumerateAttribute(.foregroundColor, in: self.string.fullRange, options: .longestEffectiveRangeNotRequired, using: {(value, range, finished) in
            if value != nil {
                if let colour = value as? NSColor {
                    colours.append(colour)
                }
            }
            
            //If the value is nil, it's the default NSColor value, which is black
            else {
                colours.append(NSColor.black)
            }
        })
        
        return colours
    }
    
    public func allHighlightColours() -> [NSColor]
    {
        var colours = [NSColor]()
        self.enumerateAttribute(.backgroundColor, in: self.string.fullRange, options: .longestEffectiveRangeNotRequired, using: {(value, range, finished) in
            if value != nil {
                if let colour = value as? NSColor {
                    colours.append(colour)
                }
            }
                
            //If the value is nil, it's the default NSColor value, which is white
            else {
                colours.append(NSColor.white)
            }
        })
        
        return colours
    }
    
    /**
     Calculates all the NSTextAttachments that are contained in this attributed string
     - returns: An array of NSTextAttachments, representing all the attachments in this attributed string
     */
    public func allAttachments() -> [NSTextAttachment]
    {
        var attachments = [NSTextAttachment]()
        self.enumerateAttribute(.attachment, in: self.string.fullRange, options: .longestEffectiveRangeNotRequired, using: {(value, range, finished) in
            if value != nil {
                if let attachment = value as? NSTextAttachment {
                    attachments.append(attachment)
                }
            }
        })
        
        return attachments
    }
    
    /**
     Finds the NSTextList at a given range
     - parameter range: The NSRange that we'll search for the NSTextList in
     - returns: An NSTextList, if one exists at the given range
     */
    public func textList(at searchRange: NSRange) -> NSTextList?
    {
        var textList: NSTextList?
        
        self.enumerateAttribute(.paragraphStyle, in: self.string.fullRange, options: .longestEffectiveRangeNotRequired, using: {(value, range, finished) in
            if value != nil {
                if let paragraphStyle = value as? NSParagraphStyle {
                    
                    //TODO: Improve search to see if this textlist is the one we're after
                    if paragraphStyle.textLists.count >= 1 {
                        textList = paragraphStyle.textLists[0]
                        
                        print("TextList Range: \(range)")
                        print("Search   Range: \(searchRange)")
                    }
                }
            }
        })
        
        return textList
    }
    
    //MARK: - Attribute Checking
    /**
     Iterates over every font that exists within this NSAttributedString, and checks if any of the fonts contain the desired NSFontTraitMask
     - returns: A boolean value, indicative of if this contains our desired trait
    */
    public func contains(trait: NSFontTraitMask) -> Bool
    {
        let allFonts = self.all(of: NSAttributedString.Key.font) as! [NSFont]
        for font in allFonts {
            if font.contains(trait: trait) {
                return true
            }
        }
        
        return false
    }
    
    /**
     Iterates over every font that exists within this NSAttributedString, and checks if any of the fonts contain the desired NSFontTraitMask
     - returns: A boolean value, indicative of if our desired trait could not be found
     */
    public func doesNotContain(trait: NSFontTraitMask) -> Bool
    {
        let allFonts = self.all(of: NSAttributedString.Key.font) as! [NSFont]
        for font in allFonts {
            if !font.contains(trait: trait) {
                return true
            }
        }
        
        return false
    }
    
    /**
     Determines if this attributed string contains any parts that have the provided NSAttributedString.Key, and any
     parts that do NOT have the provided NSAttributedString.Key
     - parameter key: The NSAttributedString.Key that we're looking for
     - parameter isNegativeAttr: This takes the provided `rawAttrValue` and will check if it matches 'off' value for the attribute.
     If `attribute` was NSUnderlineStyle, then the rawAttrValue would be checked against NSUnderlineStyle.styleNone.rawValue. If it
     did, a `true` boolean value would be returned
     - returns: A tuple containing two arguments, atParts & notAtParts. atParts will be true if any part of this
     attributed string is present. notAtParts will be true if any part of this attributed string is NOT present.
     The two arguments are not mutually exclusive since a string can have an attribute at some parts and
     not have the same attributes at other parts.
    */
    public func check(attribute: NSAttributedString.Key, isNegativeAttr: (_ rawAttrValue: Int) -> Bool) -> (atParts: Bool, notAtParts: Bool)
    {
        var atParts   : Bool?
        var notAtParts: Bool?
        
        self.enumerateAttribute(attribute, in: self.string.fullRange, options: .longestEffectiveRangeNotRequired, using: {(valueOpt, range, stop) in
            
            if let value = valueOpt as? NSNumber {
                //If we have a `none` enum value
                if !isNegativeAttr(value.intValue) {
                    atParts = true
                }
                
                //If we don't have a `none` enum value
                else {
                    notAtParts = true
                }
            }
            
            else {
                notAtParts = true
            }
        })
        
        //If noUnderlineAtParts wasn't set and neither was underlineAtParts, then clearly we have no underline
        if notAtParts == nil && atParts == nil {
            notAtParts = true
        }
        
        //If noUnderlineAtParts wasn't set but underlineAtParts WAS, then clearly we only have underline
        if notAtParts == nil && atParts != nil {
            notAtParts = false
        }
        
        //If underlineAtParts wasn't set, then clearly we don't have any underline
        if atParts == nil {
            atParts = false
        }
        
        return (atParts!, notAtParts!)
    }
}
