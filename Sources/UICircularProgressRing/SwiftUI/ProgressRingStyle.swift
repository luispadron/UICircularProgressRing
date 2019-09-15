//
//  ProgressRingStyle.swift
//  
//
//  Created by Luis on 7/9/19.
//

import SwiftUI

@available(OSX 10.15, iOS 13.0, *)
public enum ProgressRingStyle {
    /// inner ring is placed ontop of the outer ring
    case ontop

    /// inner ring is inside the circle with given amount of padding between inner and outer rings
    case inside(padding: CGFloat)
}

@available(OSX 10.15, iOS 13.0, *)
extension ProgressRingStyle {

    /// returns the calculated offset for the outer ring
    func outerRingOffset(widths: (outer: CGFloat, inner: CGFloat)) -> CGFloat {
        switch self {
        case .ontop, .inside:
            return max(widths.outer, widths.inner) / 2
        }
    }

    /// returns the calculated offset for the inner ring
    func innerRingOffset(widths: (outer: CGFloat, inner: CGFloat)) -> CGFloat {
        switch self {
        case .ontop:
            return max(widths.outer, widths.inner) / 2

        case .inside(let padding):
            return widths.inner * 2 + padding
        }
    }
}
