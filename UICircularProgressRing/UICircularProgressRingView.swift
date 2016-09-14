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
            self.drawValueLabel()
        }
    }
    /// The value of the maximum amount of progress. Range [0, ∞]
    @IBInspectable public var maxValue: CGFloat = 100
    
    // MARK: Outer Ring properties
    
    @IBInspectable public var outerRingWidth: CGFloat = 10.0
    @IBInspectable public var outerRingColor: UIColor = UIColor.gray
    @IBInspectable public var outerStartAngle: CGFloat = 0
    @IBInspectable public var outerEndAngle: CGFloat = 360
    @IBInspectable public var outerRingStyle: Int = 1 {
        didSet {
            switch self.outerRingStyle{
            case 1: self.outStyle = CGLineCap.butt
            case 2: self.outStyle = CGLineCap.round
            case 3: self.outStyle = CGLineCap.square
            default: self.outStyle = CGLineCap.butt
            }
        }
    }
    private var outStyle: CGLineCap = .butt
    
    // MARK: Inner Ring properties
    
    @IBInspectable public var innerRingWidth: CGFloat = 5.0
    @IBInspectable public var innerRingColor: UIColor = UIColor.blue
    @IBInspectable public var innerRingSpacing: CGFloat = 1
    @IBInspectable public var innerStartAngle: CGFloat = 0
    @IBInspectable public var innerEndAngle: CGFloat = 360
    @IBInspectable public var innerRingStyle: Int = 2 {
        didSet {
            switch self.innerRingStyle {
            case 1: self.inStyle = CGLineCap.butt
            case 2: self.inStyle = CGLineCap.round
            case 3: self.inStyle = CGLineCap.square
            default: self.inStyle = CGLineCap.butt
            }
        }
    }
    private var inStyle: CGLineCap = .round
    
    // MARK: Booleans
    
    @IBInspectable var rotateClockWise: Bool = true
    
    // MARK: Constant
    
    private let pi = CGFloat(M_PI)
    
    // MARK: Label
    /// The label for the value, will change an animate when value is set
    lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @IBInspectable public var textColor: UIColor = UIColor.black
    @IBInspectable public var fontSize: CGFloat = 18
    @IBInspectable public var valueIndicator: String = "%"
    @IBInspectable public var showFloatingPoint: Bool = false
    
    
    // MARK: Methods
    
    override public func draw(_ rect: CGRect) {
        drawRings()
        drawValueLabel()
        self.setValue(50, animate: false)
    }
    
    /// Draws the inner and outer rings
    private func drawRings() {
        // Properties of view
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Draw the outer path
        let radiusOut = max(bounds.width, bounds.height)
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusOut/2 - outerRingWidth/2,
                                     startAngle: outerStartAngle.toRads,
                                     endAngle: outerEndAngle.toRads,
                                     clockwise: rotateClockWise)
        
        outerPath.lineWidth = outerRingWidth
        outerRingColor.setStroke()
        outerPath.lineCapStyle = outStyle
        outerPath.stroke()
        outerPath.close()
        
        // Draw the inner path
        let radiusIn = max(bounds.width - outerRingWidth*2 - innerRingSpacing,
                           bounds.height - outerRingWidth*2 - innerRingSpacing)
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn/2 - innerRingWidth/2, startAngle: innerStartAngle.toRads, endAngle: innerEndAngle.toRads, clockwise: true)
        
        innerPath.lineWidth = innerRingWidth
        innerRingColor.setStroke()
        innerPath.lineCapStyle = inStyle
        innerPath.stroke()
        innerPath.close()
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
    
    public func setValue(_ newVal: CGFloat, animate: Bool) {
        self.value = newVal
    }
    

}
