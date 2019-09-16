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

    var style: ProgressRingStyle = .ontop

    var labelStyle: RingLabelStyle = .init()

    var ringWidths: (outer: CGFloat, inner: CGFloat) = (outer: 10, inner: 8)

    var ringColors: (outer: Color, inner: Color) = (outer: .red, inner: .blue)

    @Binding var progress: Double

    // MARK: Init

    public init(progress: Binding<Double>) {
        self._progress = progress
    }

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
                .value(progress)
                .fill(ringColors.inner)

            // TODO: Remove this overlay nonesense when Apple fixes the modifier not allowed in a container bug
            Color.clear
                .overlay(
                    RingLabel(value: progress,
                              formatter: UICircularProgressRingFormatter(),
                              style: labelStyle)
                )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: Modifiers

@available(OSX 10.15, iOS 13.0, *)
public extension ProgressRing {

    /// returns a modified copy of `ProgressRing` by modifying `ringWidths`
    func ringWidths(outer: CGFloat = 10, inner: CGFloat = 8) -> Self {
        return modifying(\.ringWidths, value: (outer: outer, inner: inner))
    }

    /// returns a modified copy of `ProgressRing` by modifying `ringColors`
    func ringColors(outer: Color = .red, inner: Color = .blue) -> Self {
        return modifying(\.ringColors, value: (outer: outer, inner: inner))
    }

    /// returns a modified copy of `ProgressRing` by modifying `style`
    func ringStyle(_ style: ProgressRingStyle = .ontop) -> Self {
        return modifying(\.style, value: style)
    }

    /// returns a modified copy of `ProgressRing` by modifying `labelStyle`
    func labelStyle(_ style: RingLabelStyle = .init()) -> Self {
        return modifying(\.labelStyle, value: style)
    }
}

// MARK: Preview

#if DEBUG
@available(OSX 10.15, iOS 13.0, *)
struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing(progress: .constant(55))
    }
}
#endif
