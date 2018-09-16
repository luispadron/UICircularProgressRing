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
        XCTAssertEqual(progressRing.ringLayer.fullCircle, false)

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

        progressRing.ringStyle = .ontop
        XCTAssertEqual(progressRing.ringStyle, .ontop)
        XCTAssertEqual(progressRing.ringLayer.ringStyle, .ontop)

        progressRing.ringStyle = .bordered
        XCTAssertEqual(progressRing.ringStyle, .bordered)
        XCTAssertEqual(progressRing.ringLayer.ringStyle, .bordered)

        progressRing.patternForDashes = [6.0, 5.0]
        XCTAssertEqual(progressRing.patternForDashes, [6.0, 5.0])
        XCTAssertEqual(progressRing.ringLayer.patternForDashes, [6.0, 5.0])

        progressRing.startAngle = 90
        XCTAssertEqual(progressRing.startAngle, 90)
        XCTAssertEqual(progressRing.ringLayer.startAngle, 90)

        progressRing.endAngle = 180
        XCTAssertEqual(progressRing.endAngle, 180)
        XCTAssertEqual(progressRing.ringLayer.endAngle, 180)

        progressRing.showsValueKnob = true
        XCTAssertTrue(progressRing.showsValueKnob)
        XCTAssertTrue(progressRing.ringLayer.showsValueKnob)

        progressRing.valueKnobColor = .black
        XCTAssertEqual(progressRing.valueKnobColor, .black)
        XCTAssertEqual(progressRing.ringLayer.valueKnobColor, .black)

        progressRing.valueKnobSize = 30
        XCTAssertEqual(progressRing.valueKnobSize, 30)
        XCTAssertEqual(progressRing.ringLayer.valueKnobSize, 30)

        progressRing.valueKnobShadowColor = .black
        XCTAssertEqual(progressRing.valueKnobShadowColor, .black)
        XCTAssertEqual(progressRing.ringLayer.valueKnobShadowColor, .black)

        progressRing.valueKnobShadowBlur = 30
        XCTAssertEqual(progressRing.valueKnobShadowBlur, 30)
        XCTAssertEqual(progressRing.ringLayer.valueKnobShadowBlur, 30)

        progressRing.valueKnobShadowOffset = CGSize(width: 10, height: 10)
        XCTAssertEqual(progressRing.valueKnobShadowOffset, CGSize(width: 10, height: 10))
        XCTAssertEqual(progressRing.ringLayer.valueKnobShadowOffset, CGSize(width: 10, height: 10))

        progressRing.gradientColors = [UIColor.blue, UIColor.red]
        XCTAssertEqual(progressRing.gradientColors, [UIColor.blue, UIColor.red])
        XCTAssertEqual(progressRing.ringLayer.gradientColors, [UIColor.blue, UIColor.red])

        progressRing.gradientColorLocations = [0.0, 1.0]
        XCTAssertEqual(progressRing.gradientColorLocations!, [0.0, 1.0])
        XCTAssertEqual(progressRing.ringLayer.gradientColorLocations!, [0.0, 1.0])

        progressRing.gradientStartPosition = .topLeft
        XCTAssertEqual(progressRing.gradientStartPosition, .topLeft)
        XCTAssertEqual(progressRing.ringLayer.gradientStartPosition, .topLeft)

        progressRing.gradientEndPosition = .bottomRight
        XCTAssertEqual(progressRing.gradientEndPosition, .bottomRight)
        XCTAssertEqual(progressRing.ringLayer.gradientEndPosition, .bottomRight)

        progressRing.outerRingWidth = 5
        XCTAssertEqual(progressRing.outerRingWidth, 5)
        XCTAssertEqual(progressRing.ringLayer.outerRingWidth, 5)

        progressRing.outerRingColor = UIColor.red
        XCTAssertEqual(progressRing.outerRingColor, UIColor.red)
        XCTAssertEqual(progressRing.ringLayer.outerRingColor, UIColor.red)

        progressRing.outerBorderWidth = 5
        XCTAssertEqual(progressRing.outerBorderWidth, 5)
        XCTAssertEqual(progressRing.ringLayer.outerBorderWidth, 5)

        progressRing.outerBorderColor = UIColor.red
        XCTAssertEqual(progressRing.outerBorderColor, UIColor.red)
        XCTAssertEqual(progressRing.ringLayer.outerBorderColor, UIColor.red)

        progressRing.outerCapStyle = .round
        XCTAssertEqual(progressRing.outerCapStyle, .round)
        XCTAssertEqual(progressRing.ringLayer.outerCapStyle, .round)

        progressRing.innerRingWidth = 10.0
        XCTAssertEqual(progressRing.innerRingWidth, 10.0)
        XCTAssertEqual(progressRing.ringLayer.innerRingWidth, 10.0)

        progressRing.innerRingColor = UIColor.green
        XCTAssertEqual(progressRing.innerRingColor, UIColor.green)
        XCTAssertEqual(progressRing.ringLayer.innerRingColor, UIColor.green)

        progressRing.innerRingSpacing = 2
        XCTAssertEqual(progressRing.innerRingSpacing, 2)
        XCTAssertEqual(progressRing.innerRingSpacing, 2)

        progressRing.innerCapStyle = .square
        XCTAssertEqual(progressRing.innerCapStyle, .square)
        XCTAssertEqual(progressRing.ringLayer.innerCapStyle, .square)

        progressRing.shouldShowValueText = false
        XCTAssertEqual(progressRing.shouldShowValueText, false)
        XCTAssertEqual(progressRing.ringLayer.shouldShowValueText, false)

        progressRing.fontColor = UIColor.darkText
        XCTAssertEqual(progressRing.fontColor, UIColor.darkText)
        XCTAssertEqual(progressRing.ringLayer.fontColor, UIColor.darkText)

        progressRing.font = UIFont.italicSystemFont(ofSize: 12.0)
        XCTAssertEqual(progressRing.font, UIFont.italicSystemFont(ofSize: 12.0))
        XCTAssertEqual(progressRing.ringLayer.font, UIFont.italicSystemFont(ofSize: 12.0))

        progressRing.valueIndicator = " GB"
        XCTAssertEqual(progressRing.valueIndicator, " GB")
        XCTAssertEqual(progressRing.ringLayer.valueIndicator, " GB")

        progressRing.showFloatingPoint = true
        XCTAssertEqual(progressRing.showFloatingPoint, true)
        XCTAssertEqual(progressRing.ringLayer.showFloatingPoint, true)

        progressRing.decimalPlaces = 1
        XCTAssertEqual(progressRing.decimalPlaces, 1)
        XCTAssertEqual(progressRing.ringLayer.decimalPlaces, 1)

        progressRing.animationTimingFunction = .linear
        XCTAssertEqual(progressRing.animationTimingFunction, .linear)
        XCTAssertEqual(progressRing.ringLayer.animationTimingFunction, .linear)
    }
}
