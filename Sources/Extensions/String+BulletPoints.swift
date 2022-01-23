//
//  String+Lines.swift
//  Pods-RichEditor_Example
//
//  Created by William Lumley on 4/2/20.
//

import Foundation

public extension String {

    var isBulletPoint: Bool {
        let nsStr = NSString(string: self)
        let str = nsStr.replacingOccurrences(of: "\t", with: "")
        
        return str.hasPrefix(RichEditor.bulletPointMarker)        
    }
    
    /// Returns an array of strings that is made up of all the "lines" in this string.
    var lines: [String] {
        var lines = [String]()
        
        self.enumerateSubstrings(in: self.startIndex..<self.endIndex, options: .byLines) {(substring, substringRange, _, _) in
            if let str = substring {
                lines.append(str)
            }
        }
        
        return lines
    }

}
