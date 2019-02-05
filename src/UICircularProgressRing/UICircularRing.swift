//
//  UICircularRing.swift
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

/**
 
 # UICircularRing

 This is the base class of `UICircularProgressRing` and `UICircularTimerRing`.

 This is the UIView subclass that creates and handles everything
 to do with the circular ring.
 
 This class has a custom CAShapeLayer (UICircularRingLayer) which
 handels the drawing and animating of the view
 
 The properties in this class correspond with the
 properties in UICircularRingLayer.
 When they are set in here, they are also set for the layer and drawn accordingly
 
 Read the docs for what each property does and what can be customized.
 
 ## Author
 Luis Padron
 
 */
@IBDesignable open class UICircularRing: UIView {

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
            let style = UICircularRingStyle(rawValue: newValue)
            ringStyle = style ?? .inside
        }
    }

    /**
     The style of the progress ring.
     
     Type: `UICircularRingStyle`
     
     The five styles include `inside`, `ontop`, `dashed`, `dotted`, and `gradient`
     
     ## Important ##
     Default = UICircularRingStyle.inside
     
     ## Author
     Luis Padron
     */
    @objc open var ringStyle: UICircularRingStyle = .inside {
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
    @objc open var gradientStartPosition: UICircularRingGradientPosition = .topRight {
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
    @objc open var gradientEndPosition: UICircularRingGradientPosition = .bottomLeft {
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
    var snapshottedAnimation: CAAnimation?

    /// The completion timer, also indicates wether or not the view is animating
    var completionTimer: Timer?

    // MARK: Layer

    /**
     Set the ring layer to the default layer, cated as custom layer
     */
    internal var ringLayer: UICircularRingLayer {
        // swiftlint:disable:next force_cast
        return layer as! UICircularRingLayer
    }

    /**
     Overrides the default layer with the custom UICircularRingLayer class
     */
    override open class var layerClass: AnyClass {
        return UICircularRingLayer.self
    }

    // MARK: Type aliases

    /**
     Typealias for animateProperties(duration:animations:completion:) fucntion completion
     */
    public typealias PropertyAnimationCompletion = (() -> Void)

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
    func initialize() {
        // This view will become the value delegate of the layer, which will call the updateValue method when needed
        ringLayer.valueDelegate = self

        // Helps with pixelation and blurriness on retina devices
        layer.contentsScale = UIScreen.main.scale
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale * 2
        layer.masksToBounds = false

        ringLayer.fullCircle = fullCircle
        ringLayer.isClockwise = isClockwise

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
        ringLayer.fontColor = fontColor
        ringLayer.font = font

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
     Overriden because of custom layer drawing in UICircularRingLayer
     */
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    /**
     Called whenever the layer updates its `value` keypath, this method will then simply call its delegate with
     the `newValue` so that it notifies any delegates who may need to know about value updates in real time
     */
    func didUpdateValue(newValue: CGFloat) { }

    func willDisplayLabel(label: UILabel) { }

    /**
     This function allows animation of the animatable properties of the `UICircularRing`.
     These properties include `innerRingColor, innerRingWidth, outerRingColor, outerRingWidth, innerRingSpacing, fontColor`.
     
     Simply call this function and inside of the animation block change the animatable properties as you would in any `UView`
     animation block.
     
     The completion block is called when all animations finish.
     */
    @objc open func animateProperties(duration: TimeInterval, animations: () -> Void) {
        animateProperties(duration: duration, animations: animations, completion: nil)
    }

    /**
     This function allows animation of the animatable properties of the `UICircularRing`.
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

// MARK: Helpers

extension UICircularRing {
    /**
     This method is called when the application goes into the background or when the
     ProgressRing is paused using the pauseProgress method.
     This is necessary for the animation to properly pick up where it left off.
     Triggered by UIApplicationWillResignActive.

     ## Author
     Nicolai Cornelis
     */
    @objc func snapshotProgress() {
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
    @objc func restoreProgress() {
        guard let animation = snapshottedAnimation else { return }
        ringLayer.add(animation, forKey: AnimationKeys.value.rawValue)
    }
}

extension UICircularRing {
    /// Helper enum for animation key
    enum AnimationKeys: String {
        case value
    }
}
