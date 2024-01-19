//
//  NSImage+ColourOverlay.swift
//  RichEditor
//
//  Created by William Lumley on 15/1/2022.
//

import AppKit

public extension NSImage {

    func createOverlay(color: NSColor) -> NSImage? {
        guard let tinted = self.copy() as? NSImage else {
            return nil
        }
        tinted.lockFocus()
        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: self.size)
        imageRect.fill(using: .sourceAtop)

        tinted.unlockFocus()
        return tinted
    }

}
