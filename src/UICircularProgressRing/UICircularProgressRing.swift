//
//  UICircularProgressRing.swift
//  UICircularProgressRing
//
//  Copyright (c) 2016 Luis Padron
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

/// Helper enum for animation key
private enum AnimationKeys: String {
    case value
}

/// Helper extension to allow removing layer animation based on AnimationKeys enum
fileprivate extension CALayer {
    func removeAnimation(forKey key: AnimationKeys) {
        removeAnimation(forKey: key.rawValue)
    }

    func animation(forKey key: AnimationKeys) -> CAAnimation? {
        return animation(forKey: key.rawValue)
    }

    func value(forKey key: AnimationKeys) -> Any? {
        return value(forKey: key.rawValue)
    }
}

/**
 
 # UICircularProgressRing
 
 This is the UIView subclass that creates and handles everything
 to do with the progress ring
 
 This class has a custom CAShapeLayer (UICircularProgressRingLayer) which
 handels the drawing and animating of the view
 
 The properties in this class correspond with the
 properties in UICircularProgressRingLayer.
 When they are set in here, they are also set for the layer and drawn accordingly
 
 Read the docs for what each property does and what can be customized.
 
 ## Author
 Luis Padron
 
 */
@IBDesignable open class UICircularProgressRing: UIView {

    // MARK: Delegate
    /**
     The delegate for the UICircularProgressRing
     
     ## Important ##
     When progress is done updating via UICircularProgressRing.setValue(_:), the
     finishedUpdatingProgressFor(_ ring: UICircularProgressRing) will be called.
     
     The ring will be passed to the delegate in order to keep track of
     multiple ring updates if needed.
     
     ## Author
     Luis Padron
     */
    @objc open weak var delegate: UICircularProgressRingDelegate?

    // MARK: Circle Properties

    /**
     Whether or not the progress ring should be a full circle.
     
     What this means is that the outer ring will always go from 0 - 360 degrees and
     the inner ring will be calculated accordingly depending on current value.
     
     ## Important ##
     Default = true
     
     When this property is true any value set for `endAngle` will be ignored.
     
     ## Author
     Luis Padron
     
     */
    @IBInspectable open var fullCircle: Bool = true {
        didSet {
            ringLayer.fullCircle = fullCircle
        }
    }

