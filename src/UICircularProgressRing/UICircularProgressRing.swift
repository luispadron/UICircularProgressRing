//
//  UICircularProgressRing.swift
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

final public class UICircularProgressRing: UICircularRing {
    // MARK: Members

    /**
     The delegate for the UICircularRing

     ## Important ##
     When progress is done updating via UICircularRing.setValue(_:), the
     finishedUpdatingProgressFor(_ ring: UICircularRing) will be called.

     The ring will be passed to the delegate in order to keep track of
     multiple ring updates if needed.

     ## Author
     Luis Padron
     */
    public weak var delegate: UICircularProgressRingDelegate?

    /**
     The value property for the progress ring.

     ## Important ##
     Default = 0

     Must be a non-negative value. If this value falls below `minValue` it will be
     clamped and set equal to `minValue`.

     This cannot be used to get the value while the ring is animating, to get
     current value while animating use `currentValue`.

     The current value of the progress ring after animating, use startProgress(value:)
     to alter the value with the option to animate and have a completion handler.

     ## Author
     Luis Padron
     */
    @IBInspectable public var value: CGFloat = 0 {
        didSet {
            if value < minValue {
                #if DEBUG
                print("Warning in: \(#file):\(#line)")
                print("Attempted to set a value less than minValue, value has been set to minValue.\n")
                #endif
                ringLayer.value = minValue
            } else if value > maxValue {
                #if DEBUG
                print("Warning in: \(#file):\(#line)")
                print("Attempted to set a value greater than maxValue, value has been set to maxValue.\n")
                #endif
                ringLayer.value = maxValue
            } else {
                ringLayer.value = value
            }
        }
    }

    /**
     The current value of the progress ring

     This will return the current value of the progress ring,
     if the ring is animating it will be updated in real time.
     If the ring is not currently animating then the value returned
     will be the `value` property of the ring

     ## Author
     Luis Padron
     */
    public var currentValue: CGFloat? {
        return isAnimating ? layer.presentation()?.value(forKey: .value) as? CGFloat : value
    }

    /**
     The minimum value for the progress ring. ex: (0) -> 100.

     ## Important ##
     Default = 100

     Must be a non-negative value, the absolute value is taken when setting this property.

     The `value` of the progress ring must NOT fall below `minValue` if it does the `value` property is clamped
     and will be set equal to `value`, you will receive a warning message in the console.

     Making this value greater than

     ## Author
     Luis Padron
     */
    @IBInspectable public var minValue: CGFloat = 0.0 {
        didSet { ringLayer.minValue = minValue }
    }

    /**
     The maximum value for the progress ring. ex: 0 -> (100)

     ## Important ##
     Default = 100

     Must be a non-negative value, the absolute value is taken when setting this property.

     Unlike the `minValue` member `value` can extend beyond `maxValue`. What happens in this case
     is the inner ring will do an extra loop through the outer ring, this is not noticible however.


     ## Author
     Luis Padron
     */
    @IBInspectable public var maxValue: CGFloat = 100.0 {
        didSet { ringLayer.maxValue = maxValue }
    }

    /**
     The type of animation function the ring view will use

     ## Important ##
     Default = .easeInEaseOut

     ## Author
     Luis Padron
     */
    public var animationTimingFunction: CAMediaTimingFunctionName = .easeInEaseOut {
        didSet { ringLayer.animationTimingFunction = animationTimingFunction }
    }

    /**
     The formatter responsible for formatting the
     value of the progress ring into a readable text string
     which is then displayed in the label of the ring.

     Default formatter is of type `UICircularProgressRingFormatter`.

     ## Author
     Luis Padron
     */
    public var valueFormatter: UICircularRingValueFormatter = UICircularProgressRingFormatter() {
        didSet { ringLayer.valueFormatter = valueFormatter }
    }

    /**
     Typealias for the startProgress(:) method closure
     */
    public typealias ProgressCompletion = (() -> Void)

    /// The completion block to call after the animation is done
    private var completion: ProgressCompletion?

    // MARK: API

    /**
     Sets the current value for the progress ring, calling this method while ring is
     animating will cancel the previously set animation and start a new one.

     - Parameter to: The value to be set for the progress ring
     - Parameter duration: The time interval duration for the animation
     - Parameter completion: The completion closure block that will be called when
     animtion is finished (also called when animationDuration = 0), default is nil

     ## Important ##
     Animation duration = 0 will cause no animation to occur, and value will instantly
     be set.

     ## Author
     Luis Padron
     */
    public func startProgress(to value: CGFloat, duration: TimeInterval, completion: ProgressCompletion? = nil) {
        // Store the completion event locally
        self.completion = completion

        // call super class helper function to begin animating layer
        startAnimation(duration: duration) {
            self.delegate?.didFinishProgress(for: self)
            self.completion?()
        }

        self.value = value
    }

    /**
     Pauses the currently running animation and halts all progress.

     ## Important ##
     This method has no effect unless called when there is a running animation.
     You should call this method manually whenever the progress ring is not in an active view,
     for example in `viewWillDisappear` in a parent view controller.

     ## Author
     Luis Padron & Nicolai Cornelis
     */
    public func pauseProgress() {
        // call super class helper to stop layer animation
        pauseAnimation()
        delegate?.didPauseProgress(for: self)
    }

    /**
     Continues the animation with its remaining time from where it left off before it was paused.
     This method has no effect unless called when there is a paused animation.
     You should call this method when you wish to resume a paused animation.

     ## Author
     Luis Padron & Nicolai Cornelis
     */
    public func continueProgress() {
        // call super class helper to continue layer animation
        continueAnimation {
            self.delegate?.didFinishProgress(for: self)
            self.completion?()
        }

        delegate?.didContinueProgress(for: self)
    }

    /**
     Resets the progress back to the `minValue` of the progress ring.
     Does **not** perform any animations

     ## Author
     Luis Padron
     */
    public func resetProgress() {
        // call super class helper to reset animation layer
        resetAnimation()
        value = minValue
        // Remove reference to the completion block
        completion = nil
    }

    // MARK: Overrides

    override func initialize() {
        super.initialize()
        ringLayer.ring = self
        ringLayer.value = value
        ringLayer.maxValue = maxValue
        ringLayer.minValue = minValue
        ringLayer.valueFormatter = valueFormatter
    }

    override func didUpdateValue(newValue: CGFloat) {
        super.didUpdateValue(newValue: newValue)
        delegate?.didUpdateProgressValue(for: self, to: newValue)
    }

    override func willDisplayLabel(label: UILabel) {
        super.willDisplayLabel(label: label)
        delegate?.willDisplayLabel(for: self, label)
    }
}
