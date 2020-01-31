//
//  Dictionary+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 21/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension Dictionary
{
    /**
     Merges the provided dictionary into this one. If the newDict and this dictionary have identical keys,
     the newDict's key/value pair overwrite the original one
     - parameter newDict: The dictionary which we'd like to merge
    */
    mutating func merge(newDict: Dictionary)
    {
        for (key, value) in newDict {
            self[key] = value
        }
    }
}
