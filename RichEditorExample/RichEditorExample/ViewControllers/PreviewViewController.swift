//
//  PreviewViewController.swift
//  RichEditor
//
//  Created by William Lumley on 13/7/21.
//  Copyright © 2021 William Lumley. All rights reserved.
//

import Cocoa
import RichEditor
import WebKit

class PreviewViewController: NSViewController {

    enum ContentType {
        case webView
        case textView

        var otherType: ContentType {
            switch self {
            case .textView: return .webView
            case .webView: return .textView
            }
        }
    }

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet var textView: NSTextView!

    @IBOutlet weak var loadHtmlButton: NSButton!
    @IBOutlet weak var toggleContentTypeButton: NSButton!

    internal var richEditor: RichEditor?

    private var contentType: ContentType = .webView {
        didSet {
            switch self.contentType {
            case .textView:
                self.textView.isHidden = false
                self.webView.isHidden = true

                self.toggleContentTypeButton.title = "Display HTML"
            case .webView:
                self.textView.isHidden = true
                self.webView.isHidden = false

                self.toggleContentTypeButton.title = "Display Raw HTML"
            }
        }
    }

    // MARK: - NSViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentType = .webView

        self.webView.navigationDelegate = self
        self.textView.isEditable = false
    }
    
}

// MARK: - Actions

extension PreviewViewController {

    @IBAction func loadHtmlButtonClicked(_ sender: Any) {
        guard let richEditor = self.richEditor else {
            return
        }

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

        self.textView.string = html

        guard let htmlData = html.data(using: .utf8) else {
            return
        }

        let directoryURL = RichEditor.attachmentsDirectory
        let htmlFileURL = directoryURL.appendingPathComponent("index.html")

        try! htmlData.write(to: htmlFileURL)

        self.webView.loadFileURL(htmlFileURL, allowingReadAccessTo: directoryURL)
    }
    
    @IBAction func toggleContentTypeButtonClicked(_ sender: Any) {
        self.contentType = self.contentType.otherType
    }

}

// MARK: - WKNavigation Delegate

extension PreviewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WKWebView did finish loading")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WKWebView Error: \(error)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("WKWebView ContentProcessDidTerminate")
    }

}
