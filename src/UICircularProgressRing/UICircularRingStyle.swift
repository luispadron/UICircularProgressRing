//
//  UICircularRingStyle.swift
//  UICircularProgressRing
//
//  Copyright (c) 2019 Luis Padron
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished
//  to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
//  OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit.UIColor

// MARK: UICircularRingStyle

/**
 
 # UICircularRingStyle
 
 This is an enumeration which is used to determine the style of the progress ring.
 
 ## Author
 Luis Padron
 
 */
@objc public enum UICircularRingStyle: Int {
    /// Inner ring is inside the circle
    case inside = 1
    /// Inner ring is placed ontop of the outer ring
    case ontop = 2
    /// Outer ring is dashed
    case dashed = 3
    /// Outer ring is dotted
    case dotted = 4
    /// Inner ring is placed ontop of the outer ring and it has a gradient
    case gradient = 5
    /// Inner ring is placed ontop of the outer ring and outer ring has border
    case bordered = 6
}

// MARK: UICircularRingValueKnobStyle

/**

 # UICircularRingValueKnobStyle

 Struct for setting the style of the value knob

 ## Author
 Luis Padron

 */
public struct UICircularRingValueKnobStyle {

    /// default implmementation of the knob style
    public static let `default` = UICircularRingValueKnobStyle(size: 15.0, color: .lightGray)

    public let size: CGFloat
    public let color: UIColor
    public let shadowBlur: CGFloat
    public let shadowOffset: CGSize
    public let shadowColor: UIColor

    public init(size: CGFloat,
                color: UIColor,
                shadowBlur: CGFloat = 2.0,
                shadowOffset: CGSize = .zero,
                shadowColor: UIColor = UIColor.black.withAlphaComponent(0.8)) {
        self.size = size
        self.color = color
        self.shadowBlur = shadowBlur
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
    }
}
