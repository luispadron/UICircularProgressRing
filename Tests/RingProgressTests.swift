//
//  RingProgressTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis on 5/29/20.
//

import XCTest

@testable import UICircularProgressRing

final class RingProgressTests: XCTestCase {
    func test_isIndeterminate_SHOULD_beIndeterminate_WHEN_indeterminate() {
        let sut = RingProgress.indeterminate
        XCTAssertTrue(sut.isIndeterminate)
    }

    func test_isIndeterminate_SHOULD_NOT_beIndeterminate_WHEN_percent() {
        let sut = RingProgress.percent(0.5)
        XCTAssertFalse(sut.isIndeterminate)
    }

    func test_asDouble_SHOULD_beNil_WHEN_isIndeterminate() {
        let sut = RingProgress.indeterminate
        XCTAssertNil(sut.asDouble)
    }

    func test_asDouble_SHOULD_beDouble_WHEN_percent() {
        let sut = RingProgress.percent(0.5)
        XCTAssertEqual(sut.asDouble, 0.5)
    }
}
