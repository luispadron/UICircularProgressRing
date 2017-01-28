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
    
    var progressRing: UICircularProgressRingView!
    
    override func setUp() {
        super.setUp()
        
        progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
    }
    
    override func tearDown() {
        super.tearDown()
        
        progressRing = nil
    }
    
    func testApiAndAnimations() {
        
        progressRing.setProgress(value: 20, animationDuration: 2) {
            XCTAssertEqual(self.progressRing.value, 20)
        }
        
        progressRing.setProgress(value: 23.1, animationDuration: 0)
        XCTAssertEqual(progressRing.value, 23.1)
        
        progressRing.setProgress(value: 17.9, animationDuration: 0, completion: nil)
        XCTAssertEqual(progressRing.value, 17.9)
        
        progressRing.setProgress(value: 100, animationDuration: 2) {
            XCTAssertEqual(self.progressRing.value, 100) // Value should be set
            XCTAssertEqual(self.progressRing.isAnimating, false) // No longer animating, this should be false
            self.progressRing.setProgress(value: 25.32, animationDuration: 3, completion: {
                XCTAssertEqual(self.progressRing.value, 25.32) // Value set
                XCTAssertEqual(self.progressRing.isAnimating, false) // No longer animating, this should be false
            })
        }
        
        // Since animation takes 2 seconds and happens concurrently, isAnimating should be true here
        XCTAssertEqual(progressRing.isAnimating, true)
    }
    
    func testDefaultsAndSetters() {
        // Check the defaults for the view, change them, then make sure they changed
        XCTAssertNil(progressRing.delegate)
        
        XCTAssertEqual(progressRing.value, 0)
        progressRing.value = 50
        XCTAssertEqual(progressRing.value, 50)
        
        XCTAssertEqual(progressRing.maxValue, 100)
        progressRing.maxValue = 200
        XCTAssertEqual(progressRing.maxValue, 200)
        
        XCTAssertEqual(progressRing.viewStyle, 1)
        progressRing.viewStyle = 2
        XCTAssertEqual(progressRing.viewStyle, 2)
        
        XCTAssertEqual(progressRing.patternForDashes, [7.0, 7.0])
        progressRing.patternForDashes = [6.0, 5.0]
        XCTAssertEqual(progressRing.patternForDashes, [6.0, 5.0])
        
        XCTAssertEqual(progressRing.startAngle, 0)
        progressRing.startAngle = 90
        XCTAssertEqual(progressRing.startAngle, 90)
        
        XCTAssertEqual(progressRing.endAngle, 360)
        progressRing.endAngle = 180
        XCTAssertEqual(progressRing.endAngle, 180)
        
        
        XCTAssertEqual(progressRing.outerRingWidth, 10)
        progressRing.outerRingWidth = 5
        XCTAssertEqual(progressRing.outerRingWidth, 5)
        
        XCTAssertEqual(progressRing.outerRingColor, UIColor.gray)
        progressRing.outerRingColor = UIColor.red
        XCTAssertEqual(progressRing.outerRingColor, UIColor.red)
        
        XCTAssertEqual(progressRing.outerRingCapStyle, 1)
        XCTAssertEqual(progressRing.outStyle, .butt)
        progressRing.outerRingCapStyle = 2
        XCTAssertEqual(progressRing.outerRingCapStyle, 2)
        XCTAssertEqual(progressRing.outStyle, .round)
        
        XCTAssertEqual(progressRing.innerRingWidth, 5.0)
        progressRing.innerRingWidth = 10.0
        XCTAssertEqual(progressRing.innerRingWidth, 10.0)
        
        XCTAssertEqual(progressRing.innerRingColor, UIColor.blue)
        progressRing.innerRingColor = UIColor.green
        XCTAssertEqual(progressRing.innerRingColor, UIColor.green)
        
        XCTAssertEqual(progressRing.innerRingSpacing, 1)
        progressRing.innerRingSpacing = 2
        XCTAssertEqual(progressRing.innerRingSpacing, 2)
        
        XCTAssertEqual(progressRing.innerRingCapStyle, 2)
        XCTAssertEqual(progressRing.inStyle, .round)
        progressRing.innerRingCapStyle = 3
        XCTAssertEqual(progressRing.innerRingCapStyle, 3)
        XCTAssertEqual(progressRing.inStyle, .square)
        
        XCTAssertEqual(progressRing.shouldShowValueText, true)
        progressRing.shouldShowValueText = false
        XCTAssertEqual(progressRing.shouldShowValueText, false)
        
        XCTAssertEqual(progressRing.fontColor, UIColor.black)
        progressRing.fontColor = UIColor.darkText
        XCTAssertEqual(progressRing.fontColor, UIColor.darkText)
        
        XCTAssertEqual(progressRing.fontSize, 18)
        progressRing.fontSize = 20
        XCTAssertEqual(progressRing.fontSize, 20)
        
        XCTAssertEqual(progressRing.animationStyle, kCAMediaTimingFunctionEaseIn)
        progressRing.animationStyle = kCAMediaTimingFunctionLinear
        XCTAssertEqual(progressRing.animationStyle, kCAMediaTimingFunctionLinear)
    }
}
