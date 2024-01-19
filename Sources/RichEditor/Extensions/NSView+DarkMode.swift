//
//  NSView+DarkMode.swift
//  RichEditor
//
//  Created by William Lumley on 17/1/2022.
//

import AppKit

@available(macOS 10.14, *)
internal extension NSView {

    var isDarkMode: Bool {
        self.effectiveAppearance.name == .darkAqua
    }

}
