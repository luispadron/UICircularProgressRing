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
    @objc public weak var delegate: UICircularProgressRingDelegate?

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
                value = minValue
            }
            if value > maxValue {
                #if DEBUG
                print("Warning in: \(#file):\(#line)")
                print("Attempted to set a value greater than maxValue, value has been set to maxValue.\n")
                #endif
                value = maxValue
            }
            ringLayer.value = value
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
        if isAnimating {
            return layer.presentation()?.value(forKey: .value) as? CGFloat
        } else {
            return value
        }
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
        didSet {
            ringLayer.minValue = abs(minValue)
        }
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
        didSet {
            ringLayer.maxValue = abs(maxValue)
        }
    }

    /**
     The name of the value indicator the value label will
     appened to the value
     Example: " GB" -> "100 GB"

     ## Important ##
     Default = "%"

     ## Author
     Luis Padron
     */
    @IBInspectable public var valueIndicator: String = "%" {
        didSet {
            ringLayer.valueIndicator = valueIndicator
        }
    }

    /**
     A toggle for either placing the value indicator right or left to the value
     Example: true -> "GB 100" (instead of 100 GB)

     ## Important ##
     Default = false (place value indicator to the right)

     ## Author
     Elad Hayun
     */
    @IBInspectable public var rightToLeft: Bool = false {
        didSet {
            ringLayer.rightToLeft = rightToLeft
        }
    }

    /**
     A toggle for showing or hiding floating points from
     the value in the value label

     ## Important ##
     Default = false (dont show)

     To customize number of decmial places to show, assign a value to decimalPlaces.

     ## Author
     Luis Padron
     */
    @IBInspectable public var showFloatingPoint: Bool = false {
        didSet {
            ringLayer.showFloatingPoint = showFloatingPoint
        }
    }

    /**
     The amount of decimal places to show in the value label

     ## Important ##
     Default = 2

     Only used when showFloatingPoint = true

     ## Author
     Luis Padron
     */
    @IBInspectable public var decimalPlaces: Int = 2 {
        didSet {
            ringLayer.decimalPlaces = decimalPlaces
        }
    }

    /**
     The type of animation function the ring view will use

     ## Important ##
     Default = .easeInEaseOut

     ## Author
     Luis Padron
     */
    @objc public var animationTimingFunction: CAMediaTimingFunctionName = .easeInEaseOut {
        didSet {
            ringLayer.animationTimingFunction = animationTimingFunction
        }
    }

    /**
     A toggle for showing or hiding the value label.
     If false the current value will not be shown.

     ## Important ##
     Default = true

     ## Author
     Luis Padron
     */
    @IBInspectable public var shouldShowValueText: Bool = true {
        didSet {
            ringLayer.shouldShowValueText = shouldShowValueText
        }
    }

    /**
     Typealias for the startProgress(:) method closure
     */
    public typealias ProgressCompletion = (() -> Void)

    /// The completion block to call after the animation is done
    private var completion: ProgressCompletion?

    /// This variable stores how long remains on the timer when it's paused
    private var pausedTimeRemaining: TimeInterval = 0

    /// Used to determine when the animation was paused
    private var animationPauseTime: CFTimeInterval?

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

     Calling this method again while a current progress animation is in progress will **not**
     cause the animation to be restarted. The old animation will be removed (calling the completion and delegate)
     and a new animation will start from where the old one left off at. If you wish to instead reset an animation
     consider `resetProgress`.

     ## Author
     Luis Padron
     */
    @objc public func startProgress(to value: CGFloat, duration: TimeInterval, completion: ProgressCompletion? = nil) {
        if isAnimating {
            animationPauseTime = nil
            self.value = currentValue ?? value
            ringLayer.removeAnimation(forKey: .value)
        }

        ringLayer.timeOffset = 0.0
        ringLayer.beginTime = 0.0
        ringLayer.speed = 1.0
        ringLayer.animated = duration > 0
        ringLayer.animationDuration = duration

        // Store the completion event locally
        self.completion = completion

        // Check if a completion timer is still active and if so stop it
        completionTimer?.invalidate()
        completionTimer = nil

        //Create a new completion timer
        completionTimer = Timer.scheduledTimer(timeInterval: duration,
                                               target: self,
                                               selector: #selector(self.animationDidComplete),
                                               userInfo: completion,
                                               repeats: false)

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
    @objc public func pauseProgress() {
        guard isAnimating else {
            #if DEBUG
            print("""
                    UICircularRing: Progress was paused without having been started.
                    This has no effect but may indicate that you're unnecessarily calling this method.
                    """)
            #endif
            return
        }

        snapshotProgress()

        let pauseTime = ringLayer.convertTime(CACurrentMediaTime(), from: nil)
        animationPauseTime = pauseTime

        ringLayer.speed = 0.0
        ringLayer.timeOffset = pauseTime

        if let fireTime = completionTimer?.fireDate {
            pausedTimeRemaining = fireTime.timeIntervalSince(Date())
        } else {
            pausedTimeRemaining = 0
        }

        completionTimer?.invalidate()
        completionTimer = nil

        delegate?.didPauseProgress?(for: self)
    }

    /**
     Continues the animation with its remaining time from where it left off before it was paused.
     This method has no effect unless called when there is a paused animation.
     You should call this method when you wish to resume a paused animation.

     ## Author
     Luis Padron & Nicolai Cornelis
     */
    @objc public func continueProgress() {
        guard let pauseTime = animationPauseTime else {
            #if DEBUG
            print("""
                    UICircularRing: Progress was continued without having been paused.
                    This has no effect but may indicate that you're unnecessarily calling this method.
                    """)
            #endif
            return
        }

        restoreProgress()

        ringLayer.speed = 1.0
        ringLayer.timeOffset = 0.0
        ringLayer.beginTime = 0.0

        let timeSincePause = ringLayer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime

        ringLayer.beginTime = timeSincePause

        completionTimer = Timer.scheduledTimer(timeInterval: pausedTimeRemaining,
                                               target: self,
                                               selector: #selector(animationDidComplete),
                                               userInfo: completion,
                                               repeats: false)

        animationPauseTime = nil

        delegate?.didContinueProgress?(for: self)
    }

    /**
     Resets the progress back to the `minValue` of the progress ring.
     Does **not** perform any animations

     ## Author
     Luis Padron
     */
    @objc public func resetProgress() {
        ringLayer.animated = false
        ringLayer.removeAnimation(forKey: .value)
        snapshottedAnimation = nil
        value = minValue

        // Stop the timer and thus make the completion method not get fired
        completionTimer?.invalidate()
        completionTimer = nil
        animationPauseTime = nil

        // Remove reference to the completion block
        completion = nil
    }

    // MARK: Overrides

    override func initialize() {
        super.initialize()
        ringLayer.value = value
        ringLayer.maxValue = maxValue
        ringLayer.minValue = minValue
        ringLayer.valueIndicator = valueIndicator
        ringLayer.showFloatingPoint = showFloatingPoint
        ringLayer.decimalPlaces = decimalPlaces
        ringLayer.shouldShowValueText = shouldShowValueText
    }

    override func didUpdateValue(newValue: CGFloat) {
        super.didUpdateValue(newValue: newValue)
        delegate?.didUpdateProgressValue?(for: self, to: newValue)
    }

    override func willDisplayLabel(label: UILabel) {
        super.willDisplayLabel(label: label)
        delegate?.willDisplayLabel?(for: self, label)
    }
}

// MARK: Helpers

private extension UICircularProgressRing {
    /// Called when the animation timer is complete
    @objc func animationDidComplete(withTimer timer: Timer) {
        delegate?.didFinishProgress?(for: self)
        (timer.userInfo as? ProgressCompletion)?()
    }
}
