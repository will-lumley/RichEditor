// swift-tools-version:5.5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RichEditor",
    platforms: [
        .macOS(.v10_15) // Replace with your minimum supported macOS version
    ],
    products: [
        .library(
            name: "RichEditor",
            targets: [
                "RichEditor"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/will-lumley/macColorPicker.git", from: "1.2.3")
    ],
    targets: [
        .target(
            name: "RichEditor",
            dependencies: [
                "macColorPicker"
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "RichEditorTests", dependencies: ["RichEditor"]),
    ]
)
