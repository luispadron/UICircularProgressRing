//
//  InnerRing.swift
//  
//
//  Created by Luis on 7/8/19.
//

import SwiftUI

struct InnerRing: Ring {
    var width: Length = RingDefaults.innerRingWidth
    var capStyle: CGLineCap = RingDefaults.ringCapStyle
    var ringOffset: Length = 0
    
    var value: Double = 0
    var minValue: Double = RingDefaults.innerRingMinValue
    var maxValue: Double = RingDefaults.innerRingMaxValue
    
    func path(in rect: CGRect) -> Path {
        let minSize = min(rect.width, rect.height)
        let center = CGPoint(x: minSize / 2, y: minSize / 2)
        let radius = min(rect.width, rect.height) / 2 - ringOffset
        let endAngle = (value - minValue) / (maxValue - minValue) * 360.0
        
        var path = Path()
        path.addArc(center: center,
                    radius: radius,
                    startAngle: .zero,
                    endAngle: Angle(degrees: endAngle),
                    clockwise: false)
        
        return path.strokedPath(.init(lineWidth: width, lineCap: capStyle))
    }
    
    var animatableData: Double {
        get { return value }
        set { value = newValue }
    }
}

// MARK: Modifiers

extension InnerRing {
    /// returns a copy of `InnerRing` after modifying `minValue` and `maxValue`
    func values(min: Double = RingDefaults.innerRingMinValue,
                max: Double = RingDefaults.innerRingMaxValue) -> Self {
        return self
            .modifying(\.minValue, value: min)
            .modifying(\.maxValue, value: max)
    }
    
    /// returns a copy of `InnerRing` after modifying `value`
    func value(_ value: Double) -> Self {
        return modifying(\.value, value: value)
    }
}
