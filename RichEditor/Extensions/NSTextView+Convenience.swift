//
//  NSTextView+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 20/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension NSTextView
{
    /**
     Determines if the user has selected (ie. highlighted) any text
     - returns: A boolean value indicative of if any text is selected
    */
    public func hasSelectedText() -> Bool
    {
        return self.selectedRange().length > 0
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
    public func set(html: String) -> Bool
    {
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
        return self.set(attrFromHTML)
    }
    
    /**
     Replaces the current NSString/NSAttributedString that is currently within
     the NSTextView and replaces it with the provided NSAttributedString
     - parameter attributedString: The NSAttributedString we wish to populate
     our NSTextView with
     - returns: A boolean value indicative of if the setting of the NSAttributedString
     was successful
    */
    public func set(_ attributedString: NSAttributedString) -> Bool
    {
        guard let textStorage = self.textStorage else {
            print("Error setting NSAttributedString, TextStorage is nil.")
            return false
        }
        
        let fullRange = self.string.fullRange()
        textStorage.replaceCharacters(in: fullRange, with: attributedString)
        
        return true
    }
    
    public func iterateThroughAllAttachments()
    {
        let attachments = self.attributedString().allAttachments()
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
}
