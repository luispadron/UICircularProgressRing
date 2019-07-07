//
//  UICircularProgressRingTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis Padron on 9/13/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import XCTest
@testable import UICircularProgressRing

class UICircularProgressRingTests: XCTestCase {

    var progressRing: UICircularProgressRing!

    override func setUp() {
        super.setUp()
        progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    }

    override func tearDown() {
        super.tearDown()
    }

    func testApiAndAnimations() {

        progressRing.startProgress(to: 23.1, duration: 0)
        XCTAssertEqual(progressRing.value, 23.1)

        progressRing.startProgress(to: 17.9, duration: 0, completion: nil)
        XCTAssertEqual(progressRing.value, 17.9)

        progressRing.startProgress(to: 100, duration: 0.2) {
            XCTAssertEqual(self.progressRing.value, 100)
            XCTAssertEqual(self.progressRing.isAnimating, false)
            self.progressRing.startProgress(to: 25.32, duration: 0.3, completion: {
                XCTAssertEqual(self.progressRing.value, 25.32)
                XCTAssertEqual(self.progressRing.isAnimating, false)
            })
        }
        // Since animation takes 2 seconds and happens concurrently, isAnimating should be true here
        XCTAssertEqual(progressRing.isAnimating, true)
    }

    func testSettersAndLayer() {
        // Check that changing views members also change the approriate layers members
        XCTAssertNil(progressRing.delegate)

        progressRing.fullCircle = false
        XCTAssertEqual(progressRing.fullCircle, false)

        progressRing.value = 50
        XCTAssertEqual(progressRing.value, 50)
        XCTAssertEqual(progressRing.ringLayer.value, 50)

        XCTAssertEqual(progressRing.currentValue, 50)
        XCTAssertEqual(progressRing.ringLayer.value(forKey: "value") as! CGFloat, 50)

        progressRing.minValue = 10
        XCTAssertEqual(progressRing.minValue, 10)
        XCTAssertEqual(progressRing.ringLayer.minValue, 10)
        progressRing.minValue = 0
        XCTAssertEqual(progressRing.minValue, 0)
        XCTAssertEqual(progressRing.ringLayer.minValue, 0)

        progressRing.maxValue = 200
        XCTAssertEqual(progressRing.maxValue, 200)
        XCTAssertEqual(progressRing.ringLayer.maxValue, 200)

        var formatter = UICircularProgressRingFormatter()
        formatter.valueIndicator = " GB"
        formatter.showFloatingPoint = true
        formatter.decimalPlaces = 1
        progressRing.valueFormatter = formatter

        let layerFormatter = progressRing.ringLayer.valueFormatter as! UICircularProgressRingFormatter
        XCTAssertEqual(layerFormatter.valueIndicator, " GB")
        XCTAssertEqual(layerFormatter.showFloatingPoint, true)
        XCTAssertEqual(layerFormatter.decimalPlaces, 1)

        progressRing.animationTimingFunction = .linear
        XCTAssertEqual(progressRing.animationTimingFunction, .linear)
        XCTAssertEqual(progressRing.ringLayer.animationTimingFunction, .linear)
    }
}
