//
//  Ring.swift
//  
//
//  Created by Luis on 7/9/19.
//

import SwiftUI

/**
 # Ring

 Defines what it means to be a `Ring`.
 */
@available(OSX 10.15, iOS 13.0, *)
protocol Ring: Shape {
    var width: CGFloat { get set }
    var capStyle: CGLineCap { get set }
    var ringOffset: CGFloat { get set }
}

// MARK: Modifiers

@available(OSX 10.15, iOS 13.0, *)
extension Ring {
    /// returns a new `Ring` with modified `width`
    func width(_ width: CGFloat) -> Self {
        return modifying(\.width, value: width)
    }

    /// returns a new `Ring` with modified `capStyle`
    func capStyle(_ capStyle: CGLineCap) -> Self {
        return modifying(\.capStyle, value: capStyle)
    }

    /// returns a new `Ring` with modified `ringOffset`
    func ringOffset(_ ringOffset: CGFloat) -> Self {
        return modifying(\.ringOffset, value: ringOffset)
    }
}
