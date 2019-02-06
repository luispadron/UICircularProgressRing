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

    /**
     The handler for the timer.

     The handler is called whenever the timer finishes or is paused.
     If the timer is paused handler will be called with (false, elapsedTime)
     Otherwise the handler will be called with (true, finalTime)
     */
    public typealias TimerHandler = (Bool, TimeInterval?) -> Void

    // MARK: Private Members

    /// This is the max value for the layer, which corresponds
    /// to the time that was set for the timer
    private var time: TimeInterval = 60 {
        didSet {
            ringLayer.value = time.float
            ringLayer.maxValue = time.float
        }
    }

    /// the elapsed time since calling `startTimer`
    private var elapsedTime: TimeInterval? {
        return layer.presentation()?.value(forKey: .value) as? TimeInterval
    }

    /// the completion for over all timer
    private var timerHandler: TimerHandler?

    // MARK: API

    /**
     Starts the timer until the given time is elapsed.
     */
    public func startTimer(to time: TimeInterval, handler: TimerHandler?) {
        startAnimation(duration: time) {
            self.timerHandler?(true, self.time)
        }

        self.time = time
        self.timerHandler = handler
    }

    /**
     Pauses the timer.

     Handler will be called with (false, elapsedTime)
     */
    public func pauseTimer() {
        timerHandler?(false, self.elapsedTime)
        pauseAnimation()
    }

    /**
     Continues the timer from a previously paused time.
     */
    public func continueTimer() {
        continueAnimation {
            self.timerHandler?(true, self.time)
        }
    }

    /**
     Resets the timer, this means the time is reset and
     previously set handler will no longer be used.
     */
    public func resetTimer() {
        resetAnimation()
        ringLayer.value = 0
        timerHandler = nil
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

    /// initialize with some defaults relevant to this timer ring
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
    /// formatter which formats the time string of the ring label
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .short
        return formatter
    }()

    /// custom handling of value label update as want to format as time string
    override func updateValueLabel(withValue value: CGFloat,
                                   valueIndicator: String,
                                   rightToLeft: Bool,
                                   showsDecimal: Bool,
                                   decimalPlaces: Int,
                                   valueDelegate: UICircularRing?) {
        valueLabel.text = formatter.string(from: value.interval)
        valueLabel.sizeToFit()
        valueDelegate?.willDisplayLabel(label: valueLabel)
    }
}
