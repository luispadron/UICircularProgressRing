//
//  ProgressRing.swift
//
//  Created by Luis Padron on 5/28/20.
//

import Combine
import SwiftUI

/// # ProgressRing
///
public struct ProgressRing<Label, IndeterminateView> where Label: View, IndeterminateView: View {
    @Binding private var progress: RingProgress

    /// A `RingAxis` which determines the starting axis for which to draw.
    let axis: RingAxis
    /// Whether the ring is drawn in a clock wise manner or not.
    let clockwise: Bool
    /// The `ProgressRingStyle` used to customize the outer ring.
    let outerRingStyle: RingStyle
    /// The `ProgressRingStyle` used to customize the inner ring.
    let innerRingStyle: RingStyle

    private let indeterminateView: (Double) -> IndeterminateView
    private let label: (Double) -> Label

    /// Creates a `ProgressRing`.
    ///
    /// - Parameters:
    ///   - progress: A `Binding` to some `RingProgress` which determines the state of the progress ring.
    ///   - axis: A `RingAxis` which determines the starting axis for which to draw.
    ///   - clockwise: Whether the ring is drawn in a clock wise manner or not.
    ///   - outerRingStyle: The `ProgressRingStyle` used to customize the outer ring.
    ///   - innerRingStyle: The `ProgressRingStyle` used to customize the inner ring.
    ///   - label: A closure which constructs the `Label` for the progress ring.
    ///   - indeterminateView: A closure which constructs a view that is used when progress `isIndeterminate`.
    public init (
        progress: Binding<RingProgress>,
        axis: RingAxis = .top,
        clockwise: Bool = true,
        outerRingStyle: RingStyle = .init(color: .color(.gray), strokeStyle: .init(lineWidth: 32), padding: 0),
        innerRingStyle: RingStyle = .init(color: .color(.blue), strokeStyle: .init(lineWidth: 16), padding: 8),
        @ViewBuilder _ label: @escaping (Double) -> Label,
        @ViewBuilder _ indeterminateView: @escaping (Double) -> IndeterminateView
    ) {
        self._progress = progress
        self.axis = axis
        self.clockwise = clockwise
        self.outerRingStyle = outerRingStyle
        self.innerRingStyle = innerRingStyle
        self.indeterminateView = indeterminateView
        self.label = label
    }
}

// MARK: - Default Init

public extension ProgressRing where IndeterminateView == IndeterminateRing {

    /// Creates a `ProgressRing`.
    /// Uses a default `IndeterminateView`.
    ///
    /// - Parameters:
    ///   - progress: A `Binding` to some `RingProgress` which determines the state of the progress ring.
    ///   - axis: A `RingAxis` which determines the starting axis for which to draw.
    ///   - clockwise: Whether the ring is drawn in a clock wise manner or not.
    ///   - outerRingStyle: The `ProgressRingStyle` used to customize the outer ring.
    ///   - innerRingStyle: The `ProgressRingStyle` used to customize the inner ring.
    ///   - label: A closure which constructs the `Label` for the progress ring.
    init(
        progress: Binding<RingProgress>,
        axis: RingAxis = .top,
        clockwise: Bool = true,
        outerRingStyle: RingStyle = .init(color: .color(.gray), strokeStyle: .init(lineWidth: 32), padding: 0),
        innerRingStyle: RingStyle = .init(color: .color(.blue), strokeStyle: .init(lineWidth: 16), padding: 8),
        @ViewBuilder _ label: @escaping (Double) -> Label
    ) {
        self.init(
            progress: progress,
            axis: axis,
            clockwise: clockwise,
            outerRingStyle: outerRingStyle,
            innerRingStyle: innerRingStyle,
            label, { IndeterminateRing(percent: $0) }
        )
    }
}

public extension ProgressRing where Label == PercentFormattedText, IndeterminateView == IndeterminateRing {

    /// Creates a `ProgressRing`.
    /// Uses a default `Label` and `IndeterminateView`.
    ///
    /// - Parameters:
    ///   - progress: A `Binding` to some `RingProgress` which determines the state of the progress ring.
    ///   - axis: A `RingAxis` which determines the starting axis for which to draw.
    ///   - clockwise: Whether the ring is drawn in a clock wise manner or not.
    ///   - outerRingStyle: The `ProgressRingStyle` used to customize the outer ring.
    ///   - innerRingStyle: The `ProgressRingStyle` used to customize the inner ring.
    init(
        progress: Binding<RingProgress>,
        axis: RingAxis = .top,
        clockwise: Bool = true,
        outerRingStyle: RingStyle = .init(color: .color(.gray), strokeStyle: .init(lineWidth: 32), padding: 0),
        innerRingStyle: RingStyle = .init(color: .color(.blue), strokeStyle: .init(lineWidth: 16), padding: 8)
    ) {
        self.init(
            progress: progress,
            axis: axis,
            clockwise: clockwise,
            outerRingStyle: outerRingStyle,
            innerRingStyle: innerRingStyle, { PercentFormattedText(percent: $0) }, { IndeterminateRing(percent: $0) }
        )
    }
}

// MARK: - Body

extension ProgressRing: View {

    public var body: some View {
        Group {
            if progress.isIndeterminate {
                indeterminateView(0.5)
            } else {
                ZStack(alignment: .center) {
                    Ring(
                        percent: 1,
                        axis: axis,
                        clockwise: clockwise,
                        color: outerRingStyle.color,
                        strokeStyle: outerRingStyle.strokeStyle
                    )
                    .padding(CGFloat(outerRingStyle.padding))

                    Ring(
                        percent: progress.asDouble ?? 0.0,
                        axis: axis,
                        clockwise: clockwise,
                        color: innerRingStyle.color,
                        strokeStyle: innerRingStyle.strokeStyle
                    )
                    .modifier(
                        AnimatablePercentTextModifier(
                            percent: progress.asDouble ?? 0.0,
                            label: label
                        )
                    )
                    .padding(CGFloat(innerRingStyle.padding))
                }
            }
        }
        .transition(.opacity)
    }
}

// MARK: - Previews

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProgressRing(progress: .constant(.percent(0.5)))
        }
    }
}
