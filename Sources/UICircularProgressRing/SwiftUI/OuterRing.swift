//
//  OuterRing.swift
//  
//
//  Created by Luis on 7/7/19.
//

import SwiftUI

struct OuterRing: Ring {    
    var width: Length = RingDefaults.outerRingWidth
    var capStyle: CGLineCap = RingDefaults.ringCapStyle
    var ringOffset: Length = 0
    
    func path(in rect: CGRect) -> Path {
        let minSize = min(rect.width, rect.height)
        let center: CGPoint = CGPoint(x: minSize / 2, y: minSize / 2)
        let outerRadius: CGFloat = min(rect.width, rect.height) / 2 - ringOffset
        
        var path = Path()
        path.addArc(center: center,
                    radius: outerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path.strokedPath(.init(lineWidth: width, lineCap: capStyle))
    }
}
