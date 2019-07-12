//
//  Ring.swift
//  
//
//  Created by Luis on 7/9/19.
//

import SwiftUI

protocol Ring: Shape {
    var width: Length { get set }
    var capStyle: CGLineCap { get set }
    var ringOffset: Length { get set }
}

// MARK: Modifiers

extension Ring {
    /// returns a new `Ring` with modified `width`
    func width(_ width: Length) -> Self {
        return modifying(\.width, value: width)
    }
}

extension Ring {
    /// returns a new `Ring` with modified `capStyle`
    func capStyle(_ capStyle: CGLineCap) -> Self {
        return modifying(\.capStyle, value: capStyle)
    }
}

extension Ring {
    /// returns a new `Ring` with modified `ringOffset`
    func ringOffset(_ ringOffset: Length) -> Self {
        return modifying(\.ringOffset, value: ringOffset)
    }
}
