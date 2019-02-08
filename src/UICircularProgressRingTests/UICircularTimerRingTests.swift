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

        timerRing.startTimer(to: 0.1) { (finished, _) in
            XCTAssertTrue(finished)
            normalExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testPauseTimer() {
        let pauseExpectation = self.expectation(description: "pauses and gives elapsed time")

        timerRing.startTimer(to: 0.2) { (finished, elapsedTime) in
            XCTAssertFalse(finished)
            pauseExpectation.fulfill()
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

        timerRing.startTimer(to: 0.3) { (finished, elapsedTime) in
            print("finished: \(finished)")
            XCTAssertEqual(expectedFinish, finished)
            if expectedFinish {
                continueExpectation.fulfill()
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
