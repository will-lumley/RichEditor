//
//  RichEditor.swift
//  Nimble
//
//  Created by Will Lumley on 30/1/20.
//

import Foundation
import AppKit

public protocol RichEditorDelegate
{
    func fontStylingChanged(_ fontStyling: FontStyling)
    func richEditorTextChanged(_ richEditor: RichEditor)
}

public class RichEditor: NSView
{
    //The NSTextView stack
    /*------------------------------------------------------------*/
    public fileprivate(set) lazy var textStorage   = NSTextStorage()
    public fileprivate(set) lazy var layoutManager = NSLayoutManager()
    public fileprivate(set) lazy var textContainer = NSTextContainer()
    public fileprivate(set) lazy var textView      = RichTextView(frame: CGRect(), textContainer: self.textContainer)
    public fileprivate(set) lazy var scrollview    = NSScrollView()
    /*------------------------------------------------------------*/
    
    ///The FontStyling that contains information of the 'relevant' text
    fileprivate var selectedTextFontStyling: FontStyling?
    {
        didSet {
            self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
        }
    }
    
    ///The marker that will be used for bullet points
    internal static var bulletPointMarker = "•\u{00A0}" //NSTextList.MarkerFormat.circle
    
    /**
     Returns the FontStyling object that was derived from the selected text, or the future text if nothing is selected
     - returns: The FontStyling object for the relevant text
     */
    public var fontStyling: FontStyling {
        return self.selectedTextFontStyling ?? FontStyling(typingAttributes: self.textView.typingAttributes)
    }
    
    ///The delegate which will notify the listener of significant events
    public var richEditorDelegate: RichEditorDelegate?
    
    //MARK: - NSView
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        self.setup()
    }
    
    required init?(coder decoder: NSCoder)
    {
        super.init(coder: decoder)
        self.setup()
    }
    
    /**
     Perform the initial setup operations to get a functional NSTextView running
    */
    fileprivate func setup()
    {
        self.textView.delegate = self
        
        self.addSubview(self.scrollview)
        self.configureTextView(isHorizontalScrollingEnabled: false)
        self.configureTextViewLayout()
        
        self.textView.textStorage?.delegate = self
        self.textView.layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        
        self.selectedTextFontStyling = nil
    }
}

//MARK: - Public Interface
extension RichEditor
{
    /**
     Toggles the bold attribute for the selected text, or the future text if no text is selected
    */
    public func toggleBold()
    {
        self.toggleTextView(with: .boldFontMask)
    }

    /**
     Toggles the italics attribute for the selected text, or the future text if no text is selected
    */
    public func toggleItalic()
    {
        self.toggleTextView(with: .italicFontMask)
    }
    
    /**
     Toggles the underline attribute for the selected text, or the future text if no text is selected
     - parameter style: The style of the underline that we want
    */
    public func toggleUnderline(_ style: NSUnderlineStyle)
    {
        self.toggleTextView(with: .underlineStyle, negativeValue: 0, positiveValue: style.rawValue)
    }
    
    /**
     Toggles the strikethrough attribute for the selected text, or the future text if no text is selected
    */
    public func toggleStrikethrough(_ style: NSUnderlineStyle)
    {
        self.toggleTextView(with: .strikethroughStyle, negativeValue: 0, positiveValue: style.rawValue)
    }
    
    public func apply(textColour: NSColor)
    {
        let colourAttr = [NSAttributedString.Key.foregroundColor: textColour]
        self.add(attributes: colourAttr, onlyHighlightedText: self.textView.hasSelectedText)
    }
    
    public func apply(highlightColour: NSColor)
    {
        let colourAttr = [NSAttributedString.Key.backgroundColor: highlightColour]
        self.add(attributes: colourAttr, onlyHighlightedText: self.textView.hasSelectedText)
    }
    
    public func apply(font: NSFont)
    {
        let fontAttr = [NSAttributedString.Key.font: font]
        self.add(attributes: fontAttr, onlyHighlightedText: self.textView.hasSelectedText)
    }
    
