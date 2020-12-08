//
//  RichEditor+Attachments.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

extension RichEditor {

    public func promptUserForAttachments(windowForModal: NSWindow?) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories    = false
        openPanel.canCreateDirectories    = false
        openPanel.canChooseFiles          = true
        
        if let window = windowForModal {
            openPanel.beginSheetModal(for: window, completionHandler: {(modalResponse) in
                if modalResponse == NSApplication.ModalResponse.OK {
                    let selectedURLs = openPanel.urls
                    self.insertAttachments(at: selectedURLs)
                }
            })
        }
        else {
            openPanel.begin(completionHandler: {(modalResponse) in
                if modalResponse == NSApplication.ModalResponse.OK {
                    let selectedURLs = openPanel.urls
                    self.insertAttachments(at: selectedURLs)
                }
            })
        }
    }
    
    public func insertAttachments(at urls: [URL]) {
        self.textView.layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        
        print("Inserting attachments at URLs: \(urls)")
        
        //Iterate over every URL and create a NSTextAttachment from it
        for url in urls {
            let attachment = url.textAttachment
            let attachmentAttrStr = NSAttributedString(attachment: attachment)
            
            self.textView.textStorage?.append(attachmentAttrStr)
        }
    }

}
