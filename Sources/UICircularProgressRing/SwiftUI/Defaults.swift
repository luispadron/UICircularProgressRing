//
//  Defaults.swift
//  
//
//  Created by Luis on 7/9/19.
//

/**
 This file defines library wide defaults for values
 */

import Foundation
import SwiftUI

/// Defines library wide defaults for values relating to `InnerRing`, `OuterRing` and `ProgressRing`
public enum RingDefaults {
    public static let outerRingWidth: Length = 10
    public static let innerRingWidth: Length = 8

    public static let innerRingMinValue: Double = 0
    public static let innerRingMaxValue: Double = 100

    public static let ringCapStyle: CGLineCap = .round

    public static let outerRingColor: Color = .red
    public static let innerRingColor: Color = .blue

    public static let ringStyle: ProgressRingStyle = .ontop
}
