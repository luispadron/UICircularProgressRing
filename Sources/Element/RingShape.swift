//
//  RingShape.swift
//  CircularProgressRing
//
//  Created by Luis on 3/8/20.
//

import SwiftUI

/// # RingShape
///
/// A shape which represents a ring (a circle with a stroke).
/// The `percent` determines how much of the ring is drawn starting from the `axis`.
///
struct RingShape: Shape {
    /// percent the ring shape is stroked in, valid range: [0, 1]
    var percent: Double

    /// axis in which to start drawing the ring shape
    let axis: RingAxis

    /// how much to inset the shape by
    let insetAmount: CGFloat

    func path(in rect: CGRect) -> Path {
        Circle()
            .inset(by: insetAmount)
            .trim(to: CGFloat(min(percent, 1.0)))
            .rotation(axis.angle)
            .path(in: rect)
    }

    var animatableData: Double {
        get { percent }
        set { percent = newValue }
    }
}
