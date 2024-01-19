import class Foundation.Bundle

extension Foundation.Bundle {
    static let module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("RichEditor_RichEditor.bundle").path
        let buildPath = "/Users/will/Documents/Dev/Projects/OpenSource/will-lumley/RichEditor/.build/arm64-apple-macosx/debug/RichEditor_RichEditor.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}