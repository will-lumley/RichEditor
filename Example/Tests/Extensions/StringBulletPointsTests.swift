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

    func testLines() {
        let testSubject = "Hello there\nHow now\nBrown Cow"

        XCTAssertEqual(testSubject.lines.count, 3)

        XCTAssertEqual(testSubject.lines[0], "Hello there")
        XCTAssertEqual(testSubject.lines[1], "How now")
        XCTAssertEqual(testSubject.lines[2], "Brown Cow")
    }

}
