//
//  RichEditor+BulletPoints.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

extension RichEditor {

    public func startBulletPoints() {
        let currentLine = self.textView.currentLine
        
        //Get the string that makes up our current string, and find out where it sits in our TextView
        let currentLineStr   = currentLine.lineString
        let currentLineRange = currentLine.lineRange
        
        //If our current line already has a bullet point, remove it
        if currentLineStr.isBulletPoint {
            //Get the line in our TextView that our caret is on, and remove our bulletpoint
            var noBulletPointStr = currentLineStr.replacingOccurrences(of: "\(RichEditor.bulletPointMarker) ", with: "")
            noBulletPointStr = currentLineStr.replacingOccurrences(of: RichEditor.bulletPointMarker, with: "")

            self.textView.replaceCharacters(in: currentLineRange, with: noBulletPointStr)
        }
        //If our current line doesn't already have a bullet point appended to it, prepend one
        else {
            //Get the line in our TextView that our caret is on, and prepend a bulletpoint to it
            let bulletPointStr = "\(RichEditor.bulletPointMarker) \(currentLineStr)"
            self.textView.replaceCharacters(in: currentLineRange, with: bulletPointStr)
        }
    }

}

extension RichEditor: NSTextViewDelegate {

    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        //Get all the lines of the text
        //Get the line of text that we're on
        
        guard let newString = replacementString else { return true }
        
        //If the user just hit enter/newline
        if newString == "\n" {
            let currentLine = textView.currentLine
            
            //If the line we're currently on is prefixed with a bullet point, append a bullet point to the next line
            let currentLineStr = currentLine.lineString
            if currentLineStr.isBulletPoint {
                
                let currentLineRange = currentLine.lineRange
                
                //If our current line is just an empty bullet point line, remove the bullet point and turn it into a regular line
                if currentLineStr == RichEditor.bulletPointMarker {
                    self.textView.replaceCharacters(in: currentLineRange, with: "")
                }
                
                //If our current line is a full bullet point line, append a brand spanking new bullet point line below our current line for our user
                else {
                    let bulletPointStr = "\(currentLineStr)\n\(RichEditor.bulletPointMarker)"
                    self.textView.replaceCharacters(in: currentLineRange, with: bulletPointStr)
                }
                
                return false
            }
        }
        
        return true
    }
    
    /*
    func textView(_ textView: NSTextView, urlForContentsOf textAttachment: NSTextAttachment, at charIndex: Int) -> URL?
    {
        print("TextAttachment: \(textAttachment)")
        print("CharIndex: \(charIndex)")

        let fileWrapper = textAttachment.fileWrapper!
        //let metaFileWrappers = fileWrapper.fileWrappers
        let data = fileWrapper.regularFileContents ?? Data()
        
        //print("FileWrapper.fileWrappers: \(String(describing: metaFileWrappers))")
        print("Data: \(data)")
        
        print("")
        return nil
    }
    */
    
    public func textViewDidChangeSelection(_ notification: Notification) {
        let selectedRange = self.textView.selectedRange()
        let isSelected    = selectedRange.length > 0
        
        if !isSelected {
            self.selectedTextFontStyling = nil
            return
        }
        
        //Create an attributed string out of ONLY the highlighted text
        guard let attr = self.textView.attributedSubstring(forProposedRange: selectedRange, actualRange: nil) else {
            return
        }
        
        self.selectedTextFontStyling = FontStyling(attributedString: attr)
    }

}
