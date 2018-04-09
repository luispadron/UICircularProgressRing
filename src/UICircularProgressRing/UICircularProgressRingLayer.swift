//
//  UICircularProgressRingLayer.swift
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
 A private extension to CGFloat in order to provide simple
 conversion from degrees to radians, used when drawing the rings.
 */
private extension CGFloat {
    var toRads: CGFloat { return self * CGFloat.pi / 180 }
}

/**
 A private extension to UILabel, in order to cut down on code repeation.
 This function will update the value of the progress label, depending on the
 parameters sent.
 At the end sizeToFit() is called in order to ensure text gets drawn correctly
 */
private extension UILabel {
    func update(withValue value: CGFloat, valueIndicator: String,
                showsDecimal: Bool, decimalPlaces: Int, valueDelegate: UICircularProgressRingView?) {
        if showsDecimal {
            self.text = String(format: "%.\(decimalPlaces)f", value) +
                        "\(valueIndicator)"
        } else {
            self.text = "\(Int(value))\(valueIndicator)"
        }
        valueDelegate?.willDisplayLabel(label: self)
        self.sizeToFit()
    }
}

/**
 The internal subclass for CAShapeLayer.
 This is the class that handles all the drawing and animation.
 This class is not interacted with, instead 
 properties are set in UICircularProgressRingView and those are delegated to here.
 
 */
class UICircularProgressRingLayer: CAShapeLayer {
    
    // MARK: Properties
    
    /**
     The NSManaged properties for the layer.
     These properties are initialized in UICircularProgressRingView.
     They're also assigned by mutating UICircularProgressRingView properties.
     */
    @NSManaged var fullCircle: Bool
    
    @NSManaged var value: CGFloat
    @NSManaged var minValue: CGFloat
    @NSManaged var maxValue: CGFloat
    
    @NSManaged var ringStyle: UICircularProgressRingStyle
    @NSManaged var patternForDashes: [CGFloat]
    
    @NSManaged var gradientColors: [UIColor]
    @NSManaged var gradientColorLocations: [CGFloat]?
    @NSManaged var gradientStartPosition: UICircularProgressRingGradientPosition
    @NSManaged var gradientEndPosition: UICircularProgressRingGradientPosition
    
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
    @NSManaged var font: UIFont
    @NSManaged var valueIndicator: String
    @NSManaged var showFloatingPoint: Bool
    @NSManaged var decimalPlaces: Int
    
    var animationDuration: TimeInterval = 1.0
    var animationStyle: String = kCAMediaTimingFunctionEaseInEaseOut
    var animated = false
    @NSManaged weak var valueDelegate: UICircularProgressRingView?
    
    // The value label which draws the text for the current value
    lazy private var valueLabel: UILabel = UILabel(frame: .zero)

    // MARK: Animatable properties

    // Whether or not animatable properties should be animated when changed
    internal var shouldAnimateProperties: Bool = false

    // The animation duration for a animatable property animation
    internal var propertyAnimationDuration: TimeInterval = 0.0

    // The properties which are animatable
    private static let animatableProperties: [String] = ["innerRingWidth", "innerRingColor",
                                                         "outerRingWidth", "outerRingColor",
                                                         "fontColor", "innerRingSpacing"]

