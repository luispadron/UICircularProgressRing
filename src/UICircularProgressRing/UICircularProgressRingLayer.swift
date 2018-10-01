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
    // swiftlint:disable function_parameter_count next_line
    func update(withValue value: CGFloat, valueIndicator: String, rightToLeft: Bool,
                showsDecimal: Bool, decimalPlaces: Int, valueDelegate: UICircularProgressRing?) {
        if rightToLeft {
            if showsDecimal {
                text = "\(valueIndicator)" + String(format: "%.\(decimalPlaces)f", value)
            } else {
                text = "\(valueIndicator)\(Int(value))"
            }

        } else {
            if showsDecimal {
                text = String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
            } else {
                text = "\(Int(value))\(valueIndicator)"
            }
        }
        valueDelegate?.willDisplayLabel(label: self)
        sizeToFit()
    }
}

/**
 The internal subclass for CAShapeLayer.
 This is the class that handles all the drawing and animation.
 This class is not interacted with, instead
 properties are set in UICircularProgressRing and those are delegated to here.
 
 */
class UICircularProgressRingLayer: CAShapeLayer {

    // MARK: Properties

    /**
     The NSManaged properties for the layer.
     These properties are initialized in UICircularProgressRing.
     They're also assigned by mutating UICircularProgressRing properties.
     */
    @NSManaged var fullCircle: Bool

    @NSManaged var value: CGFloat
    @NSManaged var minValue: CGFloat
    @NSManaged var maxValue: CGFloat

    @NSManaged var ringStyle: UICircularProgressRingStyle
    @NSManaged var showsValueKnob: Bool
    @NSManaged var valueKnobSize: CGFloat
    @NSManaged var valueKnobColor: UIColor
    @NSManaged var valueKnobShadowBlur: CGFloat
    @NSManaged var valueKnobShadowOffset: CGSize
    @NSManaged var valueKnobShadowColor: UIColor
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
    @NSManaged var outerBorderColor: UIColor
    @NSManaged var outerBorderWidth: CGFloat

    @NSManaged var innerRingWidth: CGFloat
    @NSManaged var innerRingColor: UIColor
    @NSManaged var innerCapStyle: CGLineCap
    @NSManaged var innerRingSpacing: CGFloat

    @NSManaged var shouldShowValueText: Bool
    @NSManaged var fontColor: UIColor
    @NSManaged var font: UIFont
    @NSManaged var valueIndicator: String
    @NSManaged var rightToLeft: Bool
    @NSManaged var showFloatingPoint: Bool
    @NSManaged var decimalPlaces: Int
    @NSManaged var isClockwise: Bool

    var animationDuration: TimeInterval = 1.0
    var animationTimingFunction: CAMediaTimingFunctionName = .easeInEaseOut
    var animated = false
    @NSManaged weak var valueDelegate: UICircularProgressRing?

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
        if let updatedValue = value(forKey: "value") as? CGFloat {
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
        if event == "value" && animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
            animation.duration = animationDuration
            return animation
        } else if UICircularProgressRingLayer.isAnimatableProperty(event) && shouldAnimateProperties {
            let animation = CABasicAnimation(keyPath: event)
            animation.fromValue = presentation()?.value(forKey: event)
            animation.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
            animation.duration = propertyAnimationDuration
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
        let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let offSet = max(outerRingWidth, innerRingWidth) / 2 + (showsValueKnob ? valueKnobSize / 4 : 0) + (outerBorderWidth*2)
        let outerRadius: CGFloat = min(bounds.width, bounds.height) / 2 - offSet
        let start: CGFloat = fullCircle ? 0 : startAngle.toRads
        let end: CGFloat = fullCircle ? .pi * 2 : endAngle.toRads
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: outerRadius,
                                     startAngle: start,
                                     endAngle: end,
                                     clockwise: true)
        outerPath.lineWidth = outerRingWidth
        outerPath.lineCapStyle = outerCapStyle
        // Update path depending on style of the ring
        updateOuterRingPath(outerPath, radius: outerRadius, style: ringStyle)

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

        let innerEndAngle = calculateInnerEndAngle()
        let radiusIn = calculateInnerRadius()

