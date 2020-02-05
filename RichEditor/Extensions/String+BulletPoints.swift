//
//  String+Lines.swift
//  Pods-RichEditor_Example
//
//  Created by William Lumley on 4/2/20.
//

import Foundation

extension String
{
    public var isBulletPoint: Bool {
        return self.hasPrefix(RichEditor.bulletPointMarker)
    }
    
    /**
     Returns an array of strings that is made up of all the "lines" in this string.
     - returns: An array of strings that is derived from this string, using a newline as a delimiter
     */
    func lines() -> [String]
    {
        var lines = [String]()
        
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex, options: .byLines) {(substring, substringRange, _, _) in
            if let str = substring {
                lines.append(str)
            }
        }
        
        return lines
    }    
}
