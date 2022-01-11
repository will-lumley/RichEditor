//
//  RichEditorToolbar.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import AppKit
import macColorPicker

class RichEditorToolbar: NSView {

    // MARK: - Properties

    private let richEditor: RichEditor

    internal let contentStackView = NSStackView()

    internal let fontFamiliesPopUpButton = NSPopUpButton(frame: .zero)
    internal let fontSizePopUpButton = NSPopUpButton(frame: .zero)

    internal let boldButton = RichEditorToolbarButton(image: "white-weight-bold")
    internal let italicButton = RichEditorToolbarButton(image: "white-weight-italic")
    internal let underlineButton = RichEditorToolbarButton(image: "white-weight-underline")

    internal let alignLeftButton = RichEditorToolbarButton(image: "white-align-left")
    internal let alignRightButton = RichEditorToolbarButton(image: "white-align-right")
    internal let alignCentreButton = RichEditorToolbarButton(image: "white-align-centre")
    internal let alignJustifyButton = RichEditorToolbarButton(image: "white-align-justify")

    internal let textColorButton = ColorPicker(frame: .zero)
    internal let highlightColorButton = ColorPicker(frame: .zero)

    internal let linkButton = RichEditorToolbarButton(image: "white-text-link")
    internal let listButton = RichEditorToolbarButton(image: "white-text-list")
    internal let strikethroughButton = RichEditorToolbarButton(image: "white-text-strikethrough")
    internal let addImageButton = RichEditorToolbarButton(image: "white-text-image")

    // MARK: - NSView
    init(richEditor: RichEditor) {
        self.richEditor = richEditor

        super.init(frame: .zero)

        self.setupUI()
        self.setup()
    }

    override init(frame frameRect: NSRect) {
        fatalError("RichEditorToolbar does not support init(frame:)")
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("RichEditorToolbar does not support init(coder:)")
    }

    private func setupUI() {
        self.contentStackView.alignment = .centerY
        self.contentStackView.spacing = 8
        self.contentStackView.distribution = .gravityAreas

//        self.contentStackView.wantsLayer = true
//        self.contentStackView.layer?.backgroundColor = NSColor.blue.cgColor

        self.contentStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.contentStackView)

        NSLayoutConstraint.activate([
            self.contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            self.contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
        ])

        self.setupFontUI()
        self.contentStackView.addSeperatorView()
        self.setupWeightButtons()
        self.contentStackView.addSeperatorView()
        self.setupAlignButtons()
        self.contentStackView.addSeperatorView()
        self.setupColorButtons()
        self.contentStackView.addSeperatorView()
        self.setupCustomTextActionButtons()
        self.contentStackView.addSeperatorView()
    }

    private func setup() {

    }
}

// MARK: - RichEditorDelegate

extension RichEditorToolbar: RichEditorDelegate {

    func fontStylingChanged(_ fontStyling: FontStyling) {
        self.configureUI(with: fontStyling)
    }
    
    func richEditorTextChanged(_ richEditor: RichEditor) {
        
    }

}

// MARK: - Actions
internal extension RichEditorToolbar {

    @objc
    func fontFamiliesButtonClicked(_ sender: NSPopUpButton) {
        self.applyFont()
    }

    @objc
    func fontSizeButtonClicked(_ sender: NSPopUpButton) {
        self.applyFont()
    }

    @objc
    func boldButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.toggleBold()
    }

    @objc
    func italicButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.toggleItalic()
    }

    @objc
    func underlineButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.toggleUnderline(.single)
    }

    @objc
    func alignLeftButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.apply(alignment: .left)
    }

    @objc
    func alignCentreButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.apply(alignment: .center)
    }

    @objc
    func alignRightButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.apply(alignment: .right)
    }

    @objc
    func alignJustifyButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.apply(alignment: .justified)
    }

    @objc
    func linkButtonClicked(_ sender: RichEditorToolbarButton) {
        let nameTextField = NSTextField(frame: NSRect(x: 0, y: 28, width: 200, height: 20))
        nameTextField.placeholderString = "Link Name"
        
        let urlTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 20))
        urlTextField.placeholderString = "Link URL"

        let textFieldView = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 48))
        textFieldView.addSubview(nameTextField)
        textFieldView.addSubview(urlTextField)

        let alert = NSAlert()
        alert.messageText = "Please provide the link name and the link URL"
        alert.addButton(withTitle: "Add Link")
        alert.addButton(withTitle: "Cancel")
        alert.accessoryView = textFieldView

        alert.window.initialFirstResponder = nameTextField
        nameTextField.nextKeyView = urlTextField

        let selectedButton = alert.runModal()

        switch selectedButton.rawValue {
        case 1000:
            let name = nameTextField.stringValue
            let url = urlTextField.stringValue

            self.richEditor.insert(link: url, with: name)
        default:
            print("Unknown raw value selected: \(selectedButton)")
        }
    }

    @objc
    func listButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.startBulletPoints()
    }

    @objc
    func strikethroughButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.toggleStrikethrough(.single)
    }

    @objc
    func addImageButtonClicked(_ sender: RichEditorToolbarButton) {
        self.richEditor.promptUserForAttachments(windowForModal: self.window)
    }

}