        // Start drawing
        let innerPath: UIBezierPath = UIBezierPath(arcCenter: center,
                                                   radius: radiusIn,
                                                   startAngle: startAngle.toRads,
                                                   endAngle: innerEndAngle.toRads,
                                                   clockwise: isClockwise)

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
                         end: gradientEndPosition, in: ctx)

            ctx.restoreGState()
        }

        if showsValueKnob && value > minValue {
            let knobOffset = valueKnobSize / 2
            drawValueKnob(in: ctx, origin: CGPoint(x: innerPath.currentPoint.x - knobOffset,
                                                   y: innerPath.currentPoint.y - knobOffset))
        }
    }

    /// Updates the outer ring path depending on the ring's style
    private func updateOuterRingPath(_ path: UIBezierPath, radius: CGFloat, style: UICircularProgressRingStyle) {
        switch style {
        case .dashed:
            path.setLineDash(patternForDashes, count: patternForDashes.count, phase: 0.0)

        case .dotted:
            path.setLineDash([0, path.lineWidth * 2], count: 2, phase: 0)
            path.lineCapStyle = .round

        case .bordered:
            let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
            let offSet = max(outerRingWidth, innerRingWidth) / 2 + (showsValueKnob ? valueKnobSize / 4 : 0) + (outerBorderWidth*2)
            let outerRadius: CGFloat = min(bounds.width, bounds.height) / 2 - offSet
            let borderStartAngle = outerCapStyle == .butt ? startAngle-outerBorderWidth : startAngle
            let borderEndAngle = outerCapStyle == .butt ? endAngle+outerBorderWidth : endAngle
            let start: CGFloat = fullCircle ? 0 : borderStartAngle.toRads
            let end: CGFloat = fullCircle ? .pi * 2 : borderEndAngle.toRads
            let borderPath = UIBezierPath(arcCenter: center,
                                          radius: outerRadius,
                                          startAngle: start,
                                          endAngle: end,
                                          clockwise: true)
            UIColor.clear.setFill()
            borderPath.fill()
            borderPath.lineWidth = (outerBorderWidth*2) + outerRingWidth
            borderPath.lineCapStyle = outerCapStyle
            outerBorderColor.setStroke()
            borderPath.stroke()
        default:
            break
        }
    }

    /// Returns the end angle of the inner ring
    private func calculateInnerEndAngle() -> CGFloat {
        let innerEndAngle: CGFloat

        if fullCircle {
            if !isClockwise {
                innerEndAngle = startAngle - ((value - minValue) / (maxValue - minValue) * 360.0)
            } else {
                innerEndAngle = (value - minValue) / (maxValue - minValue) * 360.0 + startAngle
            }
        } else {
            // Calculate the center difference between the end and start angle
            let angleDiff: CGFloat = (startAngle > endAngle) ? (360.0 - startAngle + endAngle) : (endAngle - startAngle)
            // Calculate how much we should draw depending on the value set
            if !isClockwise {
                innerEndAngle = startAngle - ((value - minValue) / (maxValue - minValue) * angleDiff)
            } else {
                innerEndAngle = (value - minValue) / (maxValue - minValue) * angleDiff + startAngle
            }
        }

        return innerEndAngle
    }

    /// Returns the raidus of the inner ring
    private func calculateInnerRadius() -> CGFloat {
        // The radius for style 1 is set below
        // The radius for style 1 is a bit less than the outer,
        // this way it looks like its inside the circle
        let radiusIn: CGFloat

        switch ringStyle {
        case .inside:
            let difference = outerRingWidth * 2 + innerRingSpacing + (showsValueKnob ? valueKnobSize / 2 : 0)
            let offSet = innerRingWidth / 2 + (showsValueKnob ? valueKnobSize / 2 : 0)
            radiusIn = (min(bounds.width - difference, bounds.height - difference) / 2) - offSet
        case .bordered:
            let offSet = (max(outerRingWidth, innerRingWidth) / 2) + (showsValueKnob ? valueKnobSize / 4 : 0) + (outerBorderWidth*2)
            radiusIn = (min(bounds.width, bounds.height) / 2) - offSet
        default:
            let offSet = (max(outerRingWidth, innerRingWidth) / 2) + (showsValueKnob ? valueKnobSize / 4 : 0)
            radiusIn = (min(bounds.width, bounds.height) / 2) - offSet
        }

        return radiusIn
    }

    /**
     Draws a gradient with a start and end position inside the provided context
     */
    private func drawGradient(_ gradient: CGGradient,
                              start: UICircularProgressRingGradientPosition,
                              end: UICircularProgressRingGradientPosition,
                              in context: CGContext) {

        context.drawLinearGradient(gradient,
                                   start: start.pointForPosition(in: bounds),
                                   end: end.pointForPosition(in: bounds),
                                   options: .drawsBeforeStartLocation)
    }

    /**
     Draws the value knob inside the provided context
     */
    private func drawValueKnob(in context: CGContext, origin: CGPoint) {
        context.saveGState()

        let rect = CGRect(origin: origin, size: CGSize(width: valueKnobSize, height: valueKnobSize))
        let knobPath = UIBezierPath(ovalIn: rect)

        context.setShadow(offset: valueKnobShadowOffset, blur: valueKnobShadowBlur, color: valueKnobShadowColor.cgColor)
        context.addPath(knobPath.cgPath)
        context.setFillColor(valueKnobColor.cgColor)
        context.setLineCap(.round)
        context.setLineWidth(12)
        context.drawPath(using: .fill)

        context.restoreGState()
    }

    /**
     Draws the value label for the view.
     Only drawn if shouldShowValueText = true
     */
    private func drawValueLabel() {
        guard shouldShowValueText else { return }

        // Draws the text field
        // Some basic label properties are set
        valueLabel.font = font
        valueLabel.textAlignment = .center
        valueLabel.textColor = fontColor

        valueLabel.update(withValue: value,
                          valueIndicator: valueIndicator,
                          rightToLeft: rightToLeft,
                          showsDecimal: showFloatingPoint,
                          decimalPlaces: decimalPlaces,
                          valueDelegate: valueDelegate)

        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)

        valueLabel.drawText(in: bounds)
    }
}
