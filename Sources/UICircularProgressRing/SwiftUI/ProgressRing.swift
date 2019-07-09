//
//  ProgressRing.swift
//  
//
//  Created by Luis on 7/9/19.
//

import SwiftUI

public struct ProgressRing: View {
    var ringWidths: (outer: Length, inner: Length) = (outer: 10, inner: 8)
    var ringColors: (outer: Color, inner: Color) = (outer: Color.red, inner: Color.white)
    
    public init() { }
    
    public var body: some View {
        ZStack {
            OuterRing()
                .ringOffset(outerRingOffset)
                .width(ringWidths.outer)
                .fill(ringColors.outer)
            
            InnerRing()
                .ringOffset(innerRingOffset)
                .width(ringWidths.inner)
                .value(75)
                .fill(ringColors.inner)
        }
    }
}

// MARK: Modifiers

public extension ProgressRing {
    /// returns a modified copy of `ProgressRing` by modifying `ringWidths`
    func ringWidths(outer: Length, inner: Length) -> Self {
        return modifying(\.ringWidths, value: (outer: outer, inner: inner))
    }
    
    /// returns a modified copy of `ProgressRing` by modifying `ringColors`
    func ringColors(outer: Color, inner: Color) -> Self {
        return modifying(\.ringColors, value: (outer: outer, inner: inner))
    }
}

// MARK: Private Helpers

private extension ProgressRing {
    var outerRingOffset: Length {
        return max(ringWidths.outer, ringWidths.inner) / 2
    }
    
    var innerRingOffset: Length {
        return max(ringWidths.outer, ringWidths.inner) / 2
    }
}
