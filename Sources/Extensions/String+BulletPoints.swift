//
//  String+Lines.swift
//  Pods-RichEditor_Example
//
//  Created by William Lumley on 4/2/20.
//

import Foundation

public extension String {

    /// Indicative of if our string starts with a bullet point
    var isBulletPoint: Bool {
        let nsStr = NSString(string: self)
        let str = nsStr.replacingOccurrences(of: "\t", with: "")
        
        return str.hasPrefix(RichEditor.bulletPointMarker)        
    }

    /// Indicative of if our string starts with a tab character
    var isPrefixedWithTab: Bool {
        self.hasPrefix("\t")
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

    /// If this string is representative of a singular backspace
    var isBackspace: Bool {
        guard let char = self.cString(using: .utf8) else {
            return false
        }

        return strcmp(char, "\\b") == -92
    }

    mutating func removeFirst(needle: String) {
        guard let firstInstance = self.range(of: needle, options: .literal, range: nil, locale: nil) else {
            return
        }

        self.removeSubrange(firstInstance)
    }

    func repeated(_ count: Int) -> String {
        String(repeating: self, count: count)
    }

    func prefixedStringCount(needle: Character, ignoring: [Character] = []) -> Int {
        // If we're not prefixed with a tab, bail out with a count of 0
        guard self.isPrefixedWithTab else {
            return 0
        }

        var count = 0
        for char in self {
            // If this is a tab, add it to our count
            if char == needle {
                count += 1
            }

            // Oops, we found a character that isn't a tab, we're done here
            else {
                // We're only done here, if we have not been told to ignoring this character
                if ignoring.contains(char) == false {
                    break
                }
            }
        }

        return count
    }

}
