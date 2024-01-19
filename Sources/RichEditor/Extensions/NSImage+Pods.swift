//
//  UIImage+Pods.swift
//  RichEditor
//
//  Created by William Lumley on 22/6/21.
//

import AppKit

extension NSImage {

    static func podImage(rawName: String, type: String = "png") -> NSImage? {
        let name = rawName + "@3x"

        guard let path = Bundle.module.path(forResource: name, ofType: type) else {
            return nil
        }

        let image = NSImage(contentsOfFile: path)
        return image
    }

}
