//
//  OuterRing.swift
//  
//
//  Created by Luis on 7/7/19.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, *)
struct OuterRing: Ring {
    var width: CGFloat = RingDefaults.outerRingWidth
    var capStyle: CGLineCap = RingDefaults.ringCapStyle
    var ringOffset: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let outerRadius = min(rect.width, rect.height) / 2 - ringOffset

        var path = Path()
        path.addArc(center: .init(x: rect.midX, y: rect.midY),
                    radius: outerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)

        return path.strokedPath(.init(lineWidth: width, lineCap: capStyle))
    }
}
