//
//  RichEditor+KeyboardShortcuts.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

extension RichEditor: KeyboardShortcutDelegate {

    public func commandPressed(character: CommandShortcut) -> Bool {
        switch character {
        case .b:
            self.toggleBold()
            return true
        case .i:
            self.toggleItalic()
            return true
        case .u:
            self.toggleUnderline(.single)
            return true
        default:
            return false
        }
    }

}