    // MARK: Value Properties

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
    @IBInspectable open var value: ProgressValue = 0 {
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
    open var currentValue: ProgressValue? {
        if isAnimating {
            return layer.presentation()?.value(forKey: .value) as? ProgressValue
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
    @IBInspectable open var minValue: ProgressValue = 0.0 {
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
    @IBInspectable open var maxValue: ProgressValue = 100.0 {
        didSet {
            ringLayer.maxValue = abs(maxValue)
        }
    }

    // MARK: View Style

    /**
     Variable for the style of the progress ring.
     
     Range: [1,5]
     
     The four styles are
     
     - 1: Radius of the inner ring is smaller (inner ring inside outer ring)
     - 2: Radius of inner ring is equal to outer ring (both at same location)
     - 3: Radius of inner ring is equal to outer ring, and the outer ring is dashed
     - 4: Radius of inner ring is equal to outer ring, and the outer ring is dotted
     - 5: Radius of inner ring is equal to outer ring, and inner ring has gradient
     
     ## Important ##
     THIS IS ONLY TO BE USED WITH INTERFACE BUILDER
     
     The reason for this is IB has no support for enumerations as of yet
     
     
     ## Author
     Luis Padron
     */
    @available(*, unavailable,
    message: "This property is reserved for Interface Builder, use 'ringStyle' instead")
    @IBInspectable open var ibRingStyle: Int = 1 {
        willSet {
            let style = UICircularProgressRingStyle(rawValue: newValue)
            ringStyle = style ?? .inside
        }
    }

    /**
     The style of the progress ring.
     
     Type: `UICircularProgressRingStyle`
     
     The five styles include `inside`, `ontop`, `dashed`, `dotted`, and `gradient`
     
     ## Important ##
     Default = UICircularProgressRingStyle.inside
     
     ## Author
     Luis Padron
     */
    @objc open var ringStyle: UICircularProgressRingStyle = .inside {
        didSet {
            ringLayer.ringStyle = ringStyle
            if ringStyle != .bordered {
                outerBorderWidth = 0
            }
        }
    }

    /**
     Whether or not the value knob is shown
     
     ## Important ##
     Default = false
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var showsValueKnob: Bool = false {
        didSet {
            ringLayer.showsValueKnob = showsValueKnob
        }
    }

    /**
     The size of the value knob (diameter)
     
     ## Important ##
     Default = 15
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var valueKnobSize: CGFloat = 15.0 {
        didSet {
            ringLayer.valueKnobSize = valueKnobSize
        }
    }

    /**
     The color of the value knob
     
     ## Important ##
     Default = UIColor.lightGray
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var valueKnobColor: UIColor = .lightGray {
        didSet {
            ringLayer.valueKnobColor = valueKnobColor
        }
    }

    /**
     The blur (size) of the value knob's shadow
     
     ## Important ##
     Default = 2
     
     ## Author
     Makan Houston
     */
    @IBInspectable open var valueKnobShadowBlur: CGFloat = 2.0 {
        didSet {
            ringLayer.valueKnobShadowBlur = valueKnobShadowBlur
        }
    }

    /**
     The offset of the value knob's shadow
     
     ## Important ##
     Default = CGSize.zero
     
     ## Author
     Makan Houston
     */
    @IBInspectable open var valueKnobShadowOffset: CGSize = .zero {
        didSet {
            ringLayer.valueKnobShadowOffset = valueKnobShadowOffset
        }
    }

    /**
     The color of the value knob's shadow
     
     ## Important ##
     Default = UIColor.lightGray
     
     ## Author
     Makan Houston
     */
    @IBInspectable open var valueKnobShadowColor: UIColor = UIColor.black.withAlphaComponent(0.8) {
        didSet {
            ringLayer.valueKnobShadowColor = valueKnobShadowColor
        }
    }

    /**
     An array of CGFloats, used to calculate the dash length for viewStyle = 3
     
     ## Important ##
     Default = [7.0, 7.0]
     
     ## Author
     Luis Padron
     */
    @objc open var patternForDashes: [CGFloat] = [7.0, 7.0] {
        didSet {
            ringLayer.patternForDashes = patternForDashes
        }
    }

    /**
     The start angle for the entire progress ring view.
     
     Please note that Cocoa Touch uses a clockwise rotating unit circle.
     I.e: 90 degrees is at the bottom and 270 degrees is at the top
     
     ## Important ##
     Default = 0 (degrees)
     
     Values should be in degrees (they're converted to radians internally)
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var startAngle: CGFloat = 0 {
        didSet {
            ringLayer.startAngle = startAngle
        }
    }

    /**
     The end angle for the entire progress ring
     
     Please note that Cocoa Touch uses a clockwise rotating unit circle.
     I.e: 90 degrees is at the bottom and 270 degrees is at the top
     
     ## Important ##
     Default = 360 (degrees)
     
     Values should be in degrees (they're converted to radians internally)
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var endAngle: CGFloat = 360 {
        didSet {
            ringLayer.endAngle = endAngle
        }
    }

    /**
     The colors which will be used to create the gradient.
     
     Only used when `ringStyle` is `.gradient`
     
     The colors should be in the order they will be drawn in.
     
     ## Important ##
     By default this property will be an empty array.
     
     If this array is empty, no gradient will be drawn.
     
     ## Author
     Luis Padron
     */
    @objc open var gradientColors: [UIColor] = [UIColor]() {
        didSet {
            ringLayer.gradientColors = gradientColors
        }
    }

    /**
     The location for each color provided in `gradientColors`; each location must be
     a CGFloat value in the range of 0 to 1, inclusive. If 0 and 1 are not in the
     locations array, Quartz uses the colors provided that are closest to 0 and 1 for
     those locations.
     
     If locations is nil, the first color in `gradientColors` is assigned to location 0,
     the last color in `gradientColors` is assigned to location 1, and intervening
     colors are assigned locations that are at equal intervals in between.
     
     The locations array should contain the same number of items as the `gradientColors`
     array.
     
     ## Important ##
     By default this property will be nil
     
     ## Author
     Luis Padron
     */
    @objc open var gradientColorLocations: [CGFloat]? = nil {
        didSet {
            ringLayer.gradientColorLocations = gradientColorLocations
        }
    }

    /**
     The start location for the gradient.
     This property determines where the gradient will begin to draw,
     for all possible values see `UICircularProgressRingGradientPosition`.
     
     ## Important ##
     By default this property is `.topRight`
     
     ## Author
     Luis Padron
     */
    @objc open var gradientStartPosition: UICircularProgressRingGradientPosition = .topRight {
        didSet {
            ringLayer.gradientStartPosition = gradientStartPosition
        }
    }

    /**
     The end location for the gradient.
     This property determines where the gradient will end drawing,
     for all possible values see `UICircularProgressRingGradientPosition`.
     
     ## Important ##
     By default this property is `.bottomLeft`
     
     ## Author
     Luis Padron
     */
    @objc open var gradientEndPosition: UICircularProgressRingGradientPosition = .bottomLeft {
        didSet {
            ringLayer.gradientEndPosition = gradientEndPosition
        }
    }

    // MARK: Outer Ring properties

    /**
     The width of the outer ring for the progres bar
     
     ## Important ##
     Default = 10.0
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var outerRingWidth: CGFloat = 10.0 {
        didSet {
            ringLayer.outerRingWidth = outerRingWidth
        }
    }

    /**
     The color for the outer ring
     
     ## Important ##
     Default = UIColor.gray
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var outerRingColor: UIColor = UIColor.gray {
        didSet {
            ringLayer.outerRingColor = outerRingColor
        }
    }

    /**
     The color for the outer ring border
     
     ## Important ##
     Default = UIColor.gray
     
     ## Author
     Abdulla Allaith
     */
    @IBInspectable open var outerBorderColor: UIColor = UIColor.gray {
        didSet {
            ringLayer.outerBorderColor = outerBorderColor
        }
    }

    /**
     The width for the outer ring border
     
     ## Important ##
     Default = 2
     
     ## Author
     Abdulla Allaith
     */
    @IBInspectable open var outerBorderWidth: CGFloat = 2 {
        didSet {
            ringLayer.outerBorderWidth = outerBorderWidth
        }
    }

    /**
     The style for the outer ring end cap (how it is drawn on screen)
     Range [1,3]
     - 1: Line with a squared off end
     - 2: Line with a rounded off end
     - 3: Line with a square end
     - <1 & >3: Defaults to style 1
     
     ## Important ##
     THIS IS ONLY TO BE USED WITH INTERFACE BUILDER
     
     Default = 1
     
     ## Author
     Luis Padron
     */
    @available(*, unavailable,
    message: "This property is reserved for Interface Builder, use 'outerCapStyle' instead")
    @IBInspectable open var outerRingCapStyle: Int32 = 1 {
        willSet {
            switch newValue {
            case 1:
                outerCapStyle = .butt
            case 2:
                outerCapStyle = .round
            case 3:
                outerCapStyle = .square
            default:
                outerCapStyle = .butt
            }
        }
    }

    /**
     The style for the tip/cap of the outer ring
     
     Type: `CGLineCap`
     
     ## Important ##
     Default = CGLineCap.butt
     
     This is only noticible when ring is not a full circle.
     
     ## Author
     Luis Padron
     */
    @objc open var outerCapStyle: CGLineCap = .butt {
        didSet {
            ringLayer.outerCapStyle = outerCapStyle
        }
    }

    // MARK: Inner Ring properties

    /**
     The width of the inner ring for the progres bar
     
     ## Important ##
     Default = 5.0
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var innerRingWidth: CGFloat = 5.0 {
        didSet {
            ringLayer.innerRingWidth = innerRingWidth
        }
    }

    /**
     The color of the inner ring for the progres bar
     
     ## Important ##
     Default = UIColor.blue
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var innerRingColor: UIColor = UIColor.blue {
        didSet {
            ringLayer.innerRingColor = innerRingColor
        }
    }

    /**
     The spacing between the outer ring and inner ring
     
     ## Important ##
     This only applies when using progressRingStyle = 1
     
     Default = 1
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var innerRingSpacing: CGFloat = 1 {
        didSet {
            ringLayer.innerRingSpacing = innerRingSpacing
        }
    }

    /**
     The style for the inner ring end cap (how it is drawn on screen)
     
     Range [1,3]
     
     - 1: Line with a squared off end
     - 2: Line with a rounded off end
     - 3: Line with a square end
     - <1 & >3: Defaults to style 2
     
     ## Important ##
     THIS IS ONLY TO BE USED WITH INTERFACE BUILDER
     
     Default = 2
     
     ## Author
     Luis Padron
     */
    @available(*, unavailable,
    message: "This property is reserved for Interface Builder, use 'innerCapStyle' instead")
    @IBInspectable open var innerRingCapStyle: Int32 = 2 {
        willSet {
            switch newValue {
            case 1:
                innerCapStyle = .butt
            case 2:
                innerCapStyle = .round
            case 3:
                innerCapStyle = .square
            default:
                innerCapStyle = .round
            }
        }
    }

    /**
     The style for the tip/cap of the inner ring
     
     Type: `CGLineCap`
     
     ## Important ##
     Default = CGLineCap.round
     
     ## Author
     Luis Padron
     */
    @objc open var innerCapStyle: CGLineCap = .round {
        didSet {
            ringLayer.innerCapStyle = innerCapStyle
        }
    }

    // MARK: Label

    /**
     A toggle for showing or hiding the value label.
     If false the current value will not be shown.
     
     ## Important ##
     Default = true
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var shouldShowValueText: Bool = true {
        didSet {
            ringLayer.shouldShowValueText = shouldShowValueText
        }
    }

    /**
     The text color for the value label field
     
     ## Important ##
     Default = UIColor.black
     
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var fontColor: UIColor = UIColor.black {
        didSet {
            ringLayer.fontColor = fontColor
        }
    }

    /**
     The font to be used for the progress indicator.
     All font attributes are specified here except for font color, which is done
     using `fontColor`.
     
     
     ## Important ##
     Default = UIFont.systemFont(ofSize: 18)
     
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var font: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            ringLayer.font = font
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
    @IBInspectable open var valueIndicator: String = "%" {
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
    @IBInspectable open var rightToLeft: Bool = false {
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
    @IBInspectable open var showFloatingPoint: Bool = false {
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
    @IBInspectable open var decimalPlaces: Int = 2 {
        didSet {
            ringLayer.decimalPlaces = decimalPlaces
        }
    }

    // MARK: Animation properties

    /**
     The type of animation function the ring view will use
     
     ## Important ##
     Default = .easeInEaseOut
     
     ## Author
     Luis Padron
     */
    @objc open var animationTimingFunction: CAMediaTimingFunctionName = .easeInEaseOut {
        didSet {
            ringLayer.animationTimingFunction = animationTimingFunction
        }
    }

    /**
     This returns whether or not the ring is currently animating
     
     ## Important ##
     Get only property
     
     ## Author
     Luis Padron
     */
    @objc open var isAnimating: Bool {
        return completionTimer?.isValid ?? false
    }

    /**
     The direction the circle is drawn in
     Example: true -> clockwise
     
     ## Important ##
     Default = true (draw the circle clockwise)
     
     ## Author
     Pete Walker
     */
    @IBInspectable open var isClockwise: Bool = true {
        didSet {
            ringLayer.isClockwise = isClockwise
        }
    }

    /// This stores the animation when the timer is paused. We use this variable to continue the animation where it left off.
    /// See https://stackoverflow.com/questions/7568567/restoring-animation-where-it-left-off-when-app-resumes-from-background
    private var snapshottedAnimation: CAAnimation?

    /// This variable stores how long remains on the timer when it's paused
    private var pausedTimeRemaining: TimeInterval = 0

    /// Used to determine when the animation was paused
    private var animationPauseTime: CFTimeInterval?

    /// The completion timer, also indicates wether or not the view is animating
    private var completionTimer: Timer?

    /// The completion block to call after the animation is done
    private var completion: ProgressCompletion?

    // MARK: Layer

    /**
     Set the ring layer to the default layer, cated as custom layer
     */
    internal var ringLayer: UICircularProgressRingLayer {
        // swiftlint:disable:next force_cast
        return layer as! UICircularProgressRingLayer
    }

    /**
     Overrides the default layer with the custom UICircularProgressRingLayer class
     */
    override open class var layerClass: AnyClass {
        return UICircularProgressRingLayer.self
    }

    // MARK: Type aliases

    /**
     Typealias for the startProgress(:) method closure
     */
    public typealias ProgressCompletion = (() -> Void)

    /**
     Typealias for animateProperties(duration:animations:completion:) fucntion completion
     */
    public typealias PropertyAnimationCompletion = (() -> Void)

    /**
     Typealias for the value of the ring
     */
    public typealias ProgressValue = CGFloat

    /**
     Typealias for the duration of a ring animation
     */
    public typealias ProgressDuration = TimeInterval

    // MARK: Methods

    /**
     Overriden public init to initialize the layer and view
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        // Call the internal initializer
        initialize()
    }

    /**
     Overriden public init to initialize the layer and view
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Call the internal initializer
        initialize()
    }

    /**
     This method initializes the custom CALayer to the default values
     */
    // swiftlint:disable:next function_body_length
    private func initialize() {
        // This view will become the value delegate of the layer, which will call the updateValue method when needed
        ringLayer.valueDelegate = self

        // Helps with pixelation and blurriness on retina devices
        layer.contentsScale = UIScreen.main.scale
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale * 2
        layer.masksToBounds = false

        ringLayer.fullCircle = fullCircle
        ringLayer.isClockwise = isClockwise

        ringLayer.value = value
        ringLayer.maxValue = maxValue
        ringLayer.minValue = minValue

        ringLayer.ringStyle = ringStyle
        ringLayer.showsValueKnob = showsValueKnob
        ringLayer.valueKnobSize = valueKnobSize
        ringLayer.valueKnobColor = valueKnobColor
        ringLayer.valueKnobShadowBlur = valueKnobShadowBlur
        ringLayer.valueKnobShadowOffset = valueKnobShadowOffset
        ringLayer.valueKnobShadowColor = valueKnobShadowColor
        ringLayer.patternForDashes = patternForDashes
        ringLayer.gradientColors = gradientColors
        ringLayer.gradientColorLocations = gradientColorLocations
        ringLayer.gradientStartPosition = gradientStartPosition
        ringLayer.gradientEndPosition = gradientEndPosition

        ringLayer.startAngle = startAngle
        ringLayer.endAngle = endAngle

        ringLayer.outerRingWidth = outerRingWidth
        ringLayer.outerRingColor = outerRingColor
        ringLayer.outerBorderWidth = outerBorderWidth
        ringLayer.outerBorderColor = outerBorderColor
        ringLayer.outerCapStyle = outerCapStyle

        ringLayer.innerRingWidth = innerRingWidth
        ringLayer.innerRingColor = innerRingColor
        ringLayer.innerCapStyle = innerCapStyle
        ringLayer.innerRingSpacing = innerRingSpacing

        ringLayer.shouldShowValueText = shouldShowValueText
        ringLayer.valueIndicator = valueIndicator
        ringLayer.fontColor = fontColor
        ringLayer.font = font
        ringLayer.showFloatingPoint = showFloatingPoint
        ringLayer.decimalPlaces = decimalPlaces

        backgroundColor = UIColor.clear
        ringLayer.backgroundColor = UIColor.clear.cgColor

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(restoreProgress),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(snapshotProgress),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }

    /**
     Overriden because of custom layer drawing in UICircularProgressRingLayer
     */
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    /**
     Called whenever the layer updates its `value` keypath, this method will then simply call its delegate with
     the `newValue` so that it notifies any delegates who may need to know about value updates in real time
     */
    internal func didUpdateValue(newValue: ProgressValue) {
        delegate?.didUpdateProgressValue?(for: self, to: newValue)
    }

    internal func willDisplayLabel(label: UILabel) {
        delegate?.willDisplayLabel?(for: self, label)
    }

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
    @objc open func startProgress(to value: ProgressValue, duration: ProgressDuration, completion: ProgressCompletion? = nil) {
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
    @objc open func pauseProgress() {
        guard isAnimating else {
            #if DEBUG
            print("""
                    UICircularProgressRing: Progress was paused without having been started.
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
    @objc open func continueProgress() {
        guard let pauseTime = animationPauseTime else {
            #if DEBUG
            print("""
                    UICircularProgressRing: Progress was continued without having been paused.
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
    @objc open func resetProgress() {
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

    /**
     This function allows animation of the animatable properties of the `UICircularProgressRing`.
     These properties include `innerRingColor, innerRingWidth, outerRingColor, outerRingWidth, innerRingSpacing, fontColor`.
     
     Simply call this function and inside of the animation block change the animatable properties as you would in any `UView`
     animation block.
     
     The completion block is called when all animations finish.
     */
    @objc open func animateProperties(duration: TimeInterval, animations: () -> Void) {
        animateProperties(duration: duration, animations: animations, completion: nil)
    }

    /**
     This function allows animation of the animatable properties of the `UICircularProgressRing`.
     These properties include `innerRingColor, innerRingWidth, outerRingColor, outerRingWidth, innerRingSpacing, fontColor`.
     
     Simply call this function and inside of the animation block change the animatable properties as you would in any `UView`
     animation block.
     
     The completion block is called when all animations finish.
     */
    @objc open func animateProperties(duration: TimeInterval, animations: () -> Void,
                                      completion: PropertyAnimationCompletion? = nil) {
        ringLayer.shouldAnimateProperties = true
        ringLayer.propertyAnimationDuration = duration
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Reset and call completion
            self.ringLayer.shouldAnimateProperties = false
            self.ringLayer.propertyAnimationDuration = 0.0
            completion?()
        }
        // Commit and perform animations
        animations()
        CATransaction.commit()
    }
}

// MARK: Helpers methods

extension UICircularProgressRing {
    /// Called when the animation timer is complete
    @objc private func animationDidComplete(withTimer timer: Timer) {
        delegate?.didFinishProgress?(for: self)
        (timer.userInfo as? ProgressCompletion)?()
    }

    /**
     This method is called when the application goes into the background or when the
     ProgressRing is paused using the pauseProgress method.
     This is necessary for the animation to properly pick up where it left off.
     Triggered by UIApplicationWillResignActive.

     ## Author
     Nicolai Cornelis
     */
    @objc private func snapshotProgress() {
        guard let animation = ringLayer.animation(forKey: .value) else { return }
        snapshottedAnimation = animation
    }

    /**
     This method is called when the application comes back into the foreground or
     when the ProgressRing is resumed using the continueProgress method.
     This is necessary for the animation to properly pick up where it left off.
     Triggered by UIApplicationWillEnterForeground.

     ## Author
     Nicolai Cornelis
     */
    @objc private func restoreProgress() {
        guard let animation = snapshottedAnimation else { return }
        ringLayer.add(animation, forKey: AnimationKeys.value.rawValue)
    }
}
