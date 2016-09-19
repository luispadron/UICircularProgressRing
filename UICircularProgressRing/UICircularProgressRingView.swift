//
//  UICircularProgressRingView.swift
//  TestEnv
//
//  Created by Luis Padron on 9/18/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import UIKit

@IBDesignable
class UICircularProgressRingView: UIView {
    
    // MARK: Value Properties
    
    /**
     The value property for the progress ring. ex: (23)/100
     
     ## Important ##
     Default = 0
     When assigning to this var the view will be redrawn.
     Recommended to assign value using setProgress(_:) instead.
     
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
     
     When assigning to this var the view will be redrawn.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var maxValue: CGFloat = 100 {
        didSet {
            self.ringLayer.maxValue = self.maxValue
        }
    }
    
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
     
     When assigning to this var the view will be redrawn.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var progressRingStyle: Int = 1 {
        didSet {
            self.ringLayer.progressRingStyle = self.progressRingStyle
        }
    }
    
    /**
     An array of CGFloats, used to calculate the dash length for progressRingStyle = 3
     
     ## Important ##
     Default = [7.0, 7.0]
     
     When assigning to this var the view will be redrawn.
     
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
     
     Values should be in degrees
     
     When assigning to this var the view will be redrawn.
     
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
     
     Values should be in degrees
     
     When assigning to this var the view will be redrawn.
     
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
     
     When assigning to this var the view will be redrawn.
     
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
     
     When assigning to this var the view will be redrawn.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var outerRingColor: UIColor = UIColor.gray {
        didSet {
            self.ringLayer.outerRingColor = self.outerRingColor
        }
    }
    
    /**
     The style for the outer ring line (how it is drawn on screen)
     Range [1,3]
     - 1: Line with a squared off end
     - 2: Line with a rounded off end
     - 3: Line with a square end
     - <1 & >3: Defaults to style 1
     
     ## Important ##
     Default = 1
     
     When assigning to this var the view will be redrawn
     
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
    
    private var outStyle: CGLineCap = .butt
    
    // MARK: Inner Ring properties
    
    /**
     The width of the inner ring for the progres bar
     
     ## Important ##
     Default = 5.0
     
     When assigning to this var the view will be redrawn.
     
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
     
     When assigning to this var the view will be redrawn.
     
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
     
     When assigning to this var the view will be redrawn.
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var innerRingSpacing: CGFloat = 1 {
        didSet {
            self.ringLayer.innerRingSpacing = self.innerRingSpacing
        }
    }
    /**
     The style for the inner ring line (how it is drawn on screen)
     
     Range [1,3]
     
     - 1: Line with a squared off end
     - 2: Line with a rounded off end
     - 3: Line with a square end
     - <1 & >3: Defaults to style 2
     
     ## Important ##
     Default = 2
     
     When assigning to this var the view will be redrawn
     
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
    
    private var inStyle: CGLineCap = .butt
    
    // MARK: Label
    
    /**
     The private value label used to show value user has provided
     
     */
    lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    /**
     A toggle for showing or hiding the value label.
     If false the current value will not be shown.
     The value label is also never added as a subview or drawn
     
     ## Important ##
     Default = true
     
     When assigning to this var the view will be redrawn
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var shouldShowValueText: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /**
     The text color for the value label field
     
     ## Important ##
     Default = UIColor.black
     
     When assigning to this var the view will be redrawn
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var textColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /**
     The text/font size for the value label
     
     ## Important ##
     Default = 18
     
     When assigning to this var the view will be redrawn
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var fontSize: CGFloat = 18 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /**
     The name of the custom font for value label to use
     Provide name as a string, and make sure "Fonts Provided by application"
     is set inside the Info.plist of the project.
     
     ## Important ##
     Default = nil
     
     When assigning to this var the view will be redrawn
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var customFontWithName: String? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /**
     The name of the value indicator the value label will
     appened to the value
     Example: "%" -> "100%"
     
     ## Important ##
     Default = "%"
     
     When assigning to this var the view will be redrawn
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var valueIndicator: String = "%" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /**
     A toggle for showing or hiding floating points from
     the value in the value label
     
     ## Important ##
     Default = false (dont show)
     
     To customize number of decmial places to show, assign a value to decimalPlaces.
     
     When assigning to this var the view will be redrawn
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var showFloatingPoint: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /**
     The amount of decimal places to show in the value label
     
     ## Important ##
     Default = 2
     
     Only used when showFloatingPoint = true
     
     When assigning to this var the view will be redrawn
     
     ## Author:
     Luis Padron
     */
    @IBInspectable public var decimalPlaces: Int = 2 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // MARK: Animation properties
    
    /**
     The duration of the animation
     
     ## Important ##
     Default = 1.0
     
     Only used when calling .setValue(animated: true)
     
     ## Author:
     Luis Padron
     */
    public var animationDuration: CFTimeInterval = 1.0
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
    /**
     Private CAShapeLayer for drawing and animating the progress ring
     
     ## Author:
     Luis Padron
     */
    private lazy var shapeLayer = CAShapeLayer()
    /**
     Private Timer for animating purposes
     
     ## Author:
     Luis Padron
     */
    private lazy var timer = Timer()
    /**
     Start time for animating value label
     
     ## Author:
     Luis Padron
     */
    private lazy var startTime = CACurrentMediaTime()
    /**
     CADisplayLink for animating the label
     
     ## Author:
     Luis Padron
     */
    private lazy var link = CADisplayLink()
    
    // MARK: Methods
    
    /**
     Ring gets drawn from its layer
     
     ## Author:
     Luis Padron
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        // Initialize the layer
        self.ringLayer.frame = self.frame
        self.ringLayer.bounds = self.bounds
        self.ringLayer.value = value
        self.ringLayer.maxValue = maxValue
        self.ringLayer.progressRingStyle = progressRingStyle
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
    }
    
    override func draw(_ rect: CGRect) {
        self.setNeedsDisplay()
    }
    
    public func set(value: CGFloat, animationDuration: TimeInterval, completion: (() -> Void)?) {
        self.ringLayer.animated = true
        self.ringLayer.animationDuration = animationDuration
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let comp = completion {
                comp()
            }
        }
        self.ringLayer.value = value
        CATransaction.commit()
        
    }
    
    var ringLayer: UICircularProgressRingLayer {
        return self.layer as! UICircularProgressRingLayer
    }
    
    override class var layerClass: AnyClass {
        get {
            return UICircularProgressRingLayer.self
        }
    }
    
}
