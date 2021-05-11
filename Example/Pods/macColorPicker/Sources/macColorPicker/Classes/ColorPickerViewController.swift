//
//  ColourPickerViewController.swift
//  ColorPicker
//
//  Created by William Lumley on 25/2/20.
//

import AppKit

/// This protocol is used internally to allow communication from the ColorPickerViewController to the ColorPicker
internal protocol ColorPickerViewControllerDelegate {
    func didSelectColor(_ color: NSColor)
}

internal class ColorPickerViewController: NSViewController {

    // MARK: - Properties

    /// The colours that we are displaying to the user
    internal var colors: [NSColor] {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The colour that has been selected, and is displaying, in our ColorPicker
    internal var selectedColor: NSColor? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The border radius that will surround the selected color's cell
    internal var colorCellCornerRadius: CGFloat? {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The border color that will surround the selected color's cell
    internal var selectedColorCellBorderColor: CGColor {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The border color that will surround the selected color's cell
    internal var selectedColorCellBorderWidth: CGFloat {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// Toggles the existence of the Custom Color button
    internal var hideCustomColorButton: Bool {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The layout for our CollectionView
    internal var collectionViewLayout: NSCollectionViewLayout {
        didSet {
            self.collectionView.reloadData()
        }
    }

    /// The title of the Custom Color button
    internal var customColorButtonTitle: String {
        didSet {
            // If we don't have this button enabled, don't change it's title
            if self.hideCustomColorButton == false {
                return
            }

            // Only reload the custom color section
            let customColorSection = IndexSet(integer: 1)
            self.collectionView.reloadSections(customColorSection)
        }
    }

    /// The delegate for our ColorPicker
    internal var delegate: ColorPickerViewControllerDelegate?

    // MARK: - Private Properties
    
    /// The ScrollView for our CollectionView
    private let scrollView = NSScrollView()
    
    /// The CollectionView that displays our colours
    private let collectionView = NSCollectionView()
    
    /// The cell identifier that we're using with our CollectionView for colors
    private let colorCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ColorCellIdentifier")

    /// The cell identifier that we're using with our CollectionView for our custom color button
    private let buttonCellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "ButtonCellIdentifier")

    // MARK: - NSViewController

    init() {
        self.colors = NSColor.allSystemColors
        self.colorCellCornerRadius = nil
        self.selectedColorCellBorderColor = NSColor.white.cgColor
        self.selectedColorCellBorderWidth = CGFloat(2.0)
        self.hideCustomColorButton = true
        self.customColorButtonTitle = "Custom Color"

        let layout = NSCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10.0
        layout.sectionInset = NSEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        self.collectionViewLayout = layout

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("ColorPickerViewController does not load from XIB/Storyboard")
    }

    open override func loadView() {
        self.view = NSView()
    }

    open override func viewDidAppear() {
        super.viewDidAppear()

        self.configureCollectionViewPresentation()
        self.configureCollectionView()
    }

    private func configureCollectionViewPresentation() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)

        let constraints = [
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)

        self.scrollView.documentView = self.collectionView
    }

    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = self.collectionViewLayout
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.backgroundColors = [.clear]
        self.collectionView.isSelectable = true

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.collectionView.register(ColorCell.self, forItemWithIdentifier: self.colorCellIdentifier)
        self.collectionView.register(ColorButtonCell.self, forItemWithIdentifier: self.buttonCellIdentifier)
    }

}

// MARK: - Functions
private extension ColorPickerViewController {

    @objc
    func showColorPanelButtonTapped() {
        let colorPanel = NSColorPanel.shared
        colorPanel.setTarget(self)
        colorPanel.setAction(#selector(colorDidChage(sender:)))
        colorPanel.makeKeyAndOrderFront(self)
        colorPanel.isContinuous = true
    }

    @objc
    func colorDidChage(sender: NSColorPanel) {
        self.delegate?.didSelectColor(sender.color)
    }

}

// MARK: - NSCollectionViewDataSource

extension ColorPickerViewController: NSCollectionViewDataSource {

    public func numberOfSections(in collectionView: NSCollectionView) -> Int {
        self.hideCustomColorButton ? 2 : 1
    }

    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        /// The section that contains the colors
        case 0:
            return self.colors.count
        /// The section that contains the custom color button
        case 1:
            return 1
        /// Ignore anything else
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        switch indexPath.section {
        /// The section that contains the colors
        case 0:
            let cell = collectionView.makeItem(withIdentifier: self.colorCellIdentifier, for: indexPath) as! ColorCell
            let color = self.colors[indexPath.item]
            
            cell.color = color
            cell.borderWidth = self.selectedColorCellBorderWidth
            cell.borderColor = self.selectedColorCellBorderColor
            cell.cornerRadius = self.colorCellCornerRadius

            if color == self.selectedColor {
                cell.isSelected = true
            }

            return cell

        /// The section that contains the custom color button
        case 1:
            let cell = collectionView.makeItem(withIdentifier: self.buttonCellIdentifier, for: indexPath) as! ColorButtonCell
            cell.buttonTitle = self.customColorButtonTitle
            cell.action = { [unowned self] in
                if self.hideCustomColorButton {
                    self.showColorPanelButtonTapped()
                }
            }

            return cell

        /// Ignore anything else
        default:
            fatalError()
        }
    }

}

// MARK: - NSCollectionViewDelegate

extension ColorPickerViewController: NSCollectionViewDelegate {

    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else {
            return
        }

        let color = self.colors[indexPath.item]
        self.delegate?.didSelectColor(color)
    }

}

// MARK: - NSCollectionViewDelegateFlowLayout

extension ColorPickerViewController: NSCollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        switch indexPath.section {
        /// The section that contains the colors
        case 0:
            return NSSize(width: 20, height: 20)
        /// The section that contains the custom color button
        case 1:
            let widthOfButton = self.collectionView.bounds.size.width * 0.75
            return NSSize(width: widthOfButton, height: 20)
        /// Ignore anything else
        default:
            return NSSize.zero
        }
    }

}
