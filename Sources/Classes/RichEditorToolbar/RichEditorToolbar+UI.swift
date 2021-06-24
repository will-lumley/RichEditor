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
    }

}
