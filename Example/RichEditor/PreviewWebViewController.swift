//
//  PreviewWebViewController.swift
//  RichEditor_Example
//
//  Created by Will Lumley on 30/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa
import WebKit

class PreviewWebViewController: NSViewController
{
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

//MARK: - WKNavigation Delegate
extension PreviewWebViewController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("WKWebView did finish loading: \(String(describing: navigation))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        print("WKWebView Error: \(error)")
    }
}
