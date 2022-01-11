//
//  RichEditorToolbar+UI.swift
//  macColorPicker
//
//  Created by William Lumley on 6/6/21.
//

import Foundation

internal extension RichEditorToolbar {

    func setupFontUI() {
        self.fontFamiliesPopUpButton.menu = NSMenu.fontsMenu()
        self.fontFamiliesPopUpButton.target = self
        self.fontFamiliesPopUpButton.action = #selector(fontFamiliesButtonClicked(_:))

        self.fontSizePopUpButton.menu = NSMenu.fontSizesMenu()
        self.fontSizePopUpButton.target = self
        self.fontSizePopUpButton.action = #selector(fontSizeButtonClicked(_:))

        self.contentStackView.addArrangedSubview(self.fontFamiliesPopUpButton)
        self.contentStackView.addArrangedSubview(self.fontSizePopUpButton)

        NSLayoutConstraint.activate([
            self.fontFamiliesPopUpButton.widthAnchor.constraint(equalToConstant: 125)
        ])
    }

    func setupWeightButtons() {
        self.contentStackView.addArrangedSubview(self.boldButton)
        self.contentStackView.addArrangedSubview(self.italicButton)
        self.contentStackView.addArrangedSubview(self.underlineButton)

        self.boldButton.target = self
        self.boldButton.action = #selector(boldButtonClicked(_:))

        self.italicButton.target = self
        self.italicButton.action = #selector(italicButtonClicked(_:))

        self.underlineButton.target = self
        self.underlineButton.action = #selector(underlineButtonClicked(_:))
    }

    func setupAlignButtons() {
        self.contentStackView.addArrangedSubview(self.alignLeftButton)
        self.contentStackView.addArrangedSubview(self.alignCentreButton)
        self.contentStackView.addArrangedSubview(self.alignRightButton)
        self.contentStackView.addArrangedSubview(self.alignJustifyButton)

        self.alignLeftButton.target = self
        self.alignLeftButton.action = #selector(alignLeftButtonClicked(_:))

        self.alignCentreButton.target = self
        self.alignCentreButton.action = #selector(alignCentreButtonClicked(_:))

        self.alignRightButton.target = self
        self.alignRightButton.action = #selector(alignRightButtonClicked(_:))

        self.alignJustifyButton.target = self
        self.alignJustifyButton.action = #selector(alignJustifyButtonClicked(_:))
    }

    func setupColorButtons() {
        self.contentStackView.addArrangedSubview(self.textColorButton)
        self.contentStackView.addArrangedSubview(self.highlightColorButton)

        self.textColorButton.delegate = self
        self.highlightColorButton.delegate = self

        NSLayoutConstraint.activate([
            self.textColorButton.widthAnchor.constraint(equalToConstant: 24),
            self.textColorButton.heightAnchor.constraint(equalToConstant: 24),

            self.highlightColorButton.widthAnchor.constraint(equalToConstant: 24),
            self.highlightColorButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    func setupCustomTextActionButtons() {
        self.contentStackView.addArrangedSubview(self.linkButton)
        self.contentStackView.addArrangedSubview(self.listButton)
        self.contentStackView.addArrangedSubview(self.strikethroughButton)
        self.contentStackView.addArrangedSubview(self.addImageButton)

        self.linkButton.target = self
        self.linkButton.action = #selector(linkButtonClicked(_:))

        self.listButton.target = self
        self.listButton.action = #selector(listButtonClicked(_:))

        self.strikethroughButton.target = self
        self.strikethroughButton.action = #selector(strikethroughButtonClicked(_:))

        self.addImageButton.target = self
        self.addImageButton.action = #selector(addImageButtonClicked(_:))
    }
}
