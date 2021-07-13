//
//  RichEditor+Attachments.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import Foundation

public extension RichEditor {

    func promptUserForAttachments(windowForModal: NSWindow?) {
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
    
    func insertAttachments(at urls: [URL]) {
        self.textView.layoutManager?.defaultAttachmentScaling = NSImageScaling.scaleProportionallyDown
        
        print("Inserting attachments at URLs: \(urls)")
        
        //Iterate over every URL and create a NSTextAttachment from it
        for url in urls {

            //Get a copy of the data and insert it into our Caches folder
            /*----------------------------------------------------------------*/
            let imageID = "\(UUID().uuidString).\(url.pathExtension)"

            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                continue
            }
            let directoryURL = documentDirectory.appendingPathComponent("com.lumley.richeditor")

            try! FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)

            let imageData = try! Data(contentsOf: url)
            let imageURL = directoryURL.appendingPathComponent(imageID)

            try! imageData.write(to: imageURL)

            //Create and store a base64 encoded copy of our image for our HTML output
            let image = NSImage(data: imageData)
            guard let base64Str = image?.base64String(for: imageURL.imageType) else {
                continue
            }
            self.imageAttachments[imageID] = base64Str
            /*----------------------------------------------------------------*/

            let attachment = imageURL.textAttachment
            let attachmentAttrStr = NSAttributedString(attachment: attachment)

            print("")
            print("ImageID: \(imageID)")
            print("DirectoryURL: \(directoryURL)")
            print("ImageURL: \(imageURL)")
            print("Attachment: \(attachment)")
            print("")

            self.textView.textStorage?.append(attachmentAttrStr)
        }
    }

}
