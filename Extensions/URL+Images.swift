//
//  URL+Generics.swift
//  RichEditor
//
//  Created by William Lumley on 26/3/18.
//  Copyright © 2018 Kampana. All rights reserved.
//

import Foundation
import AppKit

extension URL
{
    public var icon: NSImage {
        let icon = NSWorkspace.shared.icon(forFile: self.path)
        return icon
    }
    
    public func textAttachment() -> NSTextAttachment
    {
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
}

