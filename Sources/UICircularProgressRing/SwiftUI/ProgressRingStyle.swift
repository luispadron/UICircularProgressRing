//
//  ProgressRingStyle.swift
//  
//
//  Created by Luis on 7/9/19.
//

import SwiftUI

public enum ProgressRingStyle {
    /// inner ring is placed ontop of the outer ring
    case ontop

    /// inner ring is inside the circle with given amount of padding between inner and outer rings
    case inside(padding: Length)
}

extension ProgressRingStyle {
    func outerRingOffset(widths: (outer: Length, inner: Length)) -> Length {
        switch self {
        case .ontop, .inside:
            return max(widths.outer, widths.inner) / 2
        }
    }

    func innerRingOffset(widths: (outer: Length, inner: Length)) -> Length {
        switch self {
        case .ontop:
            return max(widths.outer, widths.inner) / 2

        case .inside(let padding):
            return widths.inner * 2 + padding
        }
    }
}
