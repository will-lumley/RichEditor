//
//  DictionaryTypingAttributesTests.swift
//  RichEditor_Tests
//
//  Created by William Lumley on 22/1/2022.
//  Copyright © 2022 William Lumley. All rights reserved.
//

import XCTest
import RichEditor

class DictionaryMergeTests: XCTestCase {

    var testSubject: [String: String]!

    override func setUpWithError() throws {
        try super.setUpWithError()

        self.testSubject = [
            "foo": "bar",
            "key": "value"
        ]
    }
    
    override func tearDown() {
        super.tearDown()

        self.testSubject = nil
    }
    
    func testNewValue() {
        self.testSubject.merge(newDict: [
            "new": "value"
        ])

        XCTAssertEqual(self.testSubject.count, 3)
        XCTAssertEqual(self.testSubject["new"], "value")
    }

    func testOverriteValue() {
        self.testSubject.merge(newDict: [
            "foo": "newValue"
        ])

        XCTAssertEqual(self.testSubject.count, 2)
        XCTAssertEqual(self.testSubject["foo"], "newValue")
    }

}

