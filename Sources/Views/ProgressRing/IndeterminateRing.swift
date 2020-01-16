//
//  IndeterminateRing.swift
//
//  Created by Luis Padron on 5/28/20.
//

import SwiftUI

/// An `IndeterminateRing` is a `View` which displays
/// an animated ring to represent some long running task.
public struct IndeterminateRing {
    /// Whether or not the ring is currently animating.
    @State public private(set) var isAnimating: Bool = false

    /// The percent of the draw ring.
    let percent: Double
    /// The animation for the ring.
    let animation: Animation

    ///
    /// - Parameters:
    ///   - percent: The percentage to draw. Default = `0.0`.
    ///   - animation: The animation to perform, usually some repeating animation.
    public init(
        percent: Double = 0.0,
        animation: Animation = Animation.easeInOut.repeatForever(autoreverses: false)
    ) {
        self.percent = percent
        self.animation = animation
    }
}

extension IndeterminateRing: View {
    public var body: some View {
        ZStack {
            Ring(
                percent: percent,
                axis: .top,
                clockwise: true,
                color: .color(.blue),
                strokeStyle: .init(lineWidth: 20)
            )
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(animation)
        }
        .onAppear {
            withAnimation {
                self.isAnimating = true
            }
        }
    }
}

// MARK: - Previews

struct IndeterminateRing_Previews: PreviewProvider {
    static var previews: some View {
        IndeterminateRing(percent: 0.76)
            .padding()
    }
}

// MARK: - Extensions

private extension Int {
    var axis: RingAxis {
        switch self {
        case 0:
            return .top
        case 1:
            return .trailing
        case 2:
            return .bottom
        case 3:
            return .leading
        default:
            return .top
        }
    }
}
