//
//  ViewController.swift
//  RichEditor_Example
//
//  Created by Will Lumley on 30/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import AppKit
import RichEditor
import macColorPicker

class ViewController: NSViewController
{
    @IBOutlet weak var richEditor: RichEditor!
    
    /// This window displays the HTML, that was sourced from the RichEditor.html() function
    private var previewTextViewController: PreviewTextViewController?
    
    /// This window displays the HTML from the RawHTML
    private var previewWebViewController: PreviewWebViewController?
    
    // MARK: - NSViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.openPreviewTextWindow()
        self.openPreviewWebWindow()
        
        self.richEditor.richEditorDelegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "1. Rich Editor"
    }
    
    func openPreviewTextWindow() {
        let storyboardID = "PreviewWindowController"
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "2. Raw HTML"
        previewWindowController.showWindow(self)
        
        self.previewTextViewController = previewWindowController.contentViewController as? PreviewTextViewController
    }

    func openPreviewWebWindow() {
        let storyboardID = "PreviewWebWindowController"
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "3. Parsed HTML"
        previewWindowController.showWindow(self)
        
        self.previewWebViewController = previewWindowController.contentViewController as? PreviewWebViewController
    }

}

// MARK: - RichEditorDelegate

extension ViewController: RichEditorDelegate {

    func fontStylingChanged(_ fontStyling: FontStyling) {
        
    }
    
    func richEditorTextChanged(_ richEditor: RichEditor) {
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
        
        // Parse the HTML into a WebView and display the contents
        self.previewWebViewController?.webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL) // 3. Parsed HTML
        
        // Assign the raw HTML text so we can see the actual HTML content
        self.previewTextViewController?.previewTextView.string = html // 2. Raw HTML
    }

}
