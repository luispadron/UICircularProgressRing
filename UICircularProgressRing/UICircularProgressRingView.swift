//
//  UICircularProgressRing.swift
//  UICircularProgressRing
//
//  Created by Luis Padron on 9/13/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import UIKit

// Extension for quick conversion
private extension CGFloat {
    var toRads: CGFloat { return self * CGFloat(M_PI) / 180 }
}

private extension UILabel {
    func update(withValue value: CGFloat, valueIndicator: String, showsDecimal: Bool, decimalPlaces: Int) {
        if showsDecimal {
            self.text = String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
        } else {
            self.text = "\(Int(value))\(valueIndicator)"
        }
        self.sizeToFit()
    }
}

@IBDesignable
public class UICircularProgressRingView: UIView {
    
    // MARK: Value properties
    
    /// The value of the current progress. Range [0, maxValue]
    @IBInspectable public var value: CGFloat = 0 {
        willSet {
            self.oldValue = self.value
        }
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var oldValue: CGFloat = 0.0
    
    /// The value of the maximum amount of progress. Range [0, ∞]
    @IBInspectable public var maxValue: CGFloat = 100 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    @IBInspectable public var progressRingStyle: Int = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var patternForDashes: [CGFloat] = [7.0, 7.0] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    // MARK: Outer Ring properties
    
    @IBInspectable public var outerRingWidth: CGFloat = 10.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var outerRingColor: UIColor = UIColor.gray {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var startAngle: CGFloat = 0 {
        didSet {
            // Make sure view is redrawn when this property is set
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var enndAngle: CGFloat = 360 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
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
    private var outStyle: CGLineCap = .butt
    
    // MARK: Inner Ring properties
    
    @IBInspectable public var innerRingWidth: CGFloat = 5.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var innerRingColor: UIColor = UIColor.blue {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var innerRingSpacing: CGFloat = 1 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var innerRingCapStyle: Int = 2 {
        didSet {
            switch self.innerRingCapStyle {
            case 1: self.inCapStyle = kCALineCapButt
            case 2: self.inCapStyle = kCALineCapRound
            case 3: self.inCapStyle = kCALineCapSquare
            default: self.inCapStyle = kCALineCapButt
            }
            
            self.setNeedsDisplay()
        }
    }
    private var inCapStyle: String = kCALineCapButt
    
    
    // MARK: Label
    /// The label for the value, will change an animate when value is set
    lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    @IBInspectable public var shouldShowValueText: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var fontSize: CGFloat = 18 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var valueIndicator: String = "%" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var showFloatingPoint: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    @IBInspectable public var decimalPlaces: Int = 2
    
    public var animationDuration: CFTimeInterval = 1.0
    public var animationStyle: String = kCAMediaTimingFunctionEaseIn
    
    private lazy var shapeLayer = CAShapeLayer()
    
    private lazy var timer = Timer()
    
    private lazy var startTime = CACurrentMediaTime()
    private lazy var link = CADisplayLink()
    public var delegate: UICircularProgressRingDelegate?
    
    // MARK: Methods
    
    override public func draw(_ rect: CGRect) {
        drawOuterRing()
        drawInnerRing()
        if shouldShowValueText {
            drawValueLabel()
        }
    }
    
    private func drawOuterRing() {
        // Properties of view
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Draw the outer path
        let radiusOut = max(bounds.width, bounds.height)/2 - outerRingWidth/2
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusOut,
                                     startAngle: startAngle.toRads,
                                     endAngle: enndAngle.toRads,
                                     clockwise: true)
        
        outerPath.lineWidth = outerRingWidth
        outerRingColor.setStroke()
        outerPath.lineCapStyle = outStyle
        
        if progressRingStyle == 3 {
            outerPath.setLineDash(patternForDashes, count: 1, phase: 0.0)
        } else if progressRingStyle == 4 {
            outerPath.setLineDash([0, outerPath.lineWidth * 2], count: 2, phase: 0)
            outerPath.lineCapStyle = .round
        }
        
        outerPath.stroke()
    }
    
    private func drawInnerRing() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let angleDiff: CGFloat = enndAngle.toRads - startAngle.toRads
        let arcLenPerValue = angleDiff / CGFloat(maxValue)
        
        let innerEndAngle = arcLenPerValue * CGFloat(value) + startAngle.toRads
        
        var radiusIn = (max(bounds.width - outerRingWidth*2 - innerRingSpacing, bounds.height - outerRingWidth*2 - innerRingSpacing)/2) - innerRingWidth/2
        
        if progressRingStyle >= 2 {
            radiusIn = (max(bounds.width, bounds.height)/2) - (outerRingWidth/2)
        }
        
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn,
                                     startAngle: startAngle.toRads,
                                     endAngle: innerEndAngle,
                                     clockwise: true)
        
        shapeLayer.path = innerPath.cgPath
        shapeLayer.strokeColor = innerRingColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = innerRingWidth
        shapeLayer.strokeEnd = 1.0
        shapeLayer.lineCap = inCapStyle
        shapeLayer.lineJoin = inCapStyle
        
        self.layer.addSublayer(shapeLayer)
    }
    
    /// Draws the value label inside of the progress rings
    private func drawValueLabel() {
        valueLabel.update(withValue: value, valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
        
        valueLabel.font = UIFont.systemFont(ofSize: fontSize)
        valueLabel.textAlignment = .center
        valueLabel.textColor = textColor
        valueLabel.sizeToFit()
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        self.addSubview(valueLabel)
    }
    
    public func setValue(_ newVal: CGFloat, animated: Bool) {
        value = newVal
        if animated {
            animateInnerRing()
        }
        
    }
    
    func animateInnerRing() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = animationDuration
        animation.fromValue = 0.0
        animation.timingFunction = CAMediaTimingFunction(name: animationStyle)
        animation.toValue = 1.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        shapeLayer.add(animation, forKey: "animateInnerRing")
        
        if shouldShowValueText {
            valueLabel.text = "\(oldValue)"
            link = CADisplayLink(target: self, selector: #selector(self.animateLabel))
            link.add(to: RunLoop.current, forMode: .commonModes)
        }
    }
    
    
    @objc private func animateLabel() {
        let dt = (link.timestamp - startTime) / animationDuration
        
        if (dt >= 1.0) {
            valueLabel.update(withValue: value, valueIndicator: valueIndicator,
                              showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
            
            link.remove(from: RunLoop.current, forMode: .commonModes)
            delegate?.progressRingAnimationDidFinish()
            return
        }
        
        let current = (value - oldValue) * CGFloat(dt) + oldValue
        
        valueLabel.update(withValue: current, valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
    }
}
