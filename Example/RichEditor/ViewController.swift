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
    
    @IBOutlet weak var boldButton: NSButton!
    @IBOutlet weak var italicsButton: NSButton!
    @IBOutlet weak var underlineButton: NSButton!
    
    @IBOutlet var imageButton: NSButton!
    @IBOutlet var textColorWell: NSColorWell!
    @IBOutlet var addLinkButton: NSButton!
    
    
    @IBOutlet weak var highlightColorPicker: ColorPicker!
    @IBOutlet var strikeButton: NSButton!
    @IBOutlet weak var bulletPointButton: NSButton!
    
    @IBOutlet weak var fontFamiliesPopUpButton: NSPopUpButton!
    @IBOutlet weak var fontSizePopUpButton: NSPopUpButton!
    
    /// This window displays the HTML, that was sourced from the RichEditor.html() function
    private var previewTextViewController : PreviewTextViewController?
    
    /// This window displays the NSAttributedString, that was sourced from HTML
    private var previewTextViewController2: PreviewTextViewController?
    
    /// This window displays the HTML from the RawHTML
    private var previewWebViewController: PreviewWebViewController?
    
    // MARK: - NSViewController

    deinit
    {
        self.textColorWell.removeObserver(self, forKeyPath: "color")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.configureUI()
        
        //self.openPreviewTextWindow()
        //self.openPreviewWebWindow()
        //self.openPreviewTextWindow2()
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        self.view.window?.title = "1. Rich Editor"
    }
    
    private func configureUI()
    {
        //self.textColourButton.delegate = self
        //self.highlightColourButton.delegate = self
        
        self.richEditor.richEditorDelegate = self
        //self.richEditor.textView.string      = "The quick brown fox jumped over the lazy dog."
        //self.richEditor.textView.importsGraphics = false
        
        self.textColorWell.color = self.richEditor.textView.textColor ?? NSColor.white
        self.textColorWell.addObserver(self, forKeyPath: "color", options: [.new, .old], context: nil)
        
        self.highlightColorPicker.selectedColor = .clear
        self.highlightColorPicker.delegate = self
        
        self.boldButton.title    = "Bold"
        self.italicsButton.title = "Italic"
        
        self.fontFamiliesPopUpButton.menu = NSMenu.fontsMenu(nil)
        self.fontSizePopUpButton.menu     = NSMenu.fontSizesMenu(nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        //If our TextColorWell changed it's colour
        if object as? NSColorWell == self.textColorWell && keyPath == "color" {
            guard let old = change?[.oldKey] as? NSColor else { return }
            guard let new = change?[.newKey] as? NSColor else { return }
            
            let colourHasChanged = old != new
            
            if colourHasChanged {
                self.richEditor.apply(textColour: self.textColorWell.color)
            }
        }
    }
}

// MARK: - Actions
extension ViewController {

    @IBAction
    func boldButtonTapped(_ sender: Any) {
        self.richEditor.toggleBold()
    }
    
    @IBAction
    func italicButtonTapped(_ sender: Any) {
        self.richEditor.toggleItalic()
    }
    
    @IBAction
    func underlineButtonTapped(_ sender: Any) {
        self.richEditor.toggleUnderline(.styleSingle)
    }
    
    @IBAction
    func linkButtonTapped(_ sender: Any) {
        let name = "Google"
        let url  = "https://google.com"
        
        self.richEditor.insert(link: url, with: name, at: nil)
    }
    
    @IBAction
    func addImageButtonTapped(_ sender: Any) {
        self.richEditor.promptUserForAttachments(windowForModal: self.view.window)
    }
    
    @IBAction
    func strikeButtonTapped(_ sender: Any) {
        self.richEditor.toggleStrikethrough(.styleSingle)
    }
    
    @IBAction
    func bulletPointButtonTapped(_ sender: Any) {
        self.richEditor.startBulletPoints()
    }
    
    @IBAction
    func fontFamiliesButtonClicked(_ sender: Any) {
        self.applyFont()
    }
    
    @IBAction
    func fontSizeButtonClicked(_ sender: Any) {
        self.applyFont()
    }

}

// MARK: - RichEditorDelegate
extension ViewController: RichEditorDelegate {

    func fontStylingChanged(_ fontStyling: FontStyling) {
        self.configureTextActionButtonsUI()
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
        
        //Parse the HTML into a WebView and display the contents
        self.previewWebViewController?.webView.loadHTMLString("Hello there", baseURL: Bundle.main.bundleURL)
        
        //Assign the raw HTML text so we can see the actual HTML content
        self.previewTextViewController?.previewTextView.string = html
        
        //Convert the HTML text back into an NSAttributedString and have it displayed
        _ = self.previewTextViewController2?.previewTextView.set(html: html)

    }

}

// MARK: - Functions
private extension ViewController {

