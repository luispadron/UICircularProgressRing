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
    
    var maxValue: CGFloat = 100
    var outerRingWidth: CGFloat = 10
    var innerRingWidth: CGFloat = 5
    var startAngle: CGFloat = 0
    var endAngle: CGFloat = 360
    var outerRingColor: UIColor = UIColor.black
    var innerRingColor: UIColor = UIColor.blue
    var outerCapStyle: Int = 1 {
        didSet {
            switch self.outerCapStyle {
            case 1:
                outStyle = .butt
            case 2:
                outStyle = .round
            case 3:
                outStyle = .square
            default:
                outStyle = .butt
            }
        }
    }
    
    var innerCapStyle: Int = 1 {
        didSet {
            switch self.innerCapStyle {
            case 1:
                inStyle = .butt
            case 2:
                inStyle = .round
            case 3:
                inStyle = .square
            default:
                inStyle = .butt
            }
        }
    }
    
    var outStyle: CGLineCap = .butt
    var inStyle: CGLineCap = .round
    var progressRingStyle: Int = 1
    var innerRingSpacing: CGFloat = 0
    var animationDuration: TimeInterval = 1.0
    var animated = false
    
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        
        UIGraphicsPushContext(ctx)
        let size = self.bounds.integral.size
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
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radiusOut = max(bounds.width, bounds.height)/2 - outerRingWidth/2
        
        path.addArc(center: center,
                    radius: radiusOut,
                    startAngle: startAngle.toRads,
                    endAngle: endAngle.toRads,
                    clockwise: true)
        
        let stroked = path.copy(strokingWithWidth: outerRingWidth, lineCap: outStyle, lineJoin: .miter, miterLimit: 10)
        
        context.addPath(stroked)
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
        var radiusIn = (max(bounds.width - outerRingWidth*2 - innerRingSpacing, bounds.height - outerRingWidth*2 - innerRingSpacing)/2) - innerRingWidth/2
        
        if progressRingStyle >= 2 {
            radiusIn = (max(bounds.width, bounds.height)/2) - (outerRingWidth/2)
        }
        
        let innerEndAngle = arcLenPerValue * CGFloat(value) + startAngle.toRads
        
        path.addArc(center: center,
                    radius: radiusIn,
                    startAngle: startAngle.toRads,
                    endAngle: innerEndAngle,
                    clockwise: false)
        
        let stroked = path.copy(strokingWithWidth: innerRingWidth, lineCap: inStyle, lineJoin: .miter, miterLimit: 10)
        
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
        print(event)
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
