//
//  ProgressRing.swift
//  
//
//  Created by Luis on 7/9/19.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, *)
public struct ProgressRing: View {
    // MARK: Properties

    var style: ProgressRingStyle = RingDefaults.ringStyle

    var ringWidths: (outer: CGFloat, inner: CGFloat) = (outer: RingDefaults.outerRingWidth,
                                                      inner: RingDefaults.innerRingWidth)

    var ringColors: (outer: Color, inner: Color) = (outer: RingDefaults.outerRingColor,
                                                    inner: RingDefaults.innerRingColor)

    var value: Double = 0.0

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

@available(OSX 10.15, iOS 13.0, *)
public extension ProgressRing {
    /// returns a modified copy of `ProgressRing` by modifying `value` of `InnerRing`
    func value(_ value: Double) -> Self {
        return modifying(\.value, value: value)
    }

    /// returns a modified copy of `ProgressRing` by modifying `ringWidths`
    func ringWidths(outer: CGFloat = RingDefaults.outerRingWidth,
                    inner: CGFloat = RingDefaults.innerRingWidth) -> Self {
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

// MARK: Preview

#if DEBUG
@available(OSX 10.15, iOS 13.0, *)
struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
    }
}
#endif
