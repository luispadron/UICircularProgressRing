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
    @IBInspectable public var value: CGFloat = 0
    /// The value of the maximum amount of progress. Range [0, ∞]
    @IBInspectable public var maxValue: CGFloat = 100
    
    // MARK: Outer Ring properties
    @IBInspectable public var outerRingWidth: CGFloat = 10.0
    @IBInspectable public var outerRingColor: UIColor = UIColor.gray
    @IBInspectable public var outerStartAngle: CGFloat = 0
    @IBInspectable public var outerEndAngle: CGFloat = 360
    
    // MARK: Inner Ring properties
    @IBInspectable public var innerRingWidth: CGFloat = 5.0
    @IBInspectable public var innerRingColor: UIColor = UIColor.blue
    @IBInspectable public var innerRingSpacing: CGFloat = 1
    @IBInspectable public var innerStartAngle: CGFloat = 0
    @IBInspectable public var innerEndAngle: CGFloat = 360
    
    // MARK: Booleans
    @IBInspectable var rotateClockWise: Bool = true
    
    // MARK: Constant
    private let pi = CGFloat(M_PI)
    
    // MARK: Methods
    override public func draw(_ rect: CGRect) {
        
        drawRings()
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
        outerPath.stroke()
        outerPath.close()
        
        // Draw the inner path
        let radiusIn = max(bounds.width - radiusOut - innerRingSpacing - innerRingWidth*2, bounds.height - outerPath.lineWidth - innerRingSpacing - innerRingWidth*2)
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn/2 - innerRingWidth/2, startAngle: innerStartAngle.toRads, endAngle: innerEndAngle.toRads, clockwise: true)
        
        innerPath.lineWidth = innerRingWidth
        innerRingColor.setStroke()
        innerPath.stroke()
        innerPath.close()
    }
    

}
