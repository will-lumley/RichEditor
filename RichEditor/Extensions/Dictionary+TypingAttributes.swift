//
//  Dictionary+TypingAttributes.swift
//  RichEditor
//
//  Created by William Lumley on 28/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension Dictionary where Key == NSAttributedString.Key
{
    public func isUnderlined() -> Bool
    {
        guard let rawUnderlineStyle = self[NSAttributedString.Key.underlineStyle] as? NSNumber else {
            return false
        }
        
        let underlineStyle = NSUnderlineStyle(rawValue: rawUnderlineStyle.intValue)
        return underlineStyle != []
    }
    
    /**
     Determines if this dictionary contains any parts that have the provided NSAttributedString.Key or not
     - parameter key: The NSAttributedString.Key that we're looking for
     - parameter isNegativeAttr: This takes the provided `rawAttrValue` and will check if it matches 'off' value for the attribute.
     If `attribute` was NSUnderlineStyle, then the rawAttrValue would be checked against NSUnderlineStyle.styleNone.rawValue. If it
     did, a `true` boolean value would be returned
     - returns: A boolean value indicative of if the attribute was found or not
    */
    public func check(attribute: NSAttributedString.Key, isNegativeAttr: (_ rawAttrValue: Int) -> Bool) -> Bool
    {
        guard let rawAttr = self[attribute] as? NSNumber else {
            return false
        }
        
        return !isNegativeAttr(rawAttr.intValue)
    }
}

