//
//  NSImage+Inversion.swift
//  RichEditor
//
//  Created by William Lumley on 15/1/2022.
//

import AppKit

public extension NSImage {

    var inverted: NSImage? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("Could not create CGImage from NSImage")
            return nil
        }

        guard let filter = CIFilter(name: "CIColorInvert") else {
            print("Could not create CIColorInvert filter")
            return nil
        }

        let ciImage = CIImage(cgImage: cgImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else {
            print("Could not obtain output CIImage from filter")
            return nil
        }

        guard let outputCgImage = outputImage.cgImage else {
            print("Could not create CGImage from CIImage")
            return nil
        }

        return NSImage(cgImage: outputCgImage, size: self.size)
    }
}
