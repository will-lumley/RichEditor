//
//  PreviewTextViewController.swift
//  RichEditor_Example
//
//  Created by Will Lumley on 30/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa
import RichEditor

class PreviewTextViewController: NSViewController {

    @IBOutlet var previewTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previewTextView.isEditable = false
    }

    func display(richEditor: RichEditor) {
        var htmlOpt: String?
        
        do {
            htmlOpt = try richEditor.html()
        }
        catch let error {
            print("Error creating HTML from NSAttributedString: \(error)")
        }
        
        guard var html = htmlOpt else {
            print("HTML from NSAttributedString was nil")
            return
        }
        
        html = html.replacingOccurrences(of: "\n", with: "")

        self.previewTextView.string = html
    }

}
