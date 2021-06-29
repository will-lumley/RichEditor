//
//  UIImage+Pods.swift
//  RichEditor
//
//  Created by William Lumley on 22/6/21.
//

import AppKit

extension NSImage {

    static func podImage(named: String) -> NSImage? {
        let bundle = Bundle(for: RichEditor.classForCoder())

        guard let bundleURL = bundle.resourceURL?.appendingPathComponent("Resources.bundle") else {
            return nil
        }
        guard let resourceBundle = Bundle(url: bundleURL) else {
            return nil
        }

        let image = resourceBundle.image(forResource: named)
        return image
    }

}
