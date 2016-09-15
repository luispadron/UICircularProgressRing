//
//  UICircularProgressRing.swift
//  UICircularProgressRing
//
//  Created by Luis Padron on 9/13/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import UIKit

// Extension for quick conversion
extension CGFloat {
    var toRads: CGFloat { return self * CGFloat(M_PI) / 180 }
}

@IBDesignable
public class UICircularProgressRingView: UIView {
    
    // MARK: Value properties
    
    /// The value of the current progress. Range [0, maxValue]
    @IBInspectable public var value: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    /// The value of the maximum amount of progress. Range [0, ∞]
    @IBInspectable public var maxValue: CGFloat = 100 {
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
    @IBInspectable public var outerRingStyle: Int = 1 {
        didSet {
            switch self.outerRingStyle{
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
    @IBInspectable public var innerRingStyle: Int = 2 {
        didSet {
            switch self.innerRingStyle {
            case 1: self.inStyle = CGLineCap.butt
            case 2: self.inStyle = CGLineCap.round
            case 3: self.inStyle = CGLineCap.square
            default: self.inStyle = CGLineCap.butt
            }
            
            self.setNeedsDisplay()
        }
    }
    private var inStyle: CGLineCap = .round
    
    // MARK: Booleans
    @IBInspectable var rotateClockWise: Bool = true
    
    // MARK: Label
    /// The label for the value, will change an animate when value is set
    lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
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
    @IBInspectable public var showFloatingPoint: Bool = false
    
    
    // MARK: Methods
    
    override public func draw(_ rect: CGRect) {
        drawOuterRing()
        drawInnerRing()
        drawValueLabel()
    }
    
    private func drawOuterRing() {
        // Properties of view
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Draw the outer path
        let radiusOut = max(bounds.width, bounds.height)
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusOut/2 - outerRingWidth/2,
                                     startAngle: startAngle.toRads,
                                     endAngle: enndAngle.toRads,
                                     clockwise: rotateClockWise)
        
        outerPath.lineWidth = outerRingWidth
        outerRingColor.setStroke()
        outerPath.lineCapStyle = outStyle
        outerPath.stroke()
    }
    
    private func drawInnerRing() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let angleDiff: CGFloat = enndAngle.toRads - startAngle.toRads
        let arcLenPerValue = angleDiff / CGFloat(maxValue)
        
        let innerEndAngle = arcLenPerValue * CGFloat(value) + startAngle.toRads
        
        // Draw the inner path
        let radiusIn = max(bounds.width - outerRingWidth*2 - innerRingSpacing,
                           bounds.height - outerRingWidth*2 - innerRingSpacing)
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn/2 - innerRingWidth/2,
                                     startAngle: startAngle.toRads,
                                     endAngle: innerEndAngle,
                                     clockwise: true)
        
        innerPath.lineWidth = innerRingWidth
        innerRingColor.setStroke()
        innerPath.lineCapStyle = inStyle
        innerPath.stroke()
    }
    
    /// Draws the value label inside of the progress rings
    private func drawValueLabel() {
        if showFloatingPoint { valueLabel.text = "\(value)\(valueIndicator)" }
        else { valueLabel.text = "\(Int(value))\(valueIndicator)" }
        valueLabel.font = UIFont.systemFont(ofSize: fontSize)
        valueLabel.textAlignment = .center
        valueLabel.textColor = textColor
        valueLabel.sizeToFit()
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        self.addSubview(valueLabel)
    }
    
    public func setValue(_ newVal: CGFloat, animated: Bool) {
        if animated {
            
        }
        
        self.value = newVal
    }
}
