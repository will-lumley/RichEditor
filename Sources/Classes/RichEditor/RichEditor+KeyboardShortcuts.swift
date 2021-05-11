//
//  RichEditor+KeyboardShortcuts.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

extension RichEditor: KeyboardShortcutDelegate {

    public func commandPressed(character: CommandShortcut) {
        switch character {
        case .b:
            self.toggleBold()
        case .i:
            self.toggleItalic()
        case .u:
            self.toggleUnderline(.single)
        default:()
        }
    }

}
