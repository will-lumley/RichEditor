//
//  DictionaryTypingAttributesTests.swift
//  RichEditor_Tests
//
//  Created by William Lumley on 22/1/2022.
//  Copyright © 2022 William Lumley. All rights reserved.
//

import XCTest
import RichEditor

class CGFloatFormattingTests: XCTestCase {

    var testSubject: CGFloat!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDown() {
        super.tearDown()
        self.testSubject = nil
    }

    func testCleanValue() {
        testSubject = CGFloat(3.0)

        XCTAssertEqual(testSubject.cleanValue, "3")
    }

    func testUncleanValue() {
        testSubject = CGFloat(3.22)

        XCTAssertEqual(testSubject.cleanValue, "3.22")
    }

}