    // Returns whether or not a given property key is animatable
    private static func isAnimatableProperty(_ key: String) -> Bool {
        return animatableProperties.index(of: key) != nil
    }

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
        drawInnerRing(in: ctx)
        // Draw the label
        drawValueLabel()
        // Call the delegate and notifiy of updated value
        if let updatedValue = self.value(forKey: "value") as? CGFloat {
            valueDelegate?.didUpdateValue(newValue: updatedValue)
        }
        UIGraphicsPopContext()
        
    }
    
    // MARK: Animation methods
    
    /**
     Watches for changes in the value property, and setNeedsDisplay accordingly
     */
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "value" || isAnimatableProperty(key) {
            return true
        } else {
            return super.needsDisplay(forKey: key)
        }
    }
    
    /**
     Creates animation when value property is changed
     */
    override func action(forKey event: String) -> CAAction? {
        if event == "value" && self.animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = self.presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: self.animationStyle)
            animation.duration = self.animationDuration
            return animation
        } else if UICircularProgressRingLayer.isAnimatableProperty(event) && self.shouldAnimateProperties {
            let animation = CABasicAnimation(keyPath: event)
            animation.fromValue = self.presentation()?.value(forKey: event)
            animation.timingFunction = CAMediaTimingFunction(name: self.animationStyle)
            animation.duration = self.propertyAnimationDuration
            return animation
        } else {
            return super.action(forKey: event)
        }
    }
    
    
    // MARK: Helpers
    
    /**
     Draws the outer ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawOuterRing() {
        guard outerRingWidth > 0 else { return }

        let width: CGFloat = bounds.width
        let height: CGFloat = bounds.width
        let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let outerRadius: CGFloat = min(width, height)/2 - max(outerRingWidth, innerRingWidth)/2
        let start: CGFloat = fullCircle ? 0 : startAngle.toRads
        let end: CGFloat = fullCircle ? CGFloat.pi * 2 : endAngle.toRads
        
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: outerRadius,
                                     startAngle: start,
                                     endAngle: end,
                                     clockwise: true)
        
        outerPath.lineWidth = outerRingWidth
        outerPath.lineCapStyle = outerCapStyle
        
        // Update path depending on style of the ring
        switch ringStyle {
            
        case .dashed:
            outerPath.setLineDash(patternForDashes,
                                  count: patternForDashes.count,
                                  phase: 0.0)
            
        case .dotted:
            outerPath.setLineDash([0, outerPath.lineWidth * 2], count: 2, phase: 0)
            outerPath.lineCapStyle = .round
            
        default: break
            
        }
        
        outerRingColor.setStroke()
        outerPath.stroke()
    }
    
    /**
     Draws the inner ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawInnerRing(in ctx: CGContext) {
        guard innerRingWidth > 0 else { return }
        
        let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let innerEndAngle: CGFloat
        
        if fullCircle {
            innerEndAngle = (value - minValue) / (maxValue - minValue) * 360.0 + startAngle
        } else {
            // Calculate the center difference between the end and start angle
            let angleDiff: CGFloat = (startAngle > endAngle) ? (360.0 - startAngle + endAngle) : (endAngle - startAngle) 
            // Calculate how much we should draw depending on the value set
            innerEndAngle = (value - minValue) / (maxValue - minValue) * angleDiff + startAngle
        }
        
        // The radius for style 1 is set below
        // The radius for style 1 is a bit less than the outer, 
        // this way it looks like its inside the circle
        
        var radiusIn: CGFloat = 0.0
        
        switch ringStyle {
            
        case .inside:
            let difference = outerRingWidth*2 - innerRingSpacing
            radiusIn = (min(bounds.width - difference,
                            bounds.height - difference)/2) - innerRingWidth/2
        default:
            radiusIn = (min(bounds.width, bounds.height)/2) - (max(outerRingWidth, innerRingWidth)/2)
        }
        
        // Start drawing
        let innerPath: UIBezierPath = UIBezierPath(arcCenter: center,
                                                   radius: radiusIn,
                                                   startAngle: startAngle.toRads,
                                                   endAngle: innerEndAngle.toRads,
                                                   clockwise: true)
        
        // Draw path
        ctx.setLineWidth(innerRingWidth)
        ctx.setLineJoin(.round)
        ctx.setLineCap(innerCapStyle)
        ctx.setStrokeColor(innerRingColor.cgColor)
        ctx.addPath(innerPath.cgPath)
        ctx.drawPath(using: .stroke)
        
        if ringStyle == .gradient && gradientColors.count > 1 {
            // Create gradient and draw it
            var cgColors: [CGColor] = [CGColor]()
            for color: UIColor in gradientColors {
                cgColors.append(color.cgColor)
            }
            
            guard let gradient: CGGradient = CGGradient(colorsSpace: nil,
                                                        colors: cgColors as CFArray,
                                                        locations: gradientColorLocations)
            else {
                fatalError("\nUnable to create gradient for progress ring.\n" +
                    "Check values of gradientColors and gradientLocations.\n")
            }
            
            ctx.saveGState()
            ctx.addPath(innerPath.cgPath)
            ctx.replacePathWithStrokedPath()
            ctx.clip()
            
            drawGradient(gradient, start: gradientStartPosition,
                         end: gradientEndPosition, inContext: ctx)
            
            ctx.restoreGState()
        }
    }
    
    /**
     Draws a gradient with a start and end position inside the provided context
     */
    private func drawGradient(_ gradient: CGGradient,
                              start: UICircularProgressRingGradientPosition,
                              end: UICircularProgressRingGradientPosition,
                              inContext ctx: CGContext) {
        
        ctx.drawLinearGradient(gradient,
                               start: start.pointForPosition(in: bounds),
                               end: end.pointForPosition(in: bounds),
                               options: .drawsBeforeStartLocation)
    }
    
    /**
     Draws the value label for the view.
     Only drawn if shouldShowValueText = true
     */
    private func drawValueLabel() {
        guard shouldShowValueText else { return }
        
        // Draws the text field
        // Some basic label properties are set
        valueLabel.font = self.font
        valueLabel.textAlignment = .center
        valueLabel.textColor = fontColor

        valueLabel.update(withValue: value,
                          valueIndicator: valueIndicator,
                          showsDecimal: showFloatingPoint,
                          decimalPlaces: decimalPlaces,
                          valueDelegate: valueDelegate)
        
        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        valueLabel.drawText(in: self.bounds)
    }
}
