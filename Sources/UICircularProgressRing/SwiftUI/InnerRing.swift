//
//  InnerRing.swift
//  
//
//  Created by Luis on 7/8/19.
//

import SwiftUI

struct InnerRing: Ring {
    var width: Length = 8
    var capStyle: CGLineCap = .round
    var ringOffset: Length = 0
    var value: Double = 0
    var minValue: Double = 0
    var maxValue: Double = 100
    
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
    func values(min: Double, max: Double) -> Self {
        return self
            .modifying(\.minValue, value: min)
            .modifying(\.maxValue, value: max)
    }
    
    // TODO: Remove this, this shouldn't be set as a constant
    func value(_ value: Double) -> Self {
        return self
            .modifying(\.value, value: value)
    }
}
