//
//  DictionaryTypingAttributesTests.swift
//  RichEditor_Tests
//
//  Created by William Lumley on 22/1/2022.
//  Copyright © 2022 William Lumley. All rights reserved.
//

import XCTest

class DictionaryTypingAttributesTests: XCTestCase {

    var underlinedTestSubject: [NSAttributedString.Key: Any]!
    var strikeThroughTestSubject: [NSAttributedString.Key: Any]!

    override func setUpWithError() throws {
        self.underlinedTestSubject = [
            NSAttributedString.Key.underlineStyle: NSNumber(value: NSUnderlineStyle.double.rawValue)
        ]

        self.strikeThroughTestSubject = [
            NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.double.rawValue)
        ]
    }

    override func tearDownWithError() throws {
        self.underlinedTestSubject = nil
        self.strikeThroughTestSubject = nil
    }

    func testCheckCanFindPositiveCases() {
        let isUnderlined = self.underlinedTestSubject.check(attribute: .underlineStyle) { $0 == 0 }
        let isStriked = self.strikeThroughTestSubject.check(attribute: .strikethroughStyle) { $0 == 0 }

        XCTAssertTrue(isUnderlined)
        XCTAssertTrue(isStriked)
    }

    func testCheckCanFindNegativeCases() {
        let isUnderlined = self.strikeThroughTestSubject.check(attribute: .underlineStyle) { $0 == 0 }
        let isStriked = self.underlinedTestSubject.check(attribute: .strikethroughStyle) { $0 == 0 }

        XCTAssertFalse(isUnderlined)
        XCTAssertFalse(isStriked)
    }

}
