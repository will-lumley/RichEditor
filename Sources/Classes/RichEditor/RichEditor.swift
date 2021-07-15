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
            self.toolbarRichEditorDelegate?.fontStylingChanged(self.fontStyling)
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
    internal var toolbar: RichEditorToolbar?

    /// The delegate which will notify the listener of significant events
    internal var toolbarRichEditorDelegate: RichEditorDelegate?

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
        
        self.configureTextView(isHorizontalScrollingEnabled: false)

        self.configureToolbar()
        self.configureTextViewLayout()

        self.textView.textStorage?.delegate = self
        self.textView.layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown

        self.selectedTextFontStyling = nil
    }

    internal func configureToolbar() {
        self.toolbar = RichEditorToolbar(richEditor: self)
        self.toolbarRichEditorDelegate = self.toolbar

        guard let toolbar = self.toolbar else {
            return
        }

        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolbar)

        toolbar.wantsLayer = true
        toolbar.layer?.backgroundColor = NSColor.clear.cgColor

        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: self.topAnchor),
            toolbar.widthAnchor.constraint(equalTo: self.widthAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    internal func configureTextViewLayout() {
        self.scrollview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.scrollview)

        // If there is a toolbar, attach our scroll view to the bottom our toolbar
        if let toolbar = self.toolbar {
            NSLayoutConstraint.activate([
                self.scrollview.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.scrollview.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 5),
                self.scrollview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }

        // If there is NOT a toolbar, attach our scroll view to the bottom of our view
        else {
            NSLayoutConstraint.activate([
                self.scrollview.widthAnchor.constraint(equalTo: self.widthAnchor),
                self.scrollview.topAnchor.constraint(equalTo: self.topAnchor),
                self.scrollview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
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
    public func html() throws -> String? {
        let attrStr = self.textView.attributedString()
        let documentAttributes = [
            NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentAttributeKey.characterEncoding: String.Encoding.utf8.rawValue
        ] as [NSAttributedString.DocumentAttributeKey: Any]

        let htmlData = try attrStr.data(from: attrStr.string.fullRange, documentAttributes: documentAttributes)
        if var htmlString = String(data:htmlData, encoding:String.Encoding.utf8) {

            // Iterate over each attachment, and replace each "file://" component with the image
            let allAttachments = self.textView.attributedString().allAttachments
            for attachment in allAttachments {
                guard let imageID = attachment.fileWrapper?.filename else {
                    continue
                }

                 htmlString = htmlString.replacingOccurrences(of: "file:///\(imageID)", with: imageID)
            }

            print("HTML: \(htmlString)")
            return htmlString
        }

        return nil
    }

}

// MARK: - NSTextStorage Delegate
extension RichEditor: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        self.richEditorDelegate?.richEditorTextChanged(self)
        self.toolbarRichEditorDelegate?.richEditorTextChanged(self)
    }

}
