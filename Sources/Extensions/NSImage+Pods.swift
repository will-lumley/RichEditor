//
//  UIImage+Pods.swift
//  RichEditor
//
//  Created by William Lumley on 22/6/21.
//

import AppKit

extension NSImage {
//
//    convenience init?(podAssetName: String) {
//        let podBundle = Bundle(for: RichEditor.self)
//
//        /// A given class within your Pod framework
//        guard let url = podBundle.url(forResource: "CryptoContribute",
//                                      withExtension: "bundle") else {
//            return nil
//
//        }
//
//        self.init(named: podAssetName,
//                  in: Bundle(url: url),
//                  compatibleWith: nil)
//    }

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
