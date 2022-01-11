//
//  RichEditor+Alignment.swift
//  RichEditor
//
//  Created by William Lumley on 11/1/2022.
//

import Foundation

public extension RichEditor {

    func toggleAlignment(with alignment: NSTextAlignment) {
        self.toggleTextView(
            with: .paragraphStyle,
            negativeValue: NSMutableParagraphStyle.styleWithDefaultAlignment,
            positiveValue: NSMutableParagraphStyle.style(with: alignment)
        )
    }

}

private extension NSMutableParagraphStyle {

    static var styleWithDefaultAlignment: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        return paragraphStyle
    }

    static func style(with alignment: NSTextAlignment) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        return paragraphStyle
    }

}
