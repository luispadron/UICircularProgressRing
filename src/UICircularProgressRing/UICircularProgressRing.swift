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
