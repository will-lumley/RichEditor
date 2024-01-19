//
//  NSAttributedStringConvenienceTests.swift
//  RichEditor_Tests
//
//  Created by William Lumley on 22/1/2022.
//  Copyright © 2022 William Lumley. All rights reserved.
//

import XCTest

class NSAttributedStringConvenienceTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {

    }

    func testAttributes() {
        let font = NSFont.boldSystemFont(ofSize: 12)
        let colour = NSColor.green.cgColor

        let testSubject = NSAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .font: font,
                .foregroundColor: colour
            ]
        )

        XCTAssertEqual(testSubject.attributes.count, 2)

        XCTAssertEqual(testSubject.attributes[.font] as! NSFont, font)
        XCTAssertEqual(testSubject.attributes[.foregroundColor] as! CGColor, colour)
    }

    func testAllFonts() {
        let boldFont = NSFont.boldSystemFont(ofSize: 12)
        let font = NSFont.systemFont(ofSize: 15)

        let testSubject = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .font: font,
            ]
        )
        testSubject.addAttribute(.font, value: boldFont, range: NSRange(location: 7, length: 4))

        XCTAssertEqual(testSubject.allFonts, [
            font,
            boldFont,
        ])
    }

    func testAllAlignments() {
        let leftAlignment = NSTextAlignment.left
        let rightAlignment = NSTextAlignment.right

        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.alignment = leftAlignment

        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.alignment = rightAlignment

        let testSubject = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .paragraphStyle: paragraphStyle1
            ]
        )
        testSubject.addAttribute(.paragraphStyle, value: paragraphStyle2, range: NSRange(location: 7, length: 4))

        XCTAssertEqual(testSubject.allAlignments, [
            leftAlignment,
            rightAlignment,
        ])
    }

    func testAllTextColours() {
        let green = NSColor.green
        let red = NSColor.red

        let testSubject = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .foregroundColor: green
            ]
        )
        testSubject.addAttribute(.foregroundColor, value: red, range: NSRange(location: 7, length: 4))

        XCTAssertEqual(testSubject.allTextColours, [
            green,
            red,
        ])
    }

    func testAllHighlightColours() {
        let green = NSColor.green
        let red = NSColor.red

        let testSubject = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .backgroundColor: green
            ]
        )
        testSubject.addAttribute(.backgroundColor, value: red, range: NSRange(location: 7, length: 4))

        XCTAssertEqual(testSubject.allHighlightColours, [
            green,
            red,
        ])
    }

    func testAllAttachments() {
        let attachment = NSTextAttachment(data: nil, ofType: "jpg")

        let testSubject = NSMutableAttributedString(string: "Lorem Ipsum")
        testSubject.addAttribute(.attachment, value: attachment, range: NSRange(location: 7, length: 4))

        XCTAssertEqual(testSubject.allAttachments, [
            attachment,
        ])
    }

    func testContainsFontTrait() {
        let font = NSFont.systemFont(ofSize: 12)
        let boldFont = NSFont.boldSystemFont(ofSize: 12)

        let testSubject = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .font: font,
            ]
        )
        testSubject.addAttribute(.font, value: boldFont, range: NSRange(location: 7, length: 4))

        XCTAssertTrue(testSubject.contains(trait: .boldFontMask))
        XCTAssertFalse(testSubject.contains(trait: .italicFontMask))
    }

    func testDoesNotContainFontTrait() {
        let font = NSFont.systemFont(ofSize: 12)
        let boldFont = NSFont.boldSystemFont(ofSize: 12)

        let testSubject = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .font: font,
            ]
        )
        testSubject.addAttribute(.font, value: boldFont, range: NSRange(location: 7, length: 4))

        XCTAssertTrue(testSubject.doesNotContain(trait: .italicFontMask))
        XCTAssertFalse(testSubject.doesNotContain(trait: .boldFontMask))
    }

    func testCheck() {
        let boldFont = NSFont.boldSystemFont(ofSize: 12)

        let testSubject = NSMutableAttributedString(
            string: "Lorem Ipsum",
            attributes: [
                .underlineStyle: NSNumber(value: NSUnderlineStyle.double.rawValue),
            ]
        )
        testSubject.addAttribute(.font, value: boldFont, range: NSRange(location: 7, length: 4))

        let underline = testSubject.check(attribute: .underlineStyle)
        let textColour = testSubject.check(attribute: .foregroundColor)
        let font = testSubject.check(attribute: .font)

        XCTAssertTrue(underline.atParts)
        XCTAssertFalse(underline.notAtParts)

        XCTAssertFalse(textColour.atParts)
        XCTAssertTrue(textColour.notAtParts)

        XCTAssertTrue(font.atParts)
        XCTAssertTrue(font.notAtParts)
    }
}
