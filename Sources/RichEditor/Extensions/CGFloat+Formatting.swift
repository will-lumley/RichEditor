//
//  String+Formatting.swift
//  RichEditor
//
//  Created by William Lumley on 2/4/18.
//  Copyright © 2018 William Lumley. All rights reserved.
//

import Foundation

public extension CGFloat {

    /**
     Removes the decimal point if the value is equal to 0
     StackOverflow: https://stackoverflow.com/a/33996219
    */
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(Float(self))
    }

}
