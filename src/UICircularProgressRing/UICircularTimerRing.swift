//
//  UICircularTimerRing.swift
//  UICircularProgressRing
//
//  Copyright (c) 2019 Luis Padron
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
//  OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

final public class UICircularTimerRing: UICircularRing {
    // MARK: Members

    /// This is the max value for the layer, which corresponds
    /// to the time that was set for the timer
    private var time: TimeInterval = 60 {
        didSet {
            ringLayer.maxValue = time.float
        }
    }

    /// type-alias for the handler that should be called when needed
    public typealias TimerHandler = () -> Void

    /// the completion for over all timer
    private var timerHandler: TimerHandler?

    // MARK: API

    public func startTimer(to time: TimeInterval, handler: TimerHandler?) {
        self.time = time
        self.timerHandler = handler
    }

    // MARK: Overrides

    /**
     Overrides the default layer with the custom UICircularTimerRingLayer class
     */
    override public class var layerClass: AnyClass {
        return UICircularTimerRingLayer.self
    }

    /**
     Set the ring layer to the default layer, cated as custom layer
     */
    override var ringLayer: UICircularTimerRingLayer {
        // swiftlint:disable:next force_cast
        return layer as! UICircularTimerRingLayer
    }

    override func initialize() {
        super.initialize()
        ringLayer.minValue = 0
        ringLayer.value = 0
        ringLayer.maxValue = time.float
        ringLayer.valueIndicator = ""
        ringLayer.showFloatingPoint = false
        ringLayer.decimalPlaces = 0
        ringLayer.shouldShowValueText = true
        ringLayer.animationTimingFunction = .linear
    }
}

// MARK: UICircularTimerRingLayer

final class UICircularTimerRingLayer: UICircularRingLayer {
    override func drawValueLabel() {
        super.drawValueLabel()
    }
}
