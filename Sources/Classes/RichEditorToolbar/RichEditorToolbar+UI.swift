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

    func setupBoldButton() {
        //self.boldButton.image = NSImage.podImage(named: "white-weight-bold")
//        self.boldButton.title = "b"
        self.contentStackView.addArrangedSubview(self.boldButton)
    }

}
