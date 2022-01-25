![RichEditor: Customisable NSTextview WYSIWYG Editor](https://raw.githubusercontent.com/will-lumley/RichEditor/main/RichEditor.png)

# RichEditor

![CI Status](https://github.com/will-lumley/RichEditor/actions/workflows/BuildTests.yml/badge.svg?branch=main)
[![Version](https://img.shields.io/cocoapods/v/RichEditor.svg?style=flat)](https://cocoapods.org/pods/RichEditor)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/RichEditor.svg?style=flat)](https://cocoapods.org/pods/FaviconFinder)
[![License](https://img.shields.io/cocoapods/l/RichEditor.svg?style=flat)](https://cocoapods.org/pods/FaviconFinder)
[![Twitter](https://img.shields.io/badge/twitter-@wlumley95-blue.svg?style=flat)](https://twitter.com/wlumley95)

RichEditor is a WYSIWYG editor written in pure Swift. RichEditor is a direct subclass of `NSTextView` so you'll feel perfectly comfortable using it.

If you are developing a macOS application that uses an `NSTextView` and you want your users to be able to format their text, you are forced to use the `usesInspectorBar` property, which adds a formatting toolbar to your `NSTextView`.

However if you want to modify the UI or modify functionality at all, you'll soon find a dead-end. This is where `RichEditor` comes in.

Just drag `RichEditor` into your UI, and you can use RichEditors functionality to easily programatically control which parts of your text are formatted and how. From bolding and underlining to text alignment and text colour, you have control over your text view. You can create your own UI the way you want and connect your UI to the `RichEditor` functionality.

However if you want to use a template UI, RichEditor has one last trick up its sleeve for you. Simply call the `configureToolbar()` from your instance of `RichEditor` and you will have our pre-made toolbar ready to go! 

RichEditor also handles the difficult logic of handling text formatting when a user has already highlighted a piece of text, or when you want to export the text with HTML formatting.

RichEditor allows you to control:
- [x] Bolding
- [x] Italics
- [x] Underlining
- [x] Font Selection
- [x] Font Size Selection
- [x] Text Alignment (Left, Centre, Right, Justified)
- [x] Text Colour
- [x] Text Highlight Colour
- [x] Link Insertion
- [x] Bullet Points
- [x] Text Strikethrough
- [x] Attachment Insertion

To do:
- [ ] Implement better bullet point formatting

## Usage

RichEditor is a direct subclass of `NSTextView` and as such, you can drag `NSTextView` into your storyboard and subclass it there, or you can directly instantiate `RichEditor` directly in your code using the initialisers from `NSTextView`. 

### Exporting

RichEditor allows you to export the content of the `RichEditor` as a HTML. You can do this as follows.
```swift
let html = try richEditor.html()
```

`html()` returns an optional `String` type, and will `throw` in the event of an error.

### Format Types

Below is a walkthrough of formatting that RichEditor allows you to use. 

----

Bold:
`richEditor.toggleBold()`

----

Italic:
`richEditor.toggleItalic()`

----

----

Underline:
`richEditor.toggleUnderline(.single)`
`toggleUnderline(_)` takes `NSUnderlineStyle` as an argument, so you can specify which underline style should be applied.

----

----

Strikethrough:
`richEditor.toggleStrikethrough(.single)`
`toggleStrikethrough(_)` takes `NSUnderlineStyle` as an argument, so you can specify which underline style should be applied with your strikethrough.

----

----

Text Colour:
`richEditor.applyColour(textColour: .green)`
`applyColour(textColour:)` takes `NSColor` as an argument, so you can specify which colour should be applied.

----

----

Text Highlighy Colour:
`richEditor.applyColour(highlightColour: .green)`
`applyColour(highlightColour:)` takes `NSColor` as an argument, so you can specify which colour should be applied.

----

----

Font:
`richEditor.apply(font: .systemFont(ofSize: 12))`
`applyColour(font:)` takes `NSFont` as an argument, so you can specify which font should be applied.

----

----

Text Alignment:
`richEditor.apply(alignment: .left)`
`applyColour(alignment:)` takes `NSTextAlignment` as an argument, so you can specify which alignment should be applied.

----

----

Links:
`richEditor.insert(link: url, with: name)`
`insert(link:, with:, at:)` takes a `URL` as an argument, so you can specify which alignment should be applied. 
A `String` is also taken for how you want this link to appear to the user. 
An optional `Int` argument can also be supplied which indicates what index of the `NSTextView`s string the link should be insert at. If nil, the link will be appended to the end of the string.

----

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

FaviconFinder supports iOS 10.0 and above & macOS 10.10 and above.

## Installation

### Cocoapods
RichEditor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RichEditor', '1.0.0'
```

### Carthage
RichEditor is also available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your RichEditor:

```ruby
github "will-lumley/RichEditor" == 1.0.0
```

### Swift Package Manager
RichEditor is also available through [Swift Package Manager](https://github.com/apple/swift-package-manager). 
To install it, simply add the dependency to your Package.Swift file:

```swift
...
dependencies: [
    .package(url: "https://github.com/will-lumley/RichEditor.git", from: "1.0.0"),
],
targets: [
    .target( name: "YourTarget", dependencies: ["RichEditor"]),
]
...
```
## Author

[William Lumley](https://lumley.io/), will@lumley.io

## License

RichEditor is available under the MIT license. See the LICENSE file for more info.