    public func startBulletPoints()
    {
        let currentLine = self.textView.currentLine()
        
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
    
    /**
     Inserts a clickable link into the NSTextView
     - parameter link: The URI/URL that will be opened upon the clicking of this link
     - parameter name: The text that will be displayed to the user
     - parameter position: The location of the NSTextView's string where the link will be
     inserted. If nil, the cursors position is used instead.
     */
    public func insert(link: String, with name: String, at position: Int?)
    {
        let attrString = NSMutableAttributedString(string: name)
        attrString.addAttribute(NSAttributedString.Key.link, value: link, range: name.fullRange)
        
        let insertionPosition = position ?? self.textView.selectedRange().location
        self.textView.textStorage!.insert(attrString, at: insertionPosition)
    }
    
    public func promptUserForAttachments(windowForModal: NSWindow?)
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories    = false
        openPanel.canCreateDirectories    = false
        openPanel.canChooseFiles          = true
        
        if let window = windowForModal {
            openPanel.beginSheetModal(for: window, completionHandler: {(modalResponse) in
                if modalResponse == NSApplication.ModalResponse.OK {
                    let selectedURLs = openPanel.urls
                    self.insertAttachments(at: selectedURLs)
                }
            })
        }
        else {
            openPanel.begin(completionHandler: {(modalResponse) in
                if modalResponse == NSApplication.ModalResponse.OK {
                    let selectedURLs = openPanel.urls
                    self.insertAttachments(at: selectedURLs)
                }
            })
        }
    }
    
    public func insertAttachments(at urls: [URL])
    {
        self.textView.layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        
        print("Inserting attachments at URLs: \(urls)")
        
        //Iterate over every URL and create a NSTextAttachment from it
        for url in urls {
            let attachment = url.textAttachment()
            let attachmentAttrStr = NSAttributedString(attachment: attachment)
            
            self.textView.textStorage?.append(attachmentAttrStr)
        }
    }
    
    /**
     Uses the NSTextView's attributed string to create a HTML string that
     represents the content held within the NSTextView.
     The NSAttribtedString -> HTML String conversion uses the cocoa
     native data(from...) function.
     - throws: An error, if the NSAttribtedString -> HTML String conversion fails
     - returns: The string object that is the HTML
    */
    public func html() throws -> String?
    {
        let attrStr = self.textView.attributedString()
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        
        let htmlData = try attrStr.data(from: attrStr.string.fullRange, documentAttributes: documentAttributes)
        if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {
            //print("HTML: \(htmlString)")
            return htmlString
        }
        
        return nil
    }
    
    /**
     Returns the NSFont object that was derived from the selected text, or the future text if nothing is selected
     - returns: The NSFont object for the relevant text
    */
    public func currentFont() -> NSFont
    {
        //If we have highlighted text, we'll analyse the font of the highlighted text
        if self.textView.hasSelectedText {
            let range = self.textView.selectedRange()
            
            //Create an attributed string out of ONLY the highlighted text
            guard let attr = self.textView.attributedSubstring(forProposedRange: range, actualRange: nil) else {
                fatalError("Failed to create AttributedString.")
            }
            
            let fonts = attr.allFonts()
            if fonts.count < 1 {
                fatalError("AttributedString had no fonts: \(attr)")
            }
            
            return fonts[0]
        }
        
        //We have not highlighted text, so we'll just use the 'future' font
        else {
            let typingAttributes = self.textView.typingAttributes
            
            let font = typingAttributes[NSAttributedString.Key.font] as! NSFont
            return font
        }
    }
}

//MARK: - Private Interface
extension RichEditor
{
    /**
     Toggles a certain font trait (bold, italic, etc) for the RichTextView.
     If text is highlighted, then only the highlighted text will have its font toggled. If no text is highlighted
     then all 'future' text will have the new traits.
     
     - parameter trait: This is the trait that you want the font to adhere to
    */
    fileprivate func toggleTextView(with fontTrait: NSFontTraitMask)
    {
        //Get the current font, and make a 'new' version of it, with the traits provided to us
        let currentFont = self.currentFont()
        var newFont     = currentFont
        
        let fontStyling = self.fontStyling
        let fontStylingTrait = fontStyling.fontTraitFor(nsFontTraitMask: fontTrait)
        
        print("\nOldFont: \(currentFont)")
        switch (fontStylingTrait) {
            //If we're ONLY bold at the moment, let's make it unbold
            case .hasTrait:
                newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: fontTrait)
            
            //If we're ONLY unbold at the moment, let's make it bold
            case .hasNoTrait:
                newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: fontTrait)
            
