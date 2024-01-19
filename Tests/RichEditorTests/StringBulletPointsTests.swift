//
//  StringBulletPointsTests.swift
//  RichEditor_Tests
//
//  Created by William Lumley on 23/1/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

@testable import RichEditor
import XCTest

class StringBulletPointsTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testIsBulletPoint() {
        let testSubject1 = "\(RichEditor.bulletPointMarker) Hello there"
        let testSubject2 = "Hello there"
        let testSubject3 = "Hello \(RichEditor.bulletPointMarker) Hello there"

        XCTAssertTrue(testSubject1.isBulletPoint)
        XCTAssertFalse(testSubject2.isBulletPoint)
        XCTAssertFalse(testSubject3.isBulletPoint)
    }

    func testIsPrefixedWithTab() {
        let testSubject1 = "\tHello there"
        let testSubject2 = "Hello \t there \t"
        let testSubject3 = "Hello there"

        XCTAssertTrue(testSubject1.isPrefixedWithTab)
        XCTAssertFalse(testSubject2.isPrefixedWithTab)
        XCTAssertFalse(testSubject3.isPrefixedWithTab)
    }

    func testPrefixedStringCount() {
        let testSubject1 = "\tHello there"
        let testSubject2 = "\t\tHello there"
        let testSubject3 = "\t\t\t\tHello there\t\t"
        let testSubject4 = "Hello \t there \t"
        let testSubject5 = "Hello there"
        let testSubject6 = "\t\t=Hello there"

        XCTAssertEqual(testSubject1.prefixedStringCount(needle: "\t"), 1)
        XCTAssertEqual(testSubject2.prefixedStringCount(needle: "\t"), 2)
        XCTAssertEqual(testSubject3.prefixedStringCount(needle: "\t"), 4)
        XCTAssertEqual(testSubject4.prefixedStringCount(needle: "\t"), 0)
        XCTAssertEqual(testSubject5.prefixedStringCount(needle: "\t"), 0)
        XCTAssertEqual(testSubject6.prefixedStringCount(needle: "=", ignoring: [Character("\t")]), 1)
    }

    func testLines() {
        let testSubject = "Hello there\nHow now\nBrown Cow"

        XCTAssertEqual(testSubject.lines.count, 3)

        XCTAssertEqual(testSubject.lines[0], "Hello there")
        XCTAssertEqual(testSubject.lines[1], "How now")
        XCTAssertEqual(testSubject.lines[2], "Brown Cow")
    }

    func testRepeated() {
        let testSubject1 = "1"
        let testSubject2 = "2"
        let testSubject3 = "3"
        let testSubject4 = "4"

        XCTAssertEqual(testSubject1.repeated(1), "1")
        XCTAssertEqual(testSubject2.repeated(2), "22")
        XCTAssertEqual(testSubject3.repeated(3), "333")
        XCTAssertEqual(testSubject4.repeated(0), "")
    }

    func testRemoveFirst() {
        var testSubject1 = "Hello there Hello"
        var testSubject2 = "Hello Hello world"
        var testSubject3 = "Hello there foo"
        var testSubject4 = "\t\tTesting"

        testSubject1.removeFirst(needle: "Hello ")
        testSubject2.removeFirst(needle: "Hello ")
        testSubject3.removeFirst(needle: "foobar")
        testSubject4.removeFirst(needle: "\t")

        XCTAssertEqual(testSubject1, "there Hello")
        XCTAssertEqual(testSubject2, "Hello world")
        XCTAssertEqual(testSubject3, "Hello there foo")
        XCTAssertEqual(testSubject4, "\tTesting")
    }

}
