//
//  NSFont+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 20/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension NSFont
{
    /**
     Determines the FontTrait's that this font has
     StackOverflow: https://stackoverflow.com/a/38405084
     - returns: The NSFontTraitMask that will contain this font's traits
    */
    public func fontTraits() -> NSFontTraitMask
    {
        let descriptor = self.fontDescriptor
        let symTraits  = descriptor.symbolicTraits
        let traitSet   = NSFontTraitMask(rawValue: UInt(symTraits.rawValue))
        
        return traitSet
    }
    
    /**
     Checks if this font has the trait that we're searching for
     - trait: The NSFontTraitMask that we're looking for
     - returns: A boolean value, indicative of if this contains our desired trait
    */
    public func contains(trait: NSFontTraitMask) -> Bool
    {
        return self.fontTraits().contains(trait)
    }
}