            //If we're BOTH bold and unbold, we'll make it bold
            case .both:
                newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: fontTrait)
        }
        print("NewFont: \(newFont)\n")
        
        let updatedFontAttr = [NSAttributedString.Key.font: newFont]
        self.add(attributes: updatedFontAttr, onlyHighlightedText: self.textView.hasSelectedText)
        
        self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
    }
    
    /**
     Toggles a certain NSAttributeString.Key (underline, strikethrough, etc) for the RichTextView.
     If text is highlighted, then only the highlighted text will have its NSAttributedText toggled.
     If no text is highlighted then all 'future' text will have the new attributes.
     
     - parameter attribute: This is the trait that you want the NSAttributedString to adhere to
     - parameter negativeValue: This is the 'off' value for the attribute. If `attribute` was
     NSUnderlineStyle, then the negativeValue would be NSUnderlineStyle.styleNone.rawValue
     - parameter positiveValue: This is the 'on' value for the attribute. If `attribute` was
     NSUnderlineStyle, then the positive would be NSUnderlineStyle.styleSingle.rawValue
    */
    fileprivate func toggleTextView(with attribute: NSAttributedString.Key, negativeValue: Any, positiveValue: Any)
    {
        let trait = self.fontStyling.trait(with: attribute)
        
        var newAttr = [NSAttributedString.Key: Any]()
        switch (trait) {
            case .hasTrait:
                newAttr = [attribute: negativeValue]
            
            case .hasNoTrait:
                newAttr = [attribute: positiveValue]
            
            case .both:
                newAttr = [attribute: positiveValue]
        }
        
        self.add(attributes: newAttr, onlyHighlightedText: self.textView.hasSelectedText)
        self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
    }
    
    /**
     Adds the provided NSAttributedString.Key attributes to the TextView. The attributes will either
     be applied to the text that is selected, or to all 'future' text. This is dependant on the
     onlyHighlightedText argument.
     - parameter attributes: The attributes that we wish to apply to our NSTextView
     - parameter onlyHighlightedText: If true, the attributes will be applied to only the highlighted
     text. If false, the attributes will be applied to all 'future' text
    */
    fileprivate func add(attributes: [NSAttributedString.Key: Any], onlyHighlightedText: Bool)
    {
        //If we're only modifying the text that's highlighted
        if onlyHighlightedText {
            let selectedRange = self.textView.selectedRange()
            
            self.textStorage.addAttributes(attributes, range: selectedRange)
            
            //Create an attributed string out of ONLY the highlighted text
            guard let attr = self.textView.attributedSubstring(forProposedRange: selectedRange, actualRange: nil) else {
                return
            }
            
            //Ensure the UI is updated with the new FontStyling state's
            self.selectedTextFontStyling = FontStyling(attributedString: attr)
        }
        
        //If we're modifying all 'future' text
        else {
            //Get the existing TypingAttributes, and merge it into our new attributes dictionary
            var typingAttributes = self.textView.typingAttributes
            //print("Old TypingAttributes: \(typingAttributes)")
            
            typingAttributes.merge(newDict: attributes)
            //print("New TypingAttributes: \(typingAttributes)\n")
            
            self.textView.typingAttributes = typingAttributes
        }
        
        self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
    }
}

//MARK: - NSTextStorage Delegate
extension RichEditor: NSTextStorageDelegate
{
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int)
    {
        self.richEditorDelegate?.richEditorTextChanged(self)
    }
}

//MARK: - NSTextViewDelegate
extension RichEditor: NSTextViewDelegate
{
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool
    {
        //Get all the lines of the text
        //Get the line of text that we're on
        
        guard let newString = replacementString else { return true }
        
        //If the user just hit enter/newline
        if newString == "\n" {
            let currentLine = textView.currentLine()
            
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
    
    public func textViewDidChangeSelection(_ notification: Notification)
    {
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
