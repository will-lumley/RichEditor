//
//  ColorCell.swift
//  ColorPicker
//
//  Created by William Lumley on 8/12/20.
//

import AppKit

class ColorCell: NSCollectionViewItem {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            self.updateAppearance()
        }
    }

    internal var color: NSColor? {
        didSet {
            self.view.layer?.backgroundColor = self.color?.cgColor
        }
    }

    internal var cornerRadius: CGFloat? {
        didSet {
            self.view.layer?.cornerRadius = self.cornerRadius ?? self.view.bounds.width / 2
        }
    }

    internal var borderColor: CGColor? {
        didSet {
            self.updateAppearance()
        }
    }

    internal var borderWidth: CGFloat? {
        didSet {
            self.updateAppearance()
        }
    }

    // MARK: - NSCollectionViewItem

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        self.view.wantsLayer = true

        self.view.layer?.cornerRadius = self.cornerRadius ?? self.view.bounds.width / 2
    }

    private func updateAppearance() {
        self.view.wantsLayer = true

        if isSelected {
            self.view.layer?.borderWidth = self.borderWidth ?? 2.0
            self.view.layer?.borderColor = self.borderColor ?? NSColor.white.cgColor
        } else {
            self.view.layer?.borderWidth = 0.0
            self.view.layer?.borderColor = nil
        }
    }
}
