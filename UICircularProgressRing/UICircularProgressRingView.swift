//
//  UICircularProgressRing.swift
//  UICircularProgressRing
//
//  Created by Luis Padron on 9/13/16.
//  Copyright © 2016 Luis Padron. All rights reserved.
//

import UIKit

@IBDesignable
public class UICircularProgressRingView: UIView {
    
    // MARK: Value properties
    /// The value of the current progress. Range [0, maxValue]
    @IBInspectable public var value: CGFloat = 0.0 {
        willSet(newValue) {
            if newValue < 0.0 { print("Range error: (value) must be between 0 and self.maxValue") }
            else { self.maxValue = newValue }
        }
    }
    /// The value of the maximum amount of progress. Range [0, ∞]
    @IBInspectable public var maxValue: CGFloat = 100 {
        willSet(newValue) {
            if newValue < 0.0 { print("Range error: (maxValue) must be between 0 and ∞") }
            else { self.maxValue = newValue }
        }
    }
    
    // MARK: Outer Ring properties
    @IBInspectable public var outerRingWidth: CGFloat = 10.0
    @IBInspectable public var outerRingColor: UIColor = UIColor.gray
    @IBInspectable public var startAngle: CGFloat = 0
    @IBInspectable public var endAngle: CGFloat = 360
    
    // MARK: Inner Ring properties
    
    
    // MARK: Booleans
    @IBInspectable var rotateClockWise: Bool = true
    
    
    let pi = CGFloat(M_PI)
    
    override public func draw(_ rect: CGRect) {
        // Properties of view
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(bounds.width, bounds.height)
        
        
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: radius/2 - outerRingWidth/2,
                                     startAngle: startAngle,
                                     endAngle: endAngle,
                                     clockwise: rotateClockWise)
        
        outerPath.lineWidth = outerRingWidth
        outerRingColor.setStroke()
        outerPath.stroke()
    }
}
