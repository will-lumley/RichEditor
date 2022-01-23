//
//  NSFontTraitsTests.swift
//  RichEditor_Tests
//
//  Created by William Lumley on 23/1/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import XCTest

class NSFontTraitsTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testContains() {
        let boldFont = NSFont.boldSystemFont(ofSize: 12)
        let font = NSFont.systemFont(ofSize: 15)

        XCTAssertFalse(font.contains(trait: .boldFontMask))
        XCTAssertTrue(boldFont.contains(trait: .boldFontMask))

        XCTAssertFalse(font.contains(trait: .italicFontMask))
        XCTAssertFalse(boldFont.contains(trait: .italicFontMask))
    }
}
