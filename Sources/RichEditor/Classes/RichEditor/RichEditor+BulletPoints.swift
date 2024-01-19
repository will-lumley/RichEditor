//
//  RichEditor+BulletPoints.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import AppKit

public extension RichEditor {

    func startBulletPoints() {
        let currentLine = self.textView.currentLine
        
        // Get the string that makes up our current string, and find out where it sits in our TextView
        let currentLineStr   = currentLine.lineString
        let currentLineRange = currentLine.lineRange
        
        // If our current line already has a bullet point, remove it
        if currentLineStr.isBulletPoint {
            //Get the line in our TextView that our caret is on, and remove our bulletpoint
            var noBulletPointStr = currentLineStr.replacingOccurrences(of: "\(RichEditor.bulletPointMarker) ", with: "")
            noBulletPointStr = currentLineStr.replacingOccurrences(of: RichEditor.bulletPointMarker, with: "")

            self.textView.replaceCharacters(in: currentLineRange, with: noBulletPointStr)
        }
        // If our current line doesn't already have a bullet point appended to it, prepend one
        else {
            // Get the line in our TextView that our caret is on, and prepend a bulletpoint to it
            let bulletPointStr = "\(RichEditor.bulletPointMarker) \(currentLineStr)"
            self.textView.replaceCharacters(in: currentLineRange, with: bulletPointStr)
        }
    }

}

extension RichEditor: NSTextViewDelegate {

    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {

        // Handle:
        // 1. If a line with *just* a bullet point exists and backspace is pressed, delete 1 tab

        // Get all the lines of the text
        // Get the line of text that we're on

        guard let newString = replacementString else { return true }

        let currentLine = textView.currentLine

        // If the line we're currently on is NOT prefixed with a bullet point, bail out
        let currentLineStr = currentLine.lineString
        if currentLineStr.isBulletPoint == false {
            // We have decided we don't want to make any artificial changes, let the literal changes go through
            return true
        }

        let currentLineRange = currentLine.lineRange

        // If the user just hit enter/newline
        if newString == "\n" {
            // The line we're currently on is prefixed with a bullet point, append a bullet point to the next line

            // If our current line is just an empty bullet point line, remove the bullet point and turn it into a regular line
            if currentLineStr == RichEditor.bulletPointMarker {
                self.textView.replaceCharacters(in: currentLineRange, with: "")
            }

            // If our current line is a full bullet point line, append a brand spanking new bullet point line below our current line for our user
            else {

                // We want to make sure that our newline has the same amount of starting tabs as our current line
                var prependedTabs = ""
                if currentLineStr.isPrefixedWithTab {
                    prependedTabs = "\t".repeated(currentLineStr.prefixedStringCount(needle: "\t"))
                }

                let bulletPointStr = "\(currentLineStr)\n\(prependedTabs)\(RichEditor.bulletPointMarker)"
                self.textView.replaceCharacters(in: currentLineRange, with: bulletPointStr)
            }

            // We've made the artificial changes to the string, don't let the literal change go through
            return false
        }

        // If the user just hit the tab button
        else if newString == "\t" {
            let bulletPointStr = "\t\(currentLineStr)"
            self.textView.replaceCharacters(in: currentLineRange, with: bulletPointStr)

            // We've made the artificial changes to the string, don't let the literal change go through
            return false
        }

        // If the user just hit the backspace button
        else if newString.isBackspace {
            // If our line has any tabs prepended to it, delete one of them
            if currentLineStr.isPrefixedWithTab {

                // Get the CaretLocation of our caret relative to this current line
                var caretLocation = currentLine.caretLocation

                // Calculate how many bullet point & tabs exist in the start of this line
                let prefixTabCount = currentLineStr.prefixedStringCount(needle: "\t")
                let prefixBulletPointCount = currentLineStr.prefixedStringCount(needle: "•", ignoring: ["\t"])

                // Remove the bullet point & tab count from our location, as we don't consider them actual characters
                caretLocation = caretLocation - (prefixTabCount + prefixBulletPointCount)

                // Remove the extra space that sits after the bullet point
                caretLocation -= 1

                // If our caret is at the start (barring any tabs and bullet point markers) of our line
                if caretLocation == 0 {
                    var bulletPointStr = String(currentLineStr)
                    bulletPointStr.removeFirst(needle: "\t")

                    self.textView.replaceCharacters(in: currentLineRange, with: bulletPointStr)

                    // We've made the artificial changes to the string, don't let the literal change go through
                    return false
                }
            }
        }

        // We have decided we don't want to make any artificial changes, let the literal changes go through// We have decided we don't want to make any artificial changes, let the literal changes go through
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
        
        self.selectedTextFontStyling = TextStyling(attributedString: attr)
    }

}
