//
//  RichEditorToolbarButton.swift
//  RichEditor
//
//  Created by William Lumley on 22/6/21.
//

import Cocoa

class RichEditorToolbarButton: NSButton {

    // MARK: - Types

    struct ButtonImage {
        let unselectedLight: NSImage
        let unselectedDark: NSImage
        let selected: NSImage
    }

    // MARK: - Properties

    private var imageName: String
    private let buttonImage: ButtonImage

    var selected: Bool {
        didSet {
            self.loadImage()
        }
    }

    // MARK: - NSButton

    init(imageName: String, selectedTint: NSColor = .systemBlue) {
        self.imageName = imageName
        self.selected = false

        // All images provided to us are dark by default
        guard let darkImage = NSImage.podImage(rawName: imageName) else {
            fatalError("Failed to create image for RichEditorToolbarButton with image name: \(imageName)")
        }

        // Create a light version
        guard let lightImage = darkImage.inverted else {
            fatalError("Failed to invert image for RichEditorToolbarButton with image name: \(imageName)")
        }

        // Create a selected version
        guard let selectedImage = darkImage.createOverlay(color: selectedTint) else {
            fatalError("Failed to overlay for image for RichEditorToolbarButton with image name: \(imageName)")
        }

        self.buttonImage = ButtonImage(
            unselectedLight: lightImage,
            unselectedDark: darkImage,
            selected: selectedImage
        )

        super.init(frame: .zero)

        self.setup()
        self.loadImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(macOS 10.14, *)
    override func viewDidChangeEffectiveAppearance()
    {
        super.viewDidChangeEffectiveAppearance()
        self.loadImage()
    }

    private func setup() {
        self.isBordered = false
        self.isTransparent = false

        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.clear.cgColor
    }

    internal func loadImage() {

        if #available(macOS 10.14, *) {
            // If we're selected, show the selected image
            if self.selected {
                self.image = self.buttonImage.selected
            }
            
            // We're not selected, show the light or dark mode image
            else if self.isDarkMode {
                self.image = self.buttonImage.unselectedDark
            }
            
            else if self.isDarkMode == false {
                self.image = self.buttonImage.unselectedLight
            }
        }
        else {
            // If we're selected, show the selected image
            if self.selected {
                self.image = self.buttonImage.selected
            }
            
            // We're not selected, show the light or dark mode image
            else {
                self.image = self.buttonImage.unselectedLight
            }
        }
    }
}
