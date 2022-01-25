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

However if you want to use a template UI, `RichEditor` has one last trick up its sleeve for you. Simply call the `configureToolbar()` from your instance of `RichEditor` and you will have our pre-made toolbar ready to go! 

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
