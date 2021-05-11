//
//  RichEditor.swift
//  Nimble
//
//  Created by Will Lumley on 30/1/20.
//

import Foundation
import AppKit

public protocol RichEditorDelegate {
    func fontStylingChanged(_ fontStyling: FontStyling)
    func richEditorTextChanged(_ richEditor: RichEditor)
}

public class RichEditor: NSView {

    // MARK: - Properties

    //The NSTextView stack
    /*------------------------------------------------------------*/
    public private(set) lazy var textStorage   = NSTextStorage()
    public private(set) lazy var layoutManager = NSLayoutManager()
    public private(set) lazy var textContainer = NSTextContainer()
    public private(set) lazy var textView      = RichTextView(frame: CGRect(), textContainer: self.textContainer, delegate: self)
    public private(set) lazy var scrollview    = NSScrollView()
    /*------------------------------------------------------------*/
    
    ///The FontStyling that contains information of the 'relevant' text
    internal var selectedTextFontStyling: FontStyling? {
        didSet {
            self.richEditorDelegate?.fontStylingChanged(self.fontStyling)
        }
    }
    
    /// The marker that will be used for bullet points
    internal static var bulletPointMarker = "•\u{00A0}" //NSTextList.MarkerFormat.circle
    
    /// Returns the FontStyling object that was derived from the selected text, or the future text if nothing is selected
    public var fontStyling: FontStyling {
        return self.selectedTextFontStyling ?? FontStyling(typingAttributes: self.textView.typingAttributes)
    }
    
    /// The delegate which will notify the listener of significant events
    public var richEditorDelegate: RichEditorDelegate?

    /// The toolbar object, allowing for users to easily apply styling to their text
    private let toolbar = RichEditorToolbar()

    /// Returns the NSFont object that was derived from the selected text, or the future text if nothing is selected
    public var currentFont: NSFont {
        //If we have highlighted text, we'll analyse the font of the highlighted text
        if self.textView.hasSelectedText {
            let range = self.textView.selectedRange()
            
            //Create an attributed string out of ONLY the highlighted text
            guard let attr = self.textView.attributedSubstring(forProposedRange: range, actualRange: nil) else {
                fatalError("Failed to create AttributedString.")
            }
            
            let fonts = attr.allFonts
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

    // MARK: - NSView

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setup()
    }
    
    /**
     Perform the initial setup operations to get a functional NSTextView running
    */
    private func setup() {
        self.textView.delegate = self
        
        self.addSubview(self.scrollview)
        self.configureTextView(isHorizontalScrollingEnabled: false)

        self.configureTextViewLayout()
        //self.configureToolbarLayout()

        self.textView.textStorage?.delegate = self
        self.textView.layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        
        self.selectedTextFontStyling = nil
    }

    /**
     Uses programmatical AutoLayout to pin the NSTextView to its parent NSScrollView
    */
    internal func configureTextViewLayout() {
        self.scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalPinning = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|",
                                                               options: .directionLeadingToTrailing,
                                                               metrics: nil,
                                                               views: ["subview": self.scrollview])
        
        let verticalPinning = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|",
                                                             options: .directionLeadingToTrailing,
                                                             metrics: nil,
                                                             views: ["subview": self.scrollview])
        
        self.addConstraints(horizontalPinning)
        self.addConstraints(verticalPinning)
    }

    internal func configureToolbarLayout() {
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.toolbar)

        let constraints = [
            self.toolbar.widthAnchor.constraint(equalTo: self.scrollview.widthAnchor),
            self.toolbar.widthAnchor.constraint(equalToConstant: 110),
            self.toolbar.heightAnchor.constraint(equalToConstant: 35)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    /**
     Uses the NSTextView's attributed string to create a HTML string that
     represents the content held within the NSTextView.
     The NSAttribtedString -> HTML String conversion uses the cocoa
     native data(from...) function.
     - throws: An error, if the NSAttribtedString -> HTML String conversion fails
     - returns: The string object that is the HTML
    */
    public func html() throws -> String? {
        let attrStr = self.textView.attributedString()
        let documentAttributes = [
            NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html
        ]

        let htmlData = try attrStr.data(from: attrStr.string.fullRange, documentAttributes: documentAttributes)
        if let htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {
            //print("HTML: \(htmlString)")
            return htmlString
        }
        
        return nil
    }
}

// MARK: - NSTextStorage Delegate
extension RichEditor: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        self.richEditorDelegate?.richEditorTextChanged(self)
    }

}
