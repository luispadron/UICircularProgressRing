//
//  UICircularProgressRingView.swift
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

/**
 
 # UICiruclarProgressRingView
 
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
@IBDesignable open class UICircularProgressRingView: UIView {
    
    // MARK: Delegate
    /**
     The delegate for the UICircularProgressRingView
     
     ## Important ##
     When progress is done updating via UICircularProgressRingView.setValue(_:), the
     finishedUpdatingProgressFor(_ ring: UICircularProgressRingView) will be called.
     
     The ring will be passed to the delegate in order to keep track of 
     multiple ring updates if needed.
     
     ## Author
     Luis Padron
     */
    open weak var delegate: UICircularProgressRingDelegate?
    
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
            self.ringLayer.fullCircle = self.fullCircle
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
     
     The current value of the progress ring after animating, use setProgress(value:) 
     to alter the value with the option to animate and have a completion handler.
     
     ## Author
     Luis Padron
     */
    @IBInspectable open var value: CGFloat = 0 {
        didSet {
            if value < minValue {
                print("Warning in: UICircularProgressRingView.value: Line #\(#line)")
                print("Attempted to set a value less than minValue, value has been set to minValue.\n")
                self.value = self.minValue
            }
            self.ringLayer.value = self.value
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
    open var currentValue: CGFloat? {
        get {
            if isAnimating {
                return self.layer.presentation()?.value(forKey: "value") as? CGFloat
            } else {
                return self.value
            }
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
    @IBInspectable open var minValue: CGFloat = 0.0 {
        didSet {
            self.ringLayer.minValue = abs(self.minValue)
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
    @IBInspectable open var maxValue: CGFloat = 100.0 {
        didSet {
            self.ringLayer.maxValue = abs(self.maxValue)
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
            self.ringStyle = style ?? .inside
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
    open var ringStyle: UICircularProgressRingStyle = .inside {
        didSet {
            self.ringLayer.ringStyle = self.ringStyle
        }
    }
    
    
    /**
     An array of CGFloats, used to calculate the dash length for viewStyle = 3
     
     ## Important ##
     Default = [7.0, 7.0]
     
     ## Author
     Luis Padron
     */
    open var patternForDashes: [CGFloat] = [7.0, 7.0] {
        didSet {
            self.ringLayer.patternForDashes = self.patternForDashes
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
            self.ringLayer.startAngle = self.startAngle
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
            self.ringLayer.endAngle = self.endAngle
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
    open var gradientColors: [UIColor] = [UIColor]() {
        didSet {
            self.ringLayer.gradientColors = self.gradientColors
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
    open var gradientColorLocations: [CGFloat]? = nil {
        didSet {
            self.ringLayer.gradientColorLocations = self.gradientColorLocations
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
    open var gradientStartPosition: UICircularProgressRingGradientPosition = .topRight {
        didSet {
            self.ringLayer.gradientStartPosition = self.gradientStartPosition
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
    open var gradientEndPosition: UICircularProgressRingGradientPosition = .bottomLeft {
        didSet {
            self.ringLayer.gradientEndPosition = self.gradientEndPosition
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
            self.ringLayer.outerRingWidth = self.outerRingWidth
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
            self.ringLayer.outerRingColor = self.outerRingColor
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
                self.outerCapStyle = .butt
            case 2:
                self.outerCapStyle = .round
            case 3:
                self.outerCapStyle = .square
            default:
                self.outerCapStyle = .butt
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
    open var outerCapStyle: CGLineCap = .butt {
        didSet {
            self.ringLayer.outerCapStyle = self.outerCapStyle
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
            self.ringLayer.innerRingWidth = self.innerRingWidth
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
            self.ringLayer.innerRingColor = self.innerRingColor
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
            self.ringLayer.innerRingSpacing = self.innerRingSpacing
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
                self.innerCapStyle = .butt
            case 2:
                self.innerCapStyle = .round
            case 3:
                self.innerCapStyle = .square
            default:
                self.innerCapStyle = .round
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
    open var innerCapStyle: CGLineCap = .round {
        didSet {
            self.ringLayer.innerCapStyle = self.innerCapStyle
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
            self.ringLayer.shouldShowValueText = self.shouldShowValueText
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
            self.ringLayer.fontColor = self.fontColor
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
            self.ringLayer.font = self.font
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
            self.ringLayer.valueIndicator = self.valueIndicator
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
            self.ringLayer.showFloatingPoint = self.showFloatingPoint
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
            self.ringLayer.decimalPlaces = self.decimalPlaces
        }
    }
    
    // MARK: Animation properties
    
    /**
     The type of animation function the ring view will use
     
     ## Important ##
     Default = kCAMediaTimingFunctionEaseIn
     
     String should be from kCAMediaTimingFunction_____
     
     Only used when calling .setValue(animated: true)
     
     ## Author
     Luis Padron
     */
    open var animationStyle: String = kCAMediaTimingFunctionEaseIn {
        didSet {
            self.ringLayer.animationStyle = self.animationStyle
        }
    }
    
    /**
     This returns whether or not the ring is currently animating
     
     ## Important ##
     Get only property
     
     ## Author
     Luis Padron
     */
    open var isAnimating: Bool {
        get { return (self.layer.animation(forKey: "value") != nil) ? true : false }
    }
    
    // MARK: Layer
    
    /**
     Set the ring layer to the default layer, cated as custom layer
     */
    internal var ringLayer: UICircularProgressRingLayer {
        return self.layer as! UICircularProgressRingLayer
    }
    
    /**
     Overrides the default layer with the custom UICircularProgressRingLayer class
     */
    override open class var layerClass: AnyClass {
        get {
            return UICircularProgressRingLayer.self
        }
    }
    
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
    internal func initialize() {
        // This view will become the value delegate of the layer, which will call the updateValue method when needed
        self.ringLayer.valueDelegate = self
        
        // Helps with pixelation and blurriness on retina devices
        self.layer.contentsScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale * 2
        self.layer.masksToBounds = false
        
        self.ringLayer.fullCircle = fullCircle
        
        self.ringLayer.value = value
        self.ringLayer.maxValue = maxValue
        self.ringLayer.minValue = minValue
        
        self.ringLayer.ringStyle = ringStyle
        self.ringLayer.patternForDashes = patternForDashes
        self.ringLayer.gradientColors = gradientColors
        self.ringLayer.gradientColorLocations = gradientColorLocations
        self.ringLayer.gradientStartPosition = gradientStartPosition
        self.ringLayer.gradientEndPosition = gradientEndPosition
        
        self.ringLayer.startAngle = startAngle
        self.ringLayer.endAngle = endAngle
        
        self.ringLayer.outerRingWidth = outerRingWidth
        self.ringLayer.outerRingColor = outerRingColor
        self.ringLayer.outerCapStyle = outerCapStyle
        
        self.ringLayer.innerRingWidth = innerRingWidth
        self.ringLayer.innerRingColor = innerRingColor
        self.ringLayer.innerCapStyle = innerCapStyle
        self.ringLayer.innerRingSpacing = innerRingSpacing
        
        self.ringLayer.shouldShowValueText = shouldShowValueText
        self.ringLayer.valueIndicator = valueIndicator
        self.ringLayer.fontColor = fontColor
        self.ringLayer.font = font
        self.ringLayer.showFloatingPoint = showFloatingPoint
        self.ringLayer.decimalPlaces = decimalPlaces

        self.backgroundColor = UIColor.clear
        self.ringLayer.backgroundColor = UIColor.clear.cgColor
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
    internal func didUpdateValue(newValue: CGFloat) {
        delegate?.didUpdateProgressValue(to: newValue)
    }
    
    /**
     Typealias for the setProgress(:) method closure
    */
    public typealias ProgressCompletion = (() -> Void)
    
    /**
     Sets the current value for the progress ring, calling this method while ring is 
     animating will cancel the previously set animation and start a new one.
     
     - Parameter newVal: The value to be set for the progress ring
     - Parameter animationDuration: The time interval duration for the animation
     - Parameter completion: The completion closure block that will be called when 
     animtion is finished (also called when animationDuration = 0), default is nil
     
     ## Important ##
     Animatin duration = 0 will cause no animation to occur, and value will instantly 
     be set
     
     ## Author
     Luis Padron
     */
    open func setProgress(value: CGFloat, animationDuration: TimeInterval,
                          completion: ProgressCompletion? = nil) {
        // Remove the current animation, so that new can be processed
        if isAnimating { self.layer.removeAnimation(forKey: "value") }
        // Only animate if duration sent is greater than zero
        self.ringLayer.animated = animationDuration > 0
        self.ringLayer.animationDuration = animationDuration
        // Create a transaction to be notified when animation is complete
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Call the closure block
            self.delegate?.finishedUpdatingProgress(forRing: self)
            completion?()
        }

        self.value = value
        CATransaction.commit()
    }
}
