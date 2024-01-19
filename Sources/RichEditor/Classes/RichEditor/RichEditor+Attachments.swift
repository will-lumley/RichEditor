//
//  RichEditor+Attachments.swift
//  RichEditor
//
//  Created by William Lumley on 7/12/20.
//

import AppKit

public extension RichEditor {

    static var attachmentsDirectory: URL {

        // Get the documents directory
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }

        // Create our own subdirectory within the documents directory
        let directoryURL = documentDirectory.appendingPathComponent("com.lumley.richeditor")

        // Create the directory, if it doesn't exist
        if FileManager.default.fileExists(atPath: directoryURL.path) == false {
            try! FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        }

        return directoryURL
    }

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
        self.textView.layoutManager?.defaultAttachmentScaling = .scaleProportionallyDown

        print("Inserting attachments at URLs: \(urls)")

        //Iterate over every URL and create a NSTextAttachment from it
        for url in urls {

            //Get a copy of the data and insert it into our attachments folder
            /*----------------------------------------------------------------*/
            let imageID = "\(UUID().uuidString).\(url.pathExtension)"
            let directoryURL = RichEditor.attachmentsDirectory

            let imageData = try! Data(contentsOf: url)
            let imageURL = directoryURL.appendingPathComponent(imageID)

            try! imageData.write(to: imageURL)
            /*----------------------------------------------------------------*/

            let attachment = imageURL.textAttachment
            let attachmentAttrStr = NSAttributedString(attachment: attachment)

            self.textView.textStorage?.append(attachmentAttrStr)
        }
    }

}
