//
//  String+Formatting.swift
//  RichEditor
//
//  Created by William Lumley on 2/4/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation

extension CGFloat
{
    /**
     StackOverflow: https://stackoverflow.com/a/33996219
    */
    public var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(Float(self))
    }
}
