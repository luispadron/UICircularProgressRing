//
//  File.swift
//  
//
//  Created by Luis on 7/7/19.
//

import SwiftUI

public struct OuterRing: Shape {
    let style: StrokeStyle
    
    public init(style: StrokeStyle) {
        self.style = style
    }
    
    public func path(in rect: CGRect) -> Path {
        let minSize = min(rect.width, rect.height)
        let center: CGPoint = CGPoint(x: minSize / 2, y: minSize / 2)
        let offSet = style.lineWidth / 2
        let outerRadius: CGFloat = min(rect.width, rect.height) / 2 - offSet
        
        var path = Path()
        path.addArc(center: center,
                    radius: outerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        return path.strokedPath(style)
    }
}
