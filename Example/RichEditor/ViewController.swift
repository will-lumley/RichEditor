//
//  ViewController.swift
//  RichEditor_Example
//
//  Created by Will Lumley on 30/1/20.
//  Copyright © 2020 William Lumley. All rights reserved.
//

import AppKit
import RichEditor
import macColorPicker

class ViewController: NSViewController {

    @IBOutlet weak var richEditor: RichEditor!

    private var previewViewController: PreviewViewController?

    // MARK: - NSViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.openPreviewWindow()
        self.richEditor.richEditorDelegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "1. Rich Editor"
    }
    
    func openPreviewWindow() {
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: "PreviewWindowController") as! NSWindowController
        previewWindowController.window?.title = "Preview"
        previewWindowController.showWindow(self)
        
        self.previewViewController = previewWindowController.contentViewController as? PreviewViewController
        self.previewViewController?.richEditor = self.richEditor
    }

}

// MARK: - RichEditorDelegate

extension ViewController: RichEditorDelegate {

    func fontStylingChanged(_ textStyling: TextStyling) {
        
    }
    
    func richEditorTextChanged(_ richEditor: RichEditor) {
        // Parse the HTML into a WebView and display the contents
//        self.previewWebViewController?.display(richEditor: richEditor)
//
//        // Assign the raw HTML text so we can see the actual HTML content
//        self.previewTextViewController?.display(richEditor: richEditor)
    }
    
}
