//
//  TimerRingTimeUnitTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis Padron on 6/9/20.
//

import XCTest

@testable import UICircularProgressRing

final class TimerRingTimeUnitTests: XCTestCase {
    func test_minutes_SHOULD_convertTimeIntervalCorrectly() {
        let sut = TimerRingTimeUnit.minutes(60)
        XCTAssertEqual(sut.timeInterval, 3600)
    }

    func test_seconds_SHOULD_convertTimeIntervalCorrectly() {
        let sut = TimerRingTimeUnit.seconds(60)
        XCTAssertEqual(sut.timeInterval, 60)
    }

    func test_milliseconds_SHOULD_convertTimeIntervalCorrectly() {
        let sut = TimerRingTimeUnit.milliseconds(1337)
        XCTAssertEqual(sut.timeInterval, 1.337)
    }
}
