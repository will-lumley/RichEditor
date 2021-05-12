![ColorPicker: Elegant Color Picking](https://raw.githubusercontent.com/will-lumley/macColorPicker/main/ColorPicker.png)

# ColorPicker

[![CI Status](https://api.travis-ci.com/will-lumley/macColorPicker.svg?branch=main)](https://travis-ci.org/will-lumley/macColorPicker)
[![Version](https://img.shields.io/cocoapods/v/macColorPicker.svg?style=flat)](https://cocoapods.org/pods/macColorPicker)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Platform](https://img.shields.io/cocoapods/p/macColorPicker.svg?style=flat)](https://cocoapods.org/pods/macColorPicker)
[![License](https://img.shields.io/cocoapods/l/macColorPicker.svg?style=flat)](https://cocoapods.org/pods/macColorPicker)
[![Twitter](https://img.shields.io/badge/twitter-@wlumley95-blue.svg?style=flat)](https://twitter.com/wlumley95)

macColorPicker is a tiny, pure Swift library designed for macOS applications that allows you to let your users easily choose a color.

macColorPicker allows you to present the user with a preset range of colors to choose from. As the developer, you get to choose how these are formatted, how they look, and what happens when a user makes a selection.
If you want to give the user more control, you can allow them to select a button that presents the `NSColorPanel`.

## Usage

macColorPicker is simply a subclass of `NSView` so you can simply add ColorPicker like you would any other view, whether it be to your storyboard, XIB, or just in code. 
Configuring ColorPicker's `delegate` allows you to be notified when the ColorPicker view is about to be presented, when is has been presented, or when a user has selected a color.


https://user-images.githubusercontent.com/14086082/116811221-6fd58480-ab8b-11eb-9e3f-a19fb3f83caa.mov

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

macColorPicker supports macOS 10.12 and above.

## Installation

### Cocoapods
macColorPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'macColorPicker', '~> 1.2.2'
```

### Carthage
macColorPicker is also available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```ruby
github "will-lumley/ColorPicker" == 1.2.2
```

### Swift Package Manager
macColorPicker is also available through [Swift Package Manager](https://github.com/apple/swift-package-manager). 
To install it, simply add the dependency to your Package.Swift file:

```swift
...
dependencies: [
    .package(url: "https://github.com/will-lumley/macColorPicker.git", from: "1.2.2"),
],
targets: [
    .target( name: "YourTarget", dependencies: ["macColorPicker"]),
]
...
```
## Author

[William Lumley](https://lumley.io/), will@lumley.io

## License

macColorPicker is available under the MIT license. See the LICENSE file for more info.
