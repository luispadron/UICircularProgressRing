import UIKit

/**
 A private extension to CGFloat in order to provide simple
 conversion from degrees to radians, used when drawing the rings.
 */
private extension CGFloat {
    var toRads: CGFloat { return self * CGFloat(M_PI) / 180 }
}

class UICircularProgressRingLayer: CALayer {
    
    @NSManaged var value: CGFloat
    @NSManaged var maxValue: CGFloat
    
    @NSManaged var progressRingStyle: Int
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
    
    var animationDuration: TimeInterval = 1.0
    var animated = false
    
    private var outerRadius: CGFloat?
    
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        UIGraphicsPushContext(ctx)
        let size = bounds.integral.size
        drawOuterRing(withSize: size, context: ctx)
        drawInnerRing(withSize: size, context: ctx)
        UIGraphicsPopContext()
    }
    
    private func drawOuterRing(withSize size: CGSize, context: CGContext) {
        guard outerRingWidth > 0 else {
            print("Not drawing outer ring since Inner Ring Width <= 0")
            return
        }
        
        let path = CGMutablePath()
        let width = bounds.width - 1
        let height = bounds.width - 1
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        outerRadius = max(width - 1, height - 1)/2 - outerRingWidth/2 - 1
        
        path.addArc(center: center,
                    radius: outerRadius!,
                    startAngle: startAngle.toRads,
                    endAngle: endAngle.toRads,
                    clockwise: true)
        
        
        let stroked = path.copy(strokingWithWidth: outerRingWidth, lineCap: outerCapStyle, lineJoin: .miter, miterLimit: 10)
        let dotted = path.copy(strokingWithWidth: outerRingWidth, lineCap: .round, lineJoin: .miter, miterLimit: 10)
        
        if progressRingStyle < 3 {
            context.addPath(stroked)
        } else if progressRingStyle == 3 {
            context.addPath(stroked.copy(dashingWithPhase: 0.0, lengths: patternForDashes))
        }
        else {
            context.addPath(dotted)
        }
        
        context.setStrokeColor(outerRingColor.cgColor)
        context.setFillColor(outerRingColor.cgColor)
        context.drawPath(using: .fillStroke)
    }
    
    private func drawInnerRing(withSize size: CGSize, context: CGContext) {
        guard innerRingWidth > 0 else {
            print("Not drawing inner ring since Inner Ring Width <= 0")
            return
        }
        
        let path = CGMutablePath()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let angleDiff: CGFloat = endAngle.toRads - startAngle.toRads
        let arcLenPerValue = angleDiff / CGFloat(maxValue)
        let width = bounds.width - 1
        let height = bounds.height - 1
        
        var radiusIn = outerRadius! - (innerRingWidth*2 - 2 + innerRingSpacing)
        
        if progressRingStyle >= 2 {
            radiusIn = (max(width, height)/2) - (outerRingWidth/2)
        }
        
        let innerEndAngle = arcLenPerValue * CGFloat(value) + startAngle.toRads
        
        path.addArc(center: center,
                    radius: radiusIn,
                    startAngle: startAngle.toRads,
                    endAngle: innerEndAngle,
                    clockwise: false)
        
        let stroked = path.copy(strokingWithWidth: innerRingWidth, lineCap: innerCapStyle, lineJoin: .miter, miterLimit: 10)
        
        context.addPath(stroked)
        context.setStrokeColor(innerRingColor.cgColor)
        context.setFillColor(innerRingColor.cgColor)
        context.drawPath(using: .fillStroke)
    }
    
    
    override class func needsDisplay(forKey key: String) -> Bool {
        
        if key == "value" {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        if event == "value" && self.animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = self.presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.duration = animationDuration
            return animation
        }
        
        return super.action(forKey: event)
    }
    
    
}
