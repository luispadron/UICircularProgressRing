//
//  UICircularProgressRingView.swift
//  UICircularProgressRing
//
//  Copyright (c) 2016 Luis Padron
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software
//  is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

/**
 
 # UICiruclarProgressRingView
 
 This is the UIView subclass that creates and handles everything
 to do with the progress ring
 
 This class has a custom CALayer (UICircularProgressRingLayer) which
 handels the drawing and animating of the view
 
 The properties in this class correspond with the properties in UICircularProgressRingLayer.
 When they are set in here, they are also set for the layer and drawn accordingly
 
 Read the docs for what each property does and what can be customized.
 
 ## Author:
 Luis Padron
 
 */
@IBDesignable open class UICircularProgressRingView: UIView {
    
    // MARK: Delegate
    /**
     The delegate for the UICircularProgressRingView
     
     ## Important ##
     When progress is done updating via UICircularProgressRingView.setValue(_:), the
     finishedUpdatingProgressFor(_ ring: UICircularProgressRingView) will be called.
     
     The ring will be passed to the delegate in order to keep track of multiple ring updates if needed.
     
     ## Author:
     Luis Padron
     */
    public var delegate: UICircularProgressRingDelegate?
    
    // MARK: Value Properties
    
    /**
     The value property for the progress ring. ex: (23)/100
     
     ## Important ##
     Default = 0
     
     Recommended to assign value using setProgress(_:) instead as you have more control over what happens
     This is public simply for storyboard support
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var value: CGFloat = 0 {
        didSet {
            self.ringLayer.value = self.value
        }
    }
    
    /**
     The max value for the progress ring. ex: 23/(100)
     Used to calculate amount of progress depending on self.value and self.maxValue
     
     ## Important ##
     Default = 100
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var maxValue: CGFloat = 100 {
        didSet {
            self.ringLayer.maxValue = self.maxValue
        }
    }
    
    // MARK: View Style
    
    /**
     Variable for the style of the progress ring.
     
     Range: [1,4]
     
     The four styles are
     
     - 1: Radius of the inner ring is smaller (inner ring inside outer ring)
     - 2: Radius of inner ring is equal to outer ring (both at same location)
     - 3: Radius of inner ring is equal to outer ring, and the outer ring is dashed
     - 4: Radius of inner ring is equal to outer ring, and the outer ring is dotted
     
     ## Important ##
     Default = 1
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var viewStyle: Int = 1 {
        didSet {
            self.ringLayer.viewStyle = self.viewStyle
        }
    }
    
    /**
     An array of CGFloats, used to calculate the dash length for viewStyle = 3
     
     ## Important ##
     Default = [7.0, 7.0]
     
     ## Author:
     Luis Padron
     */
    public var patternForDashes: [CGFloat] = [7.0, 7.0] {
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
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var startAngle: CGFloat = 0 {
        didSet {
            self.ringLayer.startAngle = self.startAngle
        }
    }
    
    /**
     The end angle for the entire progress ring
     
     Please note that Cocoa Touch uses a clockwise rotating unit circle.
     I.e: 90 degrees is at the bottom and 270 degrees is at the top
     
     ## Important ##
     Default = 0 (degrees)
     
     Values should be in degrees (they're converted to radians internally)
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var endAngle: CGFloat = 360 {
        didSet {
            self.ringLayer.endAngle = self.endAngle
        }
    }
    
    // MARK: Outer Ring properties
    
    /**
     The width of the outer ring for the progres bar
     
     ## Important ##
     Default = 10.0
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var outerRingWidth: CGFloat = 10.0 {
        didSet {
            self.ringLayer.outerRingWidth = self.outerRingWidth
        }
    }
    
    /**
     The color for the outer ring
     
     ## Important ##
     Default = UIColor.gray
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var outerRingColor: UIColor = UIColor.gray {
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
     Default = 1
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var outerRingCapStyle: Int = 1 {
        didSet {
            switch self.outerRingCapStyle{
            case 1:
                self.outStyle = .butt
                self.ringLayer.outerCapStyle = .butt
            case 2:
                self.outStyle = .round
                self.ringLayer.outerCapStyle = .round
            case 3:
                self.outStyle = .square
                self.ringLayer.outerCapStyle = .square
            default:
                self.outStyle = .butt
                self.ringLayer.outerCapStyle = .butt
            }
        }
    }
    
    /**
     
     A private outerRingCapStyle variable, this is set whenever the
     IB compatible variable above is set.
     
     Basically in here because IB doesn't support CGLineCap selection.
     
     */
    private var outStyle: CGLineCap = .butt
    
    // MARK: Inner Ring properties
    
    /**
     The width of the inner ring for the progres bar
     
     ## Important ##
     Default = 5.0
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var innerRingWidth: CGFloat = 5.0 {
        didSet {
            self.ringLayer.innerRingWidth = self.innerRingWidth
        }
    }
    
    /**
     The color of the inner ring for the progres bar
     
     ## Important ##
     Default = UIColor.blue
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var innerRingColor: UIColor = UIColor.blue {
        didSet {
            self.ringLayer.innerRingColor = self.innerRingColor
        }
    }
    
    /**
     The spacing between the outer ring and inner ring
     
     ## Important ##
     This only applies when using progressRingStyle = 1
     
     Default = 1
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var innerRingSpacing: CGFloat = 1 {
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
     Default = 2
     
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var innerRingCapStyle: Int = 2 {
        didSet {
            switch self.innerRingCapStyle {
            case 1:
                self.inStyle = .butt
                self.ringLayer.innerCapStyle = .butt
            case 2:
                self.inStyle = .round
                self.ringLayer.innerCapStyle = .round
            case 3:
                self.inStyle = .square
                self.ringLayer.innerCapStyle = .square
            default:
                self.inStyle = .butt
                self.ringLayer.innerCapStyle = .butt
            }
        }
    }
    
    
    /**
     
     A private innerRingCapStyle variable, this is set whenever the
     IB compatible variable above is set.
     
     Basically in here because IB doesn't support CGLineCap selection.
     
     */
    private var inStyle: CGLineCap = .butt
    
    // MARK: Label
    
    /**
     A toggle for showing or hiding the value label.
     If false the current value will not be shown.
     
     ## Important ##
     Default = true
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var shouldShowValueText: Bool = true {
        didSet {
            self.ringLayer.shouldShowValueText = self.shouldShowValueText
        }
    }
    
    /**
     The text color for the value label field
     
     ## Important ##
     Default = UIColor.black
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var fontColor: UIColor = UIColor.black {
        didSet {
            self.ringLayer.fontColor = self.fontColor
        }
    }
    
    /**
     The text/font size for the value label
     
     ## Important ##
     Default = 18
     
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var fontSize: CGFloat = 18 {
        didSet {
            self.ringLayer.fontSize = self.fontSize
        }
    }
    
    /**
     The name of the custom font for value label to use
     Provide name as a string, and make sure "Fonts Provided by application"
     is set inside the Info.plist of the project.
     
     ## Important ##
     Default = nil
     
     
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var customFontWithName: String? {
        didSet {
            self.ringLayer.customFontWithName = self.customFontWithName
        }
    }
    
    /**
     The name of the value indicator the value label will
     appened to the value
     Example: " GB" -> "100 GB"
     
     ## Important ##
     Default = "%"
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var valueIndicator: String = "%" {
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
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var showFloatingPoint: Bool = false {
        didSet {
            self.ringLayer.showFloatingPoint = self.showFloatingPoint
        }
    }
    
    /**
     The amount of decimal places to show in the value label
     
     ## Important ##
     Default = 2
     
     Only used when showFloatingPoint = true
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var decimalPlaces: Int = 2 {
        didSet {
            self.ringLayer.decimalPlaces = self.decimalPlaces
        }
    }
    
    // MARK: Animation properties
    
    /**
     The type of function animation to use
     
     ## Important ##
     Default = kCAMediaTimingFunctionEaseIn
     
     String should be from kCAMediaTimingFunction_____
     
     Only used when calling .setValue(animated: true)
     
     ## Author:
     Luis Padron
     */
    public var animationStyle: String = kCAMediaTimingFunctionEaseIn
    
    // MARK: CALayer
    
    /**
     Set the ring layer to the default layer, cated as custom layer
     */
    var ringLayer: UICircularProgressRingLayer {
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
        // Call the private initializer
        initialize()
    }
    
    /**
     Overriden public init to initialize the layer and view
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Call the private initializer
        initialize()
    }
    
    /**
     This method initializes the custom CALayer
     For some reason didSet doesnt get called during initializing, so
     has to be done manually in here or else nothing would be drawn.
     
     */
    private func initialize() {
        self.ringLayer.value = value
        self.ringLayer.maxValue = maxValue
        self.ringLayer.viewStyle = viewStyle
        self.ringLayer.patternForDashes = patternForDashes
        self.ringLayer.startAngle = startAngle
        self.ringLayer.endAngle = endAngle
        self.ringLayer.outerRingWidth = outerRingWidth
        self.ringLayer.outerRingColor = outerRingColor
        self.ringLayer.outerCapStyle = outStyle
        self.ringLayer.innerRingWidth = innerRingWidth
        self.ringLayer.innerRingColor = innerRingColor
        self.ringLayer.innerCapStyle = inStyle
        self.ringLayer.innerRingSpacing = innerRingSpacing
        self.ringLayer.shouldShowValueText = shouldShowValueText
        self.ringLayer.fontColor = fontColor
        self.ringLayer.fontSize = fontSize
        self.ringLayer.customFontWithName = customFontWithName
        self.ringLayer.showFloatingPoint = showFloatingPoint
        self.ringLayer.decimalPlaces = decimalPlaces
    }
    
    /**
     Overriden because custom drawing is happening in UICircularProgressRingLayer
     
     */
    override open func draw(_ rect: CGRect) {
        
    }
    
    
    /**
     Sets the current value for the progress ring
     
     - Parameter newVal: The value to be set for the progress ring
     - Parameter animationDuration: The time interval duration for the animation
     - Parameter completion: The completion closure block that will be called when animtion is finished (also called when animationDuration = 0)
     
     ## Important ##
     Animatin duration = 0 will cause no animation to occur
     
     ## Author:
     Luis Padron
     */
    public func setProgress(value: CGFloat, animationDuration: TimeInterval, completion: (() -> Void)?) {
        // Only animte if duration sent is greater than zero
        self.ringLayer.animated = animationDuration > 0
        self.ringLayer.animationDuration = animationDuration
        // Create a transaction to be notified when animation is complete
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Call the closure block
            self.delegate?.finishedUpdatingProgressFor(self)
            if let comp = completion {
                comp()
            }
        }
        self.ringLayer.value = value
        CATransaction.commit()
    }
}
