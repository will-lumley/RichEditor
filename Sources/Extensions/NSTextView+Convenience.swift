//
//  NSTextView+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 20/3/18.
//  Copyright © 2018 William Lumley. All rights reserved.
//

import Foundation
import AppKit

public extension NSTextView {

    struct LineInfo {
        let lineNumber: Int
        let lineRange: NSRange
        let lineString: String
    }
    
    /// Determines if the user has selected (ie. highlighted) any text
    var hasSelectedText: Bool {
        self.selectedRange().length > 0
    }

    /// The location of our caret within the textview
    var caretLocation: Int {
        self.selectedRange().location
    }
    
    /**
     Calculates which line number (using a 0 based index) our caret is on, the range of this line (in comparison to the whole string), and the string that makes up that line of text.
     Will return nil if there is no caret present, and a portion of text is highlighted instead.
     
     A pain point of this function is that it cannot return the current line number when it's found, but rather
     has to wait for every single line to be iterated through first. This is because the enumerateSubstrings() function
     on the String is not an actual loop, and as such we cannot return or break within it.
     
     - returns: The line number that the caret is on, the range of our line, and the string that makes up that line of text
     */
    var currentLine: LineInfo {
        //The line number that we're currently iterating on
        var lineNumber = 0
        
        //The line number & line of text that we believe the caret to be on
        var selectedLineNumber = 0
        var selectedLineRange  = NSRange(location: 0, length: 0)
        var selectedLineOfText = ""
        
        var foundSelectedLine = false
        
        //Iterate over every line in our TextView
        self.string.enumerateSubstrings(in: self.string.startIndex..<self.string.endIndex, options: .byLines) {(substring, substringRange, _, _) in
            //The range of this current line
            let range = NSRange(substringRange, in: self.string)

            //Calculate the start location of our line and the end location of our line, in context to our TextView.string as a whole
            let startOfLine = range.location
            let endOfLine   = range.location + range.length
            
            //If the CaretLocation is between the start of this line, and the end of this line, we can assume that the caret is on this line
            if self.caretLocation >= startOfLine && self.caretLocation <= endOfLine {
                // MARK the line number
                selectedLineNumber = lineNumber
                selectedLineOfText = substring ?? ""
                selectedLineRange  = range
                
                foundSelectedLine = true
            }
            
            lineNumber += 1
        }
        
        //If we're not at the starting point, and we didn't find a current line, then we're at the end of our TextView
        if self.caretLocation > 0 && !foundSelectedLine {
            selectedLineNumber = lineNumber
            selectedLineOfText = ""
            selectedLineRange  = NSRange(location: self.caretLocation, length: 0)
        }
        
        return LineInfo(lineNumber: selectedLineNumber, lineRange: selectedLineRange, lineString: selectedLineOfText)
    }
    
    /**
     Replaces the current NSString/NSAttributedString that is currently within
     the NSTextView and replaces it with the provided HTML string.
     This HTML string is converted into a UTF8 encoded piece of data at first,
     and then converted to an NSAttributedString using native cocoa functions
     - parameter html: The HTML we wish to populate our NSTextView with
     - returns: A boolean value indicative of if the conversion and setting of
     the HTML string was successful
     */
    func set(html: String) -> Bool {
        guard let htmlData = html.data(using: .utf8) else {
            print("Error creating NSAttributedString, HTML data is nil.")
            return false
        }
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtfd]
        guard let attrFromHTML = NSAttributedString(html: htmlData, options: options, documentAttributes: nil) else {
            print("Error creating NSAttributedString, NSAttributedString from HTML is nil.")
            return false
        }
        
        //We've created the NSAttributedString from the HTML, let's apply it
        return self.set(attributedString: attrFromHTML)
    }
    
    /**
     Replaces the current NSString/NSAttributedString that is currently within
     the NSTextView and replaces it with the provided NSAttributedString
     - parameter attributedString: The NSAttributedString we wish to populate our NSTextView with
     - returns: A boolean value indicative of if the setting of the NSAttributedString was successful
    */
    @discardableResult
    func set(attributedString: NSAttributedString) -> Bool {
        guard let textStorage = self.textStorage else {
            print("Error setting NSAttributedString, TextStorage is nil.")
            return false
        }
        
        let fullRange = self.string.fullRange
        textStorage.replaceCharacters(in: fullRange, with: attributedString)
        
        return true
    }
    
    func iterateThroughAllAttachments() {
        let attachments = self.attributedString().allAttachments
        for attachment in attachments {
            guard let fileWrapper = attachment.fileWrapper else {
                continue
            }
            
            if !fileWrapper.isRegularFile {
                continue
            }
            
            guard let fileData = fileWrapper.regularFileContents else { continue }
            let fileName = fileWrapper.filename
            let fileAttr = fileWrapper.fileAttributes
            let fileIcon = fileWrapper.icon
            
            print("FileAttributes: \(fileAttr)")
            print("FileData: \(fileData)")
            print("FileName: \(fileName ?? "NoName")")
            print("FileIcon: \(String(describing: fileIcon))")
            
            print("")
        }
    }
        
    func append(_ string: String) {
        let textViewText = NSMutableAttributedString(attributedString: self.attributedString())
        textViewText.append(NSAttributedString(string: string, attributes: self.typingAttributes))
        
        self.set(attributedString: textViewText)
    }
}
