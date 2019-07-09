//
//  ProgressRing.swift
//  
//
//  Created by Luis on 7/9/19.
//

import SwiftUI

public struct ProgressRing: View {
    // MARK: Properties
    
    var style: ProgressRingStyle = RingDefaults.ringStyle
    
    var ringWidths: (outer: Length, inner: Length) = (outer: RingDefaults.outerRingWidth,
                                                      inner: RingDefaults.innerRingWidth)
    
    var ringColors: (outer: Color, inner: Color) = (outer: RingDefaults.outerRingColor,
                                                    inner: RingDefaults.innerRingColor)
    
    var value: Double = 75
    
    // MARK: Init
    
    public init() { }
    
    // MARK: View Body
    
    public var body: some View {
        ZStack {
            OuterRing()
                .ringOffset(style.outerRingOffset(widths: ringWidths))
                .width(ringWidths.outer)
                .fill(ringColors.outer)
            
            InnerRing()
                .ringOffset(style.innerRingOffset(widths: ringWidths))
                .width(ringWidths.inner)
                .value(value)
                .fill(ringColors.inner)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: Modifiers

public extension ProgressRing {
    /// returns a modified copy of `ProgressRing` by modifying `value` of `InnerRing`
    func value(_ value: Double) -> Self {
        return modifying(\.value, value: value)
    }
    
    /// returns a modified copy of `ProgressRing` by modifying `ringWidths`
    func ringWidths(outer: Length = RingDefaults.outerRingWidth,
                    inner: Length = RingDefaults.innerRingWidth) -> Self {
        return modifying(\.ringWidths, value: (outer: outer, inner: inner))
    }
    
    /// returns a modified copy of `ProgressRing` by modifying `ringColors`
    func ringColors(outer: Color = RingDefaults.outerRingColor,
                    inner: Color = RingDefaults.innerRingColor) -> Self {
        return modifying(\.ringColors, value: (outer: outer, inner: inner))
    }
    
    /// returns a modified copy of `ProgressRing` by modifying `style`
    func ringStyle(_ style: ProgressRingStyle = RingDefaults.ringStyle) -> Self {
        return modifying(\.style, value: style)
    }
}
