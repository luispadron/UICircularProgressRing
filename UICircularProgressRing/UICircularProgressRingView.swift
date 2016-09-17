//
//  UICircularProgressRing.swift
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
 A private extension to CGFloat in order to provide simple
 conversion from degrees to radians, used when drawing the rings.
 */
private extension CGFloat {
    var toRads: CGFloat { return self * CGFloat(M_PI) / 180 }
}

/**
 A private extension to UILabel, in order to cut down on code repeation.
 This function will update the value of the progress label, depending on the
 parameters sent.
 At the end it sizesToFit() in order to
 */
private extension UILabel {
    func update(withValue value: CGFloat, centerInView cView: UIView, valueIndicator: String, showsDecimal: Bool, decimalPlaces: Int) {
        if showsDecimal {
            self.text = String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
        } else {
            self.text = "\(Int(value))\(valueIndicator)"
        }
        self.sizeToFit()
        self.center = CGPoint(x: cView.bounds.midX, y: cView.bounds.midY)
    }
}




/**
 # UICircularProgressView
 
 Circular progress ring view.
 
 ## Author:
 Luis Padron
 
 */
@IBDesignable open class UICircularProgressRingView: UIView {
    
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
        willSet {
            self.oldValue = self.value
        }
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /**
     The old value for the progressRing
     When self.value is called, the previous value is stored
     here. For animation purposes.
     
     */
    private var oldValue: CGFloat = 0.0
    
    
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            case 1: self.outStyle = CGLineCap.butt
            case 2: self.outStyle = CGLineCap.round
            case 3: self.outStyle = CGLineCap.square
            default: self.outStyle = CGLineCap.butt
            }
            
            self.setNeedsDisplay()
        }
    }
    /**
     The private variable for outerRingCapStyle
     When the user sets the style, using a property observer this is then set
     
     ## Important ##
     Default = CGLineCap.butt
     */
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            self.setNeedsDisplay()
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
            case 1: self.inCapStyle = kCALineCapButt
            case 2: self.inCapStyle = kCALineCapRound
            case 3: self.inCapStyle = kCALineCapSquare
            default: self.inCapStyle = kCALineCapRound
            }
            
            self.setNeedsDisplay()
        }
    }
    /**
     The private variable for innerRingCapStyle
     When the user sets the style; using a property observer this is then set
     
     ## Important ##
     Default = kCALineCapRound
     */
    private var inCapStyle: String = kCALineCapRound
    
    
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
     Overriden draw method which draws the outer ring, inner ring,
     and the value label.
     
     ## Author:
     Luis Padron
     */
    override open func draw(_ rect: CGRect) {
        drawOuterRing()
        drawInnerRing()
        if shouldShowValueText {
            drawValueLabel()
        }
    }
    
    /**
     Sets the current value for the progress ring
     
     - Parameter newVal: The value to be set for the progress ring
     - Parameter animated: Boolean value if the progress ring should be animated or not
     
     ## Important ##
     The view will be drawn and animated if set to animate
     
     ## Author:
     Luis Padron
     */
    public func setProgress(value newVal: CGFloat, animated: Bool, completion: (() -> Void)?) {
        value = newVal
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if let comp = completion {
                comp()
            }
        }
        
        if animated {
            animateInnerRing()
        }
        
        CATransaction.commit()
        
    }
    
    // MARK: Helper Methods
    
    private func drawOuterRing() {
        // Properties of view
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Draw the outer path
        let radiusOut = max(bounds.width, bounds.height)/2 - outerRingWidth/2
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusOut,
                                     startAngle: startAngle.toRads,
                                     endAngle: endAngle.toRads,
                                     clockwise: true)
        
        outerPath.lineWidth = outerRingWidth
        outerRingColor.setStroke()
        outerPath.lineCapStyle = outStyle
        
        // If the style is 3 or 4, make sure to draw either dashes or dotted path
        if progressRingStyle == 3 {
            outerPath.setLineDash(patternForDashes, count: 1, phase: 0.0)
        } else if progressRingStyle == 4 {
            outerPath.setLineDash([0, outerPath.lineWidth * 2], count: 2, phase: 0)
            outerPath.lineCapStyle = .round
        }
        // Stroke and done
        outerPath.stroke()
    }
    
    private func drawInnerRing() {
        // Draw the inner path of the ring
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Calculate the center difference between the end and start angle
        let angleDiff: CGFloat = endAngle.toRads - startAngle.toRads
        // Calculate how much we should draw depending on the value set
        let arcLenPerValue = angleDiff / CGFloat(maxValue)
        // The inner end angle some basic math is done
        let innerEndAngle = arcLenPerValue * CGFloat(value) + startAngle.toRads
        
        // The radius for style 1 is set below
        // The radius for style 1 is a bit less than the outer, this way it looks like its inside the circle
        var radiusIn = (max(bounds.width - outerRingWidth*2 - innerRingSpacing, bounds.height - outerRingWidth*2 - innerRingSpacing)/2) - innerRingWidth/2
        
        // If the style is different, mae the radius equal to the outerRadius
        if progressRingStyle >= 2 {
            radiusIn = (max(bounds.width, bounds.height)/2) - (outerRingWidth/2)
        }
        // Start drawing
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn,
                                     startAngle: startAngle.toRads,
                                     endAngle: innerEndAngle,
                                     clockwise: true)
        
        // Create a shape layer from the path in order to animate later on
        shapeLayer.path = innerPath.cgPath
        shapeLayer.strokeColor = innerRingColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = innerRingWidth
        shapeLayer.strokeEnd = 1.0
        shapeLayer.lineCap = inCapStyle
        shapeLayer.lineJoin = inCapStyle
        // Add to our sublayer
        self.layer.addSublayer(shapeLayer)
    }
    
    private func drawValueLabel() {
        // Draws the text field
        valueLabel.update(withValue: value, centerInView: self, valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
        // Some basic label properties are set
        valueLabel.font = UIFont.systemFont(ofSize: fontSize)
        valueLabel.textAlignment = .center
        valueLabel.textColor = textColor
        
        if let fName = customFontWithName {
            valueLabel.font = UIFont(name: fName, size: fontSize)
        }
        
        // Make sure to size the label to fit
        valueLabel.sizeToFit()
        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        // Add it as a subview
        self.addSubview(valueLabel)
    }
    
    private func animateInnerRing() {
        // Create an animation for the ShapeLayer we defined in drawInnerRing(_:)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = animationDuration
        animation.fromValue = 0.0
        animation.timingFunction = CAMediaTimingFunction(name: animationStyle)
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        shapeLayer.add(animation, forKey: "animateInnerRing")
        
        // If were showing the value text, then animate that as well
        if shouldShowValueText {
            valueLabel.text = "\(oldValue)"
            link = CADisplayLink(target: self, selector: #selector(self.animateLabel))
            link.add(to: RunLoop.current, forMode: .commonModes)
        }
    }
    
    
    @objc private func animateLabel() {
        let dt = (link.timestamp - startTime) / animationDuration
        
        // If our animating value is the value the user set then were done animating
        if (dt >= 1.0) {
            valueLabel.update(withValue: value, centerInView: self, valueIndicator: valueIndicator,
                              showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
            // Remove this animation run loop
            link.remove(from: RunLoop.current, forMode: .commonModes)
            return
        }
        // Not done animating, calculate the current value based on time and duration left
        
        let current = (value - oldValue) * CGFloat(dt) + oldValue
        
        // Update the label with the new current value we came up with
        valueLabel.update(withValue: current, centerInView: self, valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
    }
}
