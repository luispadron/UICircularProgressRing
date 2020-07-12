//
//  RingAxis.swift
//  CircularProgressRing
//
//  Created by Luis on 3/8/20.
//

import SwiftUI

/// # RingAxis
///
/// Represents the possible axis positions
/// on which we can draw a ring.
public enum RingAxis {
    /// Top of the screen.
    case top
    /// Bottom of the screen.
    case bottom
    /// Leading edge of the screen.
    case leading
    /// Trailing edge of the screen.
    case trailing
}

extension RingAxis {
    /// returns the `Angle` in regards to apples weird flipped coordinate system
    var angle: Angle {
        switch self {
        case .top:
            return Angle(degrees: 270)
        case .bottom:
            return Angle(degrees: 90)
        case .leading:
            return Angle(degrees: 180)
        case .trailing:
            return .zero
        }
    }

    /// returns the axis values for this axis in 3d space
    // swiftlint:disable:next large_tuple
    var as3D: (x: CGFloat, y: CGFloat, z: CGFloat) {
        switch self {
        case .top:
            return (x: 0, y: 1, z: 0)
        case .bottom:
            return (x: 0, y: 1, z: 0)
        case .leading:
            return (x: 1, y: 0, z: 0)
        case .trailing:
            return (x: 1, y: 0, z: 0)
        }
    }
}

extension RingAxis: Equatable { }
extension RingAxis: CaseIterable { }
