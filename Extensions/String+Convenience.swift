//
//  String+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 20/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension String
{
    /// Conveniently creates an NSRange that covers the very start of this string, to the very end of this string
    public var fullRange: NSRange {
        return NSRange(location: 0, length: self.count)
    }
}
