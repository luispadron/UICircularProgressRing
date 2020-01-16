//
//  RingStyle.swift
//
//  Created by Luis Padron on 6/3/20.
//

import SwiftUI

/// # RingStyle
///
/// A custom specification for the appearance and interaction of a `Ring`.
public struct RingStyle {
    /// The `RingColor` for the ring.
    public let color: RingColor
    /// The `StrokeStyle` for  ring.
    public let strokeStyle: StrokeStyle
    /// The optional padding for the ring
    public let padding: Double

    /// A `RingStyle` which `disables` the ring
    public static let disabled = Self.init(color: .color(.clear), strokeStyle: .init(lineWidth: 0))

    /// Creates a `RingStyle`
    ///
    /// - Parameters:
    ///   - color: The `RingColor` for the ring.
    ///   - strokeStyle: The `StrokeStyle` for the ring.
    ///   - padding: The padding for the ring. Default is `0.0`.
    public init(
        color: RingColor,
        strokeStyle: StrokeStyle,
        padding: Double = 0.0
    ) {
        self.color = color
        self.strokeStyle = strokeStyle
        self.padding = padding
    }
}
