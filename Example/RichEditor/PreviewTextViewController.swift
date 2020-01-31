//
//  PreviewTextViewController.swift
//  RichEditor_Example
//
//  Created by Will Lumley on 30/1/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Cocoa

class PreviewTextViewController: NSViewController
{
    @IBOutlet var previewTextView: NSTextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.previewTextView.isEditable = false
    }
}
