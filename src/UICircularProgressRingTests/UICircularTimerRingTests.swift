//
//  UICircularTimerRingTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis on 2/8/19.
//  Copyright © 2019 Luis Padron. All rights reserved.
//

import XCTest
@testable import UICircularProgressRing

class UICircularTimerRingTests: XCTestCase {

    var timerRing: UICircularTimerRing!

    override func setUp() {
        timerRing = UICircularTimerRing()
    }

    func testStartTimer() {
        let normalExpectation = self.expectation(description: "Completion on start")

        timerRing.startTimer(to: 0.1) { state in
            switch state {
            case .finished:
                normalExpectation.fulfill()
            default:
                XCTFail()
            }
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testPauseTimer() {
        let pauseExpectation = self.expectation(description: "pauses and gives elapsed time")

        timerRing.startTimer(to: 0.5) { state in
            switch state {
            case .finished, .continued:
                XCTFail()
            case .paused(let elapsedTime):
                XCTAssertNotEqual(elapsedTime, 0.0)
                pauseExpectation.fulfill()
            }
        }

        // wait 0.1 seconds
        usleep(100000)
        timerRing.pauseTimer()

        //Wait for the expactation to fulfill
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testContinueTimer() {
        let continueExpectation = self.expectation(description: "should pause then continue and finish")


        var expectedFinish = false

        timerRing.startTimer(to: 0.3) { state in
            switch state {
            case .finished:
                if expectedFinish { continueExpectation.fulfill() }
            default: break
            }
        }

        // wait 0.1 seconds
        usleep(100000)
        timerRing.pauseTimer()

        // wait 0.1 seconds
        usleep(100000)
        expectedFinish = true
        timerRing.continueTimer()

        //Wait for the expactation to fulfill
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
