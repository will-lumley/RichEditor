//
//  PreviewWebViewController.swift
//  RichEditor_Example
//
//  Created by Will Lumley on 30/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa
import RichEditor
import WebKit

class PreviewWebViewController: NSViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
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

        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let directoryURL = documentDirectory.appendingPathComponent("com.lumley.richeditor")

        print("BaseURL: \(directoryURL)")
        self.webView.loadHTMLString(html, baseURL: directoryURL)
    }

}

// MARK: - WKNavigation Delegate

extension PreviewWebViewController: WKNavigationDelegate {

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
