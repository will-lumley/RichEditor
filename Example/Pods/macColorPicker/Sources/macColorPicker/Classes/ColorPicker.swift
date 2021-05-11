//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by William Lumley on 19/02/20.
//  Copyright © 2020 William Lumley. All rights reserved.
//

import AppKit

/// This protocol is used to allow communication from the ColorPicker to the developers project
public protocol ColorPickerDelegate {
    func willOpenColorPicker()
    func didOpenColorPicker()
    func didSelectColor(_ color: NSColor)
}

@IBDesignable open class ColorPicker: NSView {

    // MARK: - Computed Variables

    /// The previously selected color. Used for animation transitions
    private var oldSelectedColor: NSColor?

    /// The colour that has been selected, and is displaying, in our ColorPicker
    public var selectedColor: NSColor? {
        //When the SelectedColor is set, update the ColourPicker's background colour
        get { self.colorPickerViewController.selectedColor }
        set {
            guard let newValue = newValue else {
                return
            }

            self.colorPickerViewController.selectedColor = newValue
            self.delegate?.didSelectColor(newValue)

            if let animationDuration = self.animationDuration {
                let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
                backgroundColorAnimation.fromValue = self.oldSelectedColor?.cgColor
                backgroundColorAnimation.toValue = newValue.cgColor
                backgroundColorAnimation.duration = CFTimeInterval(animationDuration)
                backgroundColorAnimation.isRemovedOnCompletion = false
                backgroundColorAnimation.fillMode = .forwards

                self.layer?.add(backgroundColorAnimation, forKey: "backgroundColor")
            } else {
                self.layer?.removeAnimation(forKey: "backgroundColor")

                self.wantsLayer = true
                self.layer?.backgroundColor = newValue.cgColor
            }

            self.oldSelectedColor = newValue
        }
    }

    /// The colors that we are displaying to the user
    public var colors: [NSColor] {
        get { self.colorPickerViewController.colors }
        set { self.colorPickerViewController.colors = newValue }
    }

    /// The border radius that will surround the selected color's cell
    public var colorCellCornerRadius: CGFloat? {
        get { self.colorPickerViewController.colorCellCornerRadius }
        set { self.colorPickerViewController.colorCellCornerRadius = newValue }
    }

    /// The border color that will surround the selected color's cell
    public var selectedColorCellBorderColor: CGColor {
        get { self.colorPickerViewController.selectedColorCellBorderColor }
        set { self.colorPickerViewController.selectedColorCellBorderColor = newValue }
    }

    /// The border color that will surround the selected color's cell
    public var selectedColorCellBorderWidth: CGFloat {
        get { self.colorPickerViewController.selectedColorCellBorderWidth }
        set { self.colorPickerViewController.selectedColorCellBorderWidth = newValue }
    }

    /// Toggles the existence of the Custom Color button
    public var hideCustomColorButton: Bool {
        get { self.colorPickerViewController.hideCustomColorButton }
        set { self.colorPickerViewController.hideCustomColorButton = newValue }
    }

    /// The title of the Custom Color button
    public var customColorButtonTitle: String {
        get { self.colorPickerViewController.customColorButtonTitle }
        set { self.colorPickerViewController.customColorButtonTitle = newValue }
    }

    /// The layout for our collection view
    public var collectionViewLayout: NSCollectionViewLayout {
        get { self.colorPickerViewController.collectionViewLayout }
        set { self.colorPickerViewController.collectionViewLayout = newValue }
    }

    /// The duration of the animatino that occurs from the original selected color, to the new color. Set to nil for no animation
    public var animationDuration: Double? = 0.12

    // MARK: - Public Properties

    /// If true, the popover will dismiss when a color has been selected
    public var dismissUponColorSelect = true

    /// The size of our popover
    public var popoverContentSize = NSSize(width: 200, height: 110)

    /// The delegate that lets the developer of events
    public var delegate: ColorPickerDelegate?

    /// The edge that the ColorCollectionView will open on your ColorPicker
    public var preferredOpeningEdge: NSRectEdge = .minY

    // MARK: - Private Properties

    /// The ViewController that manages the color selection
    private var colorPickerViewController: ColorPickerViewController
    
    /// The NSPopover that will contain our view that allows users to select different colours
    private let popover = NSPopover()

    // MARK: - ColorPicker

    init() {
        self.colorPickerViewController = ColorPickerViewController()
        super.init(frame: .zero)
        
        self.setup()
    }

    init(colors: [NSColor]) {
        self.colorPickerViewController = ColorPickerViewController()
        self.colorPickerViewController.colors = colors

        super.init(frame: .zero)
        
        self.setup()
    }

    init(colors: [NSColor], collectionViewLayout: NSCollectionViewLayout) {
        self.colorPickerViewController = ColorPickerViewController()
        self.colorPickerViewController.colors = colors
        self.colorPickerViewController.collectionViewLayout = collectionViewLayout

        super.init(frame: .zero)
        
        self.setup()
    }

    public override init(frame frameRect: NSRect) {
        self.colorPickerViewController = ColorPickerViewController()
        super.init(frame: frameRect)
        
        self.setup()
    }

    public required init?(coder: NSCoder) {
        self.colorPickerViewController = ColorPickerViewController()
        super.init(coder: coder)
        
        self.setup()
    }

    open override func mouseUp(with event: NSEvent) {
        if self.window != nil {
            self.popover.contentSize = self.popoverContentSize
            self.popover.contentViewController = self.colorPickerViewController
            self.popover.behavior = .transient
            self.popover.animates = true
        }

        self.delegate?.willOpenColorPicker()

        if self.window != nil {
            self.popover.show(relativeTo: self.bounds, of: self, preferredEdge: self.preferredOpeningEdge)
        }

        self.delegate?.didOpenColorPicker()
    }
    
    private func setup() {
        self.wantsLayer = true

        self.colorPickerViewController.delegate = self

        self.wantsLayer = true
        self.layer?.cornerRadius = 12
    }

}

// MARK: - ColorPickerViewControllerDelegate

extension ColorPicker: ColorPickerViewControllerDelegate {

    func didSelectColor(_ color: NSColor) {
        self.selectedColor = color

        if self.dismissUponColorSelect {
            self.popover.close()
        }
    }

}
