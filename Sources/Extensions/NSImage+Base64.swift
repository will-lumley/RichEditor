//
//  NSImage+Base64.swift
//  RichEditor
//
//  Created by William Lumley on 13/7/21.
//

import Foundation

extension NSImage {

    func base64String(for imageType: NSBitmapImageRep.FileType) -> String? {
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(self.size.width),
            pixelsHigh: Int(self.size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
            ) else {
                print("Couldn't create bitmap representation.")
                return nil
        }

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        self.draw(at: NSZeroPoint, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()

        guard let data = rep.representation(using: imageType, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]) else {
            print("Couldn't create image")
            return nil
        }

        let base64Str = data.base64EncodedString()
        return "data:image/\(imageType.fileType); base64, \(base64Str)"
    }

}

private extension NSBitmapImageRep.FileType {

    var fileType: String {
        switch self {
        case .jpeg, .jpeg2000:
            return "jpg"
        case .bmp:
            return "bmp"
        case .gif:
            return "gif"
        case .png:
            return "png"
        case .tiff:
            return "tiff"
        @unknown default:
            return "png"
        }
    }
}
