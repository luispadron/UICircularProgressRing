//
//  UICircularProgressRingPauseResetTests.swift
//  UICircularProgressRingTests
//
//  Created by Miley Hollenberg on 15/08/2018.
//  Copyright © 2018 Luis Padron. All rights reserved.
//

// A seperate test case just for the completion block, since it's a timing based test it does not work will with the other regular tests
// It does require the use of usleep (or a different sleep method) to ensure that the pauseProgress actually has any effect
// and isn't premeturely firing it's completion block

import Foundation

import XCTest
@testable import UICircularProgressRing

class UICircularProgressRingPauseResetTests: XCTestCase {

    var progressRing: UICircularProgressRing!

    override func setUp() {
        super.setUp()
        progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    }

    override func tearDown() {
        super.tearDown()
    }

    func testStartProgress() {
        //* Test the happy flow after the initial reset to ensure that nothing has been broken by the reset
        //Create an expectation
        let normalExpectation = self.expectation(description: "Completion on start")

        //Start a new progress animation
        progressRing.startProgress(to: 100, duration: 0.1, completion: {
            //Should be called
            normalExpectation.fulfill()
        })

        //Wait for the expactation to fulfill
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testResetProgress() {
        //* Test the resetProgress
        //Start the progress
        progressRing.startProgress(to: 100, duration: 0.1, completion: {
            //Should not be called due to the resetProgress
            XCTAssert(false)
        })

        // Reset the progress
        progressRing.resetProgress()

        // Sleep for 0.2 seconds
        usleep(20000)
    }

    func testPauseProgress() {
        //* Test the pauseProgress
        //Store the current time to compare later on
        let startTime = CACurrentMediaTime()
        var stopTime: CFTimeInterval?

        //Create a new expectation
        let pauseExpectation = self.expectation(description: "Completion after pause")

        //Start a new progress animation
        progressRing.startProgress(to: 100, duration: 0.1, completion: {
            //Should be called later than the 0.1 duration, this will be checked at the end of this test
            pauseExpectation.fulfill()
            stopTime = CACurrentMediaTime()
        })

        //Pause the animation
        progressRing.pauseProgress()

        //Sleep for 0.1 second
        usleep(100 * 1000)

        //Restart the animation
        progressRing.continueProgress()

        //Wait for the excpectation
        waitForExpectations(timeout: 0.5, handler: nil)

        //Check the time difference between the start and stop times
        let difference = stopTime! - startTime
        XCTAssertGreaterThan(difference, 0.2)
    }
}
