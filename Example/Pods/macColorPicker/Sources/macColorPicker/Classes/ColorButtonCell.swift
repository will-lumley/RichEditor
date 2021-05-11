//
//  ColorCell.swift
//  ColorPicker
//
//  Created by William Lumley on 8/12/20.
//

import AppKit

class ColorButtonCell: NSCollectionViewItem {

    // MARK: - Properties

    /// The button that makes up the entirety of this cell
    private var button: NSButton?

    /// The closure that will be called when our button is clicked
    internal var action: (() -> ())?

    /// The button's title
    internal var buttonTitle: String {
        get { self.button?.title ?? "" }
        set { self.button?.title = newValue }
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

        self.button = NSButton(title: "Custom Color", target: self, action: #selector(buttonClicked))
        guard let button = self.button else {
            return
        }

        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.view.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
}

private extension ColorButtonCell {

    @objc
    func buttonClicked() {
        action?()
    }

}
