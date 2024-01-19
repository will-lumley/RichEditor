//
//  URL+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 26/3/18.
//  Copyright © 2018 William Lumley. All rights reserved.
//

import Foundation
import AppKit

public extension URL {

    var icon: NSImage {
        let icon = NSWorkspace.shared.icon(forFile: self.path)
        return icon
    }
    
    var textAttachment: NSTextAttachment {
        //var data: Data?
        var fileWrapper: FileWrapper?
        
        do {
            //data = try Data(contentsOf: self)
            fileWrapper = try FileWrapper(url: self, options: FileWrapper.ReadingOptions.immediate)
        }
        catch let error {
            print("Failed to create Data or FileWrapper object from URL: \(self), error: \(error)")
        }

        let attachment = NSTextAttachment(fileWrapper: fileWrapper)
        return attachment
    }

    var imageType: NSBitmapImageRep.FileType {
        switch self.pathExtension.uppercased() {
        case "JPG", "JPEG":
            return .jpeg
        case "PNG":
            return .png
        case "TIFF":
            return .tiff
        case "GIF":
            return .gif
        case "BMP":
            return .bmp
        default:
            return .png
        }
    }
}
