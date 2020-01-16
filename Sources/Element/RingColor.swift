//
//  RingColor.swift
//
//  Created by Luis Padron on 6/2/20.
//

import SwiftUI

/// The types representing a color for a ring.
public enum RingColor {
    /// A solid color.
    case color(Color)

    /// A gradient.
    case gradient(AngularGradient)
}
