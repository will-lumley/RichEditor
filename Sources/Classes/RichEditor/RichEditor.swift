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
            htmlString = htmlString.replacingOccurrences(of: "file:///1.png", with: "data:image/png;base64, \(self.base64Image)")
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

extension RichEditor {
    var base64Image: String {
        "iVBORw0KGgoAAAANSUhEUgAAACYAAAAmCAYAAACoPemuAAAK2GlDQ1BJQ0MgUHJvZmlsZQAASImVlwdUU9kWhs+96Y0WupTQmyCdAFJCaKH3JiohCSSUGBOCiA2VQQVHFBURLCM6SFFwLICMBVHEwqDYsE+QQUEdBws2VOYCjzAzb7331ttrnewvO/vss8+956z1BwCKL1skyoKVAMgW5oijAnxoCYlJNNwgwAJdQAAawIDNkYgYEREhALFp/3d7fwdAE/6m9UStf//9v5oKlyfhAAAlI5zKlXCyEW5HxhBHJM4BAFWLxI2W5IgmuBthVTHSIMKyCU6f4ncTnDrJaPxkTkwUE2EdAPBkNlucDgDZHInTcjnpSB1yIMK2Qq5AiHAewp4cPpuLcCvCs7OzF03wbwibI/kiAChkhOmpf6mZ/rf6qfL6bHa6nKf2NWl4X4FElMVe+n8+mv9t2VnS6TVMkUHmiwOjEI+8Tehu5qJgOQtTw8KnWcCdzJ9kvjQwdpo5EmbSNHPZvsHyuVlhIdOcJvBnyevksGKmmSfxi55m8aIo+VppYiZjmtnimXWlmbHyOJ/HktfP58fET3OuIC5smiWZ0cEzOUx5XCyNkvfPEwb4zKzrL997tuQv+xWw5HNz+DGB8r2zZ/rnCRkzNSUJ8t64PF+/mZxYeb4ox0e+ligrQp7PywqQxyW50fK5OcjhnJkbIX+GGeygiGkGTBAAHIEDcAHBgAYicnh5ORObYC4SLRUL0vk5NAZy03g0lpBjM5tmb2tvB8DEvZ06Cm/vTt5HSB0/E1tWihzhSAR2z8SieAAcf46cb/uZmPkT5Ep2AtA5nyMV507F0BMfGEAEikAVaAE9YATMgTWwB87AHXgDPxAEwkEMSAQLAAfwQTYQgyVgOVgNikAJ2Ay2g0qwF+wHteAwOApawClwDlwEV8F1cBs8ADIwCF6AEfAejEEQhIMoEBXSgvQhE8gKsofokCfkB4VAUVAilAKlQ0JICi2H1kIlUBlUCe2D6qCfoJPQOegy1Avdg/qhYegN9BlGwWRYFdaFTeE5MB1mwMFwDDwfTocXw/lwIbwJroCr4UNwM3wOvgrfhmXwC3gUBVAklDrKAGWNoqOYqHBUEioNJUatRBWjylHVqEZUG6oLdRMlQ71EfUJj0VQ0DW2NdkcHomPRHPRi9Er0RnQluhbdjL6AvonuR4+gv2EoGB2MFcYNw8IkYNIxSzBFmHJMDeYEphNzGzOIeY/FYtWxZlgXbCA2EZuBXYbdiN2NbcK2Y3uxA9hRHA6nhbPCeeDCcWxcDq4ItxN3CHcWdwM3iPuIJ+H18fZ4f3wSXohfgy/H1+PP4G/gn+HHCEoEE4IbIZzAJSwllBIOENoI1wiDhDGiMtGM6EGMIWYQVxMriI3ETuJD4lsSiWRIciVFkgSkAlIF6QjpEqmf9ImsQrYkM8nJZCl5E/kguZ18j/yWQqGYUrwpSZQcyiZKHeU85THlowJVwUaBpcBVWKVQpdCscEPhlSJB0USRobhAMV+xXPGY4jXFl0oEJVMlphJbaaVSldJJpT6lUWWqsp1yuHK28kbleuXLykMqOBVTFT8Vrkqhyn6V8yoDVBTViMqkcqhrqQeondRBVayqmSpLNUO1RPWwao/qiJqKmqNanFqeWpXaaTWZOkrdVJ2lnqVeqn5U/Y76Zw1dDYYGT2ODRqPGDY0PmrM0vTV5msWaTZq3NT9r0bT8tDK1tmi1aD3SRmtbakdqL9Heo92p/XKW6iz3WZxZxbOOzrqvA+tY6kTpLNPZr9OtM6qrpxugK9LdqXte96Weup63XobeNr0zesP6VH1PfYH+Nv2z+s9pajQGLYtWQbtAGzHQMQg0kBrsM+gxGDM0M4w1XGPYZPjIiGhEN0oz2mbUYTRirG8carzcuMH4vgnBhG7CN9lh0mXywdTMNN50nWmL6ZCZphnLLN+sweyhOcXcy3yxebX5LQusBd0i02K3xXVL2NLJkm9ZZXnNCrZythJY7bbqnY2Z7TpbOLt6dp812ZphnWvdYN1vo24TYrPGpsXm1RzjOUlztszpmvPN1sk2y/aA7QM7FbsguzV2bXZv7C3tOfZV9rccKA7+DqscWh1eO1o58hz3ON51ojqFOq1z6nD66uziLHZudB52MXZJcdnl0kdXpUfQN9IvuWJcfVxXuZ5y/eTm7JbjdtTtD3dr90z3evehuWZzeXMPzB3wMPRge+zzkHnSPFM8f/CUeRl4sb2qvZ54G3lzvWu8nzEsGBmMQ4xXPrY+Yp8TPh+YbswVzHZflG+Ab7Fvj5+KX6xfpd9jf0P/dP8G/5EAp4BlAe2BmMDgwC2BfSxdFodVxxoJcglaEXQhmBwcHVwZ/CTEMkQc0hYKhwaFbg19GGYSJgxrCQfhrPCt4Y8izCIWR/wciY2MiKyKfBplF7U8qiuaGr0wuj76fYxPTGnMg1jzWGlsR5xiXHJcXdyHeN/4snhZwpyEFQlXE7UTBYmtSbikuKSapNF5fvO2zxtMdkouSr4z32x+3vzLC7QXZC04vVBxIXvhsRRMSnxKfcoXdji7mj2aykrdlTrCYXJ2cF5wvbnbuMM8D14Z71maR1pZ2lC6R/rW9GG+F7+c/1LAFFQKXmcEZuzN+JAZnnkwczwrPqspG5+dkn1SqCLMFF5YpLcob1GvyEpUJJItdlu8ffGIOFhcI4Ek8yWtOaqIQOqWmku/k/bneuZW5X5cErfkWJ5ynjCve6nl0g1Ln+X75/+4DL2Ms6xjucHy1cv7VzBW7FsJrUxd2bHKaFXhqsGCgILa1cTVmat/WWO7pmzNu7Xxa9sKdQsLCge+C/iuoUihSFzUt8593d716PWC9T0bHDbs3PCtmFt8pcS2pLzky0bOxivf231f8f34prRNPaXOpXs2YzcLN9/Z4rWltky5LL9sYGvo1uZttG3F295tX7j9crlj+d4dxB3SHbKKkIrWncY7N+/8UsmvvF3lU9W0S2fXhl0fdnN339jjvadxr+7ekr2ffxD8cHdfwL7matPq8v3Y/bn7nx6IO9D1I/3HuhrtmpKarweFB2W1UbUX6lzq6up16ksb4AZpw/Ch5EPXD/sebm20btzXpN5UcgQckR55/lPKT3eOBh/tOEY/1njc5PiuE9QTxc1Q89LmkRZ+i6w1sbX3ZNDJjjb3thM/2/x88JTBqarTaqdLzxDPFJ4ZP5t/drRd1P7yXPq5gY6FHQ/OJ5y/dSHyQk9ncOeli/4Xz3cxus5e8rh06rLb5ZNX6Fdarjpfbe526j7xi9MvJ3qce5qvuVxrve56va13bu+ZG143zt30vXnxFuvW1dtht3vvxN6525fcJ7vLvTt0L+ve6/u598ceFDzEPCx+pPSo/LHO4+pfLX5tkjnLTvf79nc/iX7yYIAz8OI3yW9fBgufUp6WP9N/VjdkP3Rq2H/4+vN5zwdfiF6MvSz6Xfn3Xa/MXx3/w/uP7pGEkcHX4tfjbza+1Xp78J3ju47RiNHH77Pfj30o/qj1sfYT/VPX5/jPz8aWfMF9qfhq8bXtW/C3h+PZ4+Mitpg9KQVQyIDT0gB4cxDRDYkAUK8DQJw3pasnDZr6LzBJ4D/xlPaeNGcAGgsACG8HIADx9cgwm5BByPcIbwBivAHs4CAf/zJJmoP9VC1SCyJNysfH3yK6EWcBwNe+8fGxlvHxrzVIs/cBaH8/pecndQyiQHE4jPJ6/wffvhWAf9iU1v/LHv/pwUQHjuCf/k//VhlslQZ9lwAAAIplWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAACQAAAAAQAAAJAAAAABAAOShgAHAAAAEgAAAHigAgAEAAAAAQAAACagAwAEAAAAAQAAACYAAAAAQVNDSUkAAABTY3JlZW5zaG90YWJUtQAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAAdRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDYuMC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6ZXhpZj0iaHR0cDovL25zLmFkb2JlLmNvbS9leGlmLzEuMC8iPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+Mzg8L2V4aWY6UGl4ZWxZRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFhEaW1lbnNpb24+Mzg8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpVc2VyQ29tbWVudD5TY3JlZW5zaG90PC9leGlmOlVzZXJDb21tZW50PgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4K2WZ6jwAAABxpRE9UAAAAAgAAAAAAAAATAAAAKAAAABMAAAATAAABDaphq/YAAADZSURBVFgJ7JYxCoQwEEV/EGzVzsomhaWIBI+gIHgPi5xOays7G2/gBVJYpnO3GnbXRYgWWdikmswkzOMlgbCyFDtOxn5aPdl4s8QcmKFBZ8xQGJwxZ8zUgOn6W3csTVMIIcAYo77TNGFdV5pfDS6B+b6PqqqQZdmh7zAMWJblkDdNGIMlSYK2bRGG4ddeVsCKokBd129H90lnBaxpGuR5TixKKURRBM/zKGcVbH9+OeZ5xjiO6LoOQRDYB+Oco+97enlSSvtgcRxj2zZorcnQT4ARzUvwd2APAAAA//8m/DfZAAAA8klEQVTtlT0ORUAUhY9GK6Eh0Sms4GVWoLYFLYnVKK1CwgLEBiT0KoVSKQovmhuRzPCI95NnqnOc5N5vTiQjMfaYIDiTMAXCMISiKDQhTVOUZUn+qJBusBer++/GDMOAZVlomgZt2+7q7vLGGGNwHIdg8jxHURTkeeJyMN/3oWka7e/7HlEUkeeJy8E8z4NpmrS/6zrEcUyeJ06DBUEAVVVpfpIkqKqKvG3bcF0XsixjHEdkWYa6rinnidNgvMHL7zOUruuY2xqGYRlx9VvAuNsFwe+CzZfaei8FFz8cbTZ2g626vRtbFbJpdzX2if/sa8GeNB869vzSx34AAAAASUVORK5CYII="
    }

}
