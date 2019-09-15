//
//  InnerRing.swift
//  
//
//  Created by Luis on 7/8/19.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, *)
struct InnerRing: Ring {
    var width: CGFloat = 8
    var capStyle: CGLineCap = .round
    var ringOffset: CGFloat = 0

    var value: Double = 0
    var minValue: Double = 0
    var maxValue: Double = 100

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2 - ringOffset
        let endAngle = (value - minValue) / (maxValue - minValue) * 360.0

        var path = Path()
        path.addArc(center: .init(x: rect.midX, y: rect.midY),
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

@available(OSX 10.15, iOS 13.0, *)
extension InnerRing {
    /// returns a copy of `InnerRing` after modifying `minValue` and `maxValue`
    func values(min: Double = 0, max: Double = 100) -> Self {
        return self
            .modifying(\.minValue, value: min)
            .modifying(\.maxValue, value: max)
    }

    /// returns a copy of `InnerRing` after modifying `value`
    func value(_ value: Double) -> Self {
        return modifying(\.value, value: value)
    }
}