    func configureTextActionButtonsUI() {
        let fontStyling = self.richEditor.fontStyling
        
        //Configure the Bold UI
        switch (fontStyling.boldTrait) {
            case .hasTrait:
                self.boldButton.title = "Unbold"
            
            case .hasNoTrait:
                self.boldButton.title = "Bold"
            
            case .both:
                self.boldButton.title = "Bold*"
        }
        
        //Configure the Italic UI
        switch (fontStyling.italicsTrait) {
            case .hasTrait:
                self.italicsButton.title = "Unitalic"
            
            case .hasNoTrait:
                self.italicsButton.title = "Italic"
            
            case .both:
                self.italicsButton.title = "Italic*"
        }
        
        //Configure the Underline UI
        switch (fontStyling.underlineTrait) {
            case .hasTrait:
                self.underlineButton.title = "Un-underline"
            
            case .hasNoTrait:
                self.underlineButton.title = "Underline"
            
            case .both:
                self.underlineButton.title = "Underline*"
        }
        
        //Configure the Strikethrough UI
        switch (fontStyling.strikethroughTrait) {
            case .hasTrait:
                self.strikeButton.title = "Un-strikethrough"
                
            case .hasNoTrait:
                self.strikeButton.title = "Strikethrough"
            
            case .both:
                self.strikeButton.title = "Strikethrough*"
        }
        
        //Configure the TextColour UI
        let textColours = fontStyling.textColours
        switch (textColours.count) {
            case 0:
                self.textColorWell.color = NSColor.white
            
            case 1:
                self.textColorWell.color = textColours[0]
            
            case 2:
                self.textColorWell.color = NSColor.gray
            
            default:()
        }
        
        //Configure the HighlightColour UI
        let highlightColours = fontStyling.highlightColours
        switch (highlightColours.count) {
            case 0:
                self.highlightColorPicker.selectedColor = NSColor.white
                
            case 1:
                self.highlightColorPicker.selectedColor = highlightColours[0]
            
            case 2:
                self.highlightColorPicker.selectedColor = NSColor.gray
            
            default:()
        }
        
        //Configure the Fonts UI
        let fonts = fontStyling.fonts
        switch (fonts.count) {
            case 0:
                fatalError("Fonts count is somehow 0: \(fonts)")
            
            case 1:
                self.fontFamiliesPopUpButton.title = fonts[0].displayName ?? fonts[0].fontName
                self.fontSizePopUpButton.title     = "\(fonts[0].pointSize.cleanValue)"

            case 2:
                self.fontFamiliesPopUpButton.title = fonts[0].displayName ?? fonts[0].fontName
                self.fontSizePopUpButton.title     = "\(fonts[0].pointSize.cleanValue)"
                
            default:()
        }
        
    }
    
    func openPreviewTextWindow() {
        let storyboardID = NSStoryboard.SceneIdentifier("PreviewWindowController")
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "2. Raw HTML"
        previewWindowController.showWindow(self)
        
        self.previewTextViewController = previewWindowController.contentViewController as? PreviewTextViewController
    }

    func openPreviewWebWindow() {
        let storyboardID = NSStoryboard.SceneIdentifier("PreviewWebWindowController")
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "3. Parsed HTML"
        previewWindowController.showWindow(self)
        
        self.previewWebViewController = previewWindowController.contentViewController as? PreviewWebViewController
    }
    
    func openPreviewTextWindow2() {
        let storyboardID = NSStoryboard.SceneIdentifier("PreviewWindowController")
        let previewWindowController = self.storyboard!.instantiateController(withIdentifier: storyboardID) as! NSWindowController
        previewWindowController.window?.title = "4. Text From HTML"
        previewWindowController.showWindow(self)
        
        self.previewTextViewController2 = previewWindowController.contentViewController as? PreviewTextViewController
    }
    
    /**
     Grabs the selected font title and the selected font size, creates an instance of NSFont from them
     and applies it to the RichTextView
    */
    func applyFont() {
        guard let selectedFontNameMenuItem = self.fontFamiliesPopUpButton.selectedItem else {
            return
        }
        
        guard let selectedFontSizeMenuItem = self.fontSizePopUpButton.selectedItem else {
            return
        }
        
        let selectedFontTitle = selectedFontNameMenuItem.title
        let selectedFontSize  = CGFloat((selectedFontSizeMenuItem.title as NSString).doubleValue)
        
        guard let font = NSFont(name: selectedFontTitle, size: selectedFontSize) else {
            return
        }
        
        self.richEditor.apply(font: font)
    }

}

// MARK: - ColorPickerDelegate
extension ViewController: ColorPickerDelegate {

    func willOpenColorPicker() {
        
    }

    func didOpenColorPicker() {
        
    }

    func didSelectColor(_ color: NSColor) {
        self.richEditor.apply(highlightColour: color)
    }

}