private extension RichEditorToolbar {

    /**
     Grabs the selected font title and the selected font size, creates an instance of NSFont from them
     and applies it to the RichEditor
    */
    func applyFont() {
        guard let selectedFontNameMenuItem = self.fontFamiliesPopUpButton.selectedItem else {
            return
        }
        
        guard let selectedFontSizeMenuItem = self.fontSizePopUpButton.selectedItem else {
            return
        }
        
        let selectedFontTitle = selectedFontNameMenuItem.title
        let selectedFontSize  = CGFloat((selectedFontSizeMenuItem.title as NSString).doubleValue)
        
        guard let font = NSFont(name: selectedFontTitle, size: selectedFontSize) else {
            return
        }
        
        self.richEditor.apply(font: font)
    }

    func configureUI(with fontStyling: FontStyling) {
        
        //Configure the Bold UI
//        switch (fontStyling.boldTrait) {
//            case .hasTrait:
//                self.boldButton.title = "Unbold"
//
//            case .hasNoTrait:
//                self.boldButton.title = "Bold"
//
//            case .both:
//                self.boldButton.title = "Bold*"
//        }
//
//        //Configure the Italic UI
//        switch (fontStyling.italicsTrait) {
//            case .hasTrait:
//                self.italicsButton.title = "Unitalic"
//
//            case .hasNoTrait:
//                self.italicsButton.title = "Italic"
//
//            case .both:
//                self.italicsButton.title = "Italic*"
//        }
//
//        //Configure the Underline UI
//        switch (fontStyling.underlineTrait) {
//            case .hasTrait:
//                self.underlineButton.title = "Un-underline"
//
//            case .hasNoTrait:
//                self.underlineButton.title = "Underline"
//
//            case .both:
//                self.underlineButton.title = "Underline*"
//        }
//
//        //Configure the Strikethrough UI
//        switch (fontStyling.strikethroughTrait) {
//            case .hasTrait:
//                self.strikeButton.title = "Un-strikethrough"
//
//            case .hasNoTrait:
//                self.strikeButton.title = "Strikethrough"
//
//            case .both:
//                self.strikeButton.title = "Strikethrough*"
//        }
//
//        //Configure the TextColour UI
        let textColours = fontStyling.textColours
        switch (textColours.count) {
            case 0:
                self.textColorButton.selectedColor = NSColor.white

            case 1:
                self.textColorButton.selectedColor = textColours[0]

            case 2:
                self.textColorButton.selectedColor = NSColor.gray

            default:()
        }

        //Configure the HighlightColour UI
        let highlightColours = fontStyling.highlightColours
        switch (highlightColours.count) {
            case 0:
                self.highlightColorButton.selectedColor = NSColor.white

            case 1:
                self.highlightColorButton.selectedColor = highlightColours[0]

            case 2:
                self.highlightColorButton.selectedColor = NSColor.gray

            default:()
        }
        
        //Configure the Fonts UI
        let fonts = fontStyling.fonts
        switch (fonts.count) {
            case 0:
                fatalError("Fonts count is somehow 0: \(fonts)")
            
            case 1:
                self.fontFamiliesPopUpButton.title = fonts[0].displayName ?? fonts[0].fontName
                self.fontSizePopUpButton.title     = "\(fonts[0].pointSize.cleanValue)"

            case 2:
                self.fontFamiliesPopUpButton.title = fonts[0].displayName ?? fonts[0].fontName
                self.fontSizePopUpButton.title     = "\(fonts[0].pointSize.cleanValue)"
                
            default:()
        }
    }

}

// MARK: - NSStackView

private extension NSStackView {

    func addSeperatorView() {
        let seperator = NSView()

        seperator.wantsLayer = true
        seperator.layer?.backgroundColor = NSColor.lightGray.cgColor

        self.addArrangedSubview(seperator)

        seperator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seperator.widthAnchor.constraint(equalToConstant: 1)
        ])
    }

}

// MARK: - ColorPickerDelegate

extension RichEditorToolbar: ColorPickerDelegate {

    func didSelectColor(_ sender: ColorPicker, color: NSColor) {
        switch sender {
        case self.textColorButton:
            self.richEditor.apply(textColour: color)
        case self.highlightColorButton:
            self.richEditor.apply(highlightColour: color)
        default:()
        }
    }

}
