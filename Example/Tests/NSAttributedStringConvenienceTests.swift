//
//  NSAttributedStringConvenienceTests.swift
//  RichEditor_Tests
//
//  Created by William Lumley on 22/1/2022.
//  Copyright © 2022 William Lumley. All rights reserved.
//

import XCTest

class NSAttributedStringConvenienceTests: XCTestCase {

    var testSubject: NSAttributedString!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        self.testSubject = nil
    }

    func testAttributes() {
        let font = NSFont.boldSystemFont(ofSize: 12)
        let colour = NSColor.green.cgColor

        self.testSubject = NSAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .font: font,
                .foregroundColor: colour
            ]
        )

        XCTAssertEqual(self.testSubject.attributes.count, 2)

        XCTAssertEqual(self.testSubject.attributes[.font] as! NSFont, font)
        XCTAssertEqual(self.testSubject.attributes[.foregroundColor] as! CGColor, colour)
    }

    func testAllFonts() {
        let boldFont = NSFont.boldSystemFont(ofSize: 12)
        let font = NSFont.systemFont(ofSize: 15)

        let mutableAttrStr = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .font: font,
            ]
        )
        mutableAttrStr.addAttribute(.font, value: boldFont, range: NSRange(location: 7, length: 4))

        XCTAssertEqual(mutableAttrStr.allFonts, [
            font,
            boldFont,
        ])

    }

}
