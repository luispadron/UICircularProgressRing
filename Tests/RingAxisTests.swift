//
//  RingAxisTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis Padron on 5/29/20.
//

import SwiftUI
import XCTest

@testable import UICircularProgressRing

final class RingAxisTests: XCTestCase {
    func test_top_angleIs_270() {
        let sut = RingAxis.top
        XCTAssertEqual(sut.angle, .degrees(270))
    }

    func test_bottom_angleIs_90() {
        let sut = RingAxis.bottom
        XCTAssertEqual(sut.angle, .degrees(90))
    }

    func test_leading_angleIs_180() {
        let sut = RingAxis.leading
        XCTAssertEqual(sut.angle, .degrees(180))
    }

    func test_top_angleIs_0() {
        let sut = RingAxis.trailing
        XCTAssertEqual(sut.angle, .degrees(0))
    }
}
