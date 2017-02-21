//
//  UICircularProgressRingLayer.swift
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
 At the end sizeToFit() is called in order to ensure text gets drawn correctly
 */
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

/**
 The internal subclass for CAShapeLayer.
 This is the class that handles all the drawing and animation.
 This class is not interacted with, instead properties are set in UICircularProgressRingView
 and those are delegated to here.
 
 */
class UICircularProgressRingLayer: CAShapeLayer {
    
    // MARK: Properties
    
    /**
     The NSManaged properties for the layer.
     These properties are initialized in UICircularProgressRingView.
     They're also assigned by mutating UICircularProgressRingView.
     */
    @NSManaged var value: CGFloat
    @NSManaged var maxValue: CGFloat
    
    @NSManaged var viewStyle: Int
    @NSManaged var patternForDashes: [CGFloat]
    
    @NSManaged var startAngle: CGFloat
    @NSManaged var endAngle: CGFloat
    
    @NSManaged var outerRingWidth: CGFloat
    @NSManaged var outerRingColor: UIColor
    @NSManaged var outerCapStyle: CGLineCap
    
    @NSManaged var innerRingWidth: CGFloat
    @NSManaged var innerRingColor: UIColor
    @NSManaged var innerCapStyle: CGLineCap
    @NSManaged var innerRingSpacing: CGFloat
    
    @NSManaged var shouldShowValueText: Bool
    @NSManaged var fontColor: UIColor
    @NSManaged var fontSize: CGFloat
    @NSManaged var customFontWithName: String?
    @NSManaged var valueIndicator: String
    @NSManaged var showFloatingPoint: Bool
    @NSManaged var decimalPlaces: Int
    
    var animationDuration: TimeInterval = 1.0
    var animationStyle: String = kCAMediaTimingFunctionEaseInEaseOut
    var animated = false
    
    // The value label which draws the text for the current value
    lazy private var valueLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    // MARK: Draw
    
    /**
     Overriden for custom drawing.
     Draws the outer ring, inner ring and value label.
     */
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        // Draw the rings
        drawOuterRing()
        drawInnerRing()
        // Draw the label
        drawValueLabel()
        UIGraphicsPopContext()
    }
    
    // MARK: Animation methods
    
    /**
     Watches for changes in the value property, and setNeedsDisplay accordingly
     */
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "value" {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    
    /**
     Creates animation when value property is changed
     */
    override func action(forKey event: String) -> CAAction? {
        if event == "value" && self.animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = self.presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: animationStyle)
            animation.duration = animationDuration
            return animation
        }
        
        return super.action(forKey: event)
    }
    
    
    // MARK: Helpers
    
    /**
     Draws the outer ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawOuterRing() {
        guard outerRingWidth > 0 else { return }
        
        let width = bounds.width
        let height = bounds.width
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius = max(width, height)/2 - outerRingWidth/2
        
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: outerRadius,
                                     startAngle: startAngle.toRads,
                                     endAngle: endAngle.toRads,
                                     clockwise: true)
        
        outerPath.lineWidth = outerRingWidth
        outerPath.lineCapStyle = outerCapStyle
        
        // If the style is 3 or 4, make sure to draw either dashes or dotted path
        if viewStyle == 3 {
            outerPath.setLineDash(patternForDashes, count: patternForDashes.count, phase: 0.0)
        } else if viewStyle == 4 {
            outerPath.setLineDash([0, outerPath.lineWidth * 2], count: 2, phase: 0)
            outerPath.lineCapStyle = .round
        }
        
        outerRingColor.setStroke()
        outerPath.stroke()
    }
    
    /**
     Draws the inner ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawInnerRing() {
        guard innerRingWidth > 0 else { return }
        
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
        if viewStyle >= 2 {
            radiusIn = (max(bounds.width, bounds.height)/2) - (outerRingWidth/2)
        }
        // Start drawing
        let innerPath = UIBezierPath(arcCenter: center,
                                     radius: radiusIn,
                                     startAngle: startAngle.toRads,
                                     endAngle: innerEndAngle,
                                     clockwise: true)
        innerPath.lineWidth = innerRingWidth
        innerPath.lineCapStyle = innerCapStyle
        innerRingColor.setStroke()
        innerPath.stroke()
    }
    
    /**
     Draws the value label for the view.
     Only drawn if shouldShowValueText = true
     */
    private func drawValueLabel() {
        guard shouldShowValueText else { return }
        
        // Draws the text field
        // Some basic label properties are set
        valueLabel.font = UIFont.systemFont(ofSize: fontSize)
        valueLabel.textAlignment = .center
        valueLabel.textColor = fontColor
        
        if let fName = customFontWithName {
            valueLabel.font = UIFont(name: fName, size: fontSize)
        }
        
        valueLabel.update(withValue: value, valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint, decimalPlaces: decimalPlaces)
        
        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        valueLabel.drawText(in: self.bounds)
    }
}
