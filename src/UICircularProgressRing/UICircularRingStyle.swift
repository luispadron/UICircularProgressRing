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
public enum UICircularRingStyle {
    /// inner ring is inside the circle
    case inside

    /// inner ring is placed ontop of the outer ring
    case ontop

    /// outer ring is dashed, the pattern list is how the dashes should appear
    case dashed(pattern: [CGFloat])

    /// outer ring is dotted
    case dotted

    /// inner ring is placed ontop of the outer ring and outer ring has border
    case bordered(width: CGFloat, color: UIColor)
}

/**

 # UICircularRingValueKnobPath

 Used to create a custom "knob" for the progress ring.
 Simply create a path that fits within the given `CGRect`.

 Default = `.oval`

 ## Author
 Tom Knapen

 */
public struct UICircularRingValueKnobPath {
    let from: (CGRect) -> UIBezierPath

    public init(_ from: @escaping (CGRect) -> UIBezierPath) {
        self.from = from
    }

    public static let oval: UICircularRingValueKnobPath = .init { UIBezierPath(ovalIn: $0) }
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

    /// the size of the knob
    public let size: CGFloat

    /// the color of the knob
    public let color: UIColor

    /// the path of the knob
    public let path: UICircularRingValueKnobPath

    /// the amount of blur to give the shadow
    public let shadowBlur: CGFloat

    /// the offset to give the shadow
    public let shadowOffset: CGSize

    /// the color for the shadow
    public let shadowColor: UIColor

    // the image of the knob
    public let image: UIImage?

    // the tint color of the knob image
    public let imageTintColor: UIColor?

    // the inset of the thumb image
    public let imageInsets: UIEdgeInsets

    /// creates a new `UICircularRingValueKnobStyle`
    public init(size: CGFloat,
                color: UIColor,
                path: UICircularRingValueKnobPath = .oval,
                shadowBlur: CGFloat = 2.0,
                shadowOffset: CGSize = .zero,
                shadowColor: UIColor = UIColor.black.withAlphaComponent(0.8),
                image: UIImage? = nil,
                imageTintColor: UIColor? = nil,
                imageInsets: UIEdgeInsets = .zero) {
        self.size = size
        self.color = color
        self.path = path
        self.shadowBlur = shadowBlur
        self.shadowOffset = shadowOffset
        self.shadowColor = shadowColor
        self.image = image
        self.imageTintColor = imageTintColor
        self.imageInsets = imageInsets
    }
}

// MARK: UICircularRingGradientPosition

/**

 UICircularRingGradientPosition

 This is an enumeration which is used to determine the position for a
 gradient. Used inside the `UICircularRingLayer` to allow customization
 for the gradient.
 */
public enum UICircularRingGradientPosition {
    /// Gradient positioned at the top
    case top
    /// Gradient positioned at the bottom
    case bottom
    /// Gradient positioned to the left
    case left
    /// Gradient positioned to the right
    case right
    /// Gradient positioned in the top left corner
    case topLeft
    /// Gradient positioned in the top right corner
    case topRight
    /// Gradient positioned in the bottom left corner
    case bottomLeft
    /// Gradient positioned in the bottom right corner
    case bottomRight

    /**
     Returns a `CGPoint` in the coordinates space of the passed in `CGRect`
     for the specified position of the gradient.
     */
    func pointForPosition(in rect: CGRect) -> CGPoint {
        switch self {
        case .top:
            return CGPoint(x: rect.midX, y: rect.minY)
        case .bottom:
            return CGPoint(x: rect.midX, y: rect.maxY)
        case .left:
            return CGPoint(x: rect.minX, y: rect.midY)
        case .right:
            return CGPoint(x: rect.maxX, y: rect.midY)
        case .topLeft:
            return CGPoint(x: rect.minX, y: rect.minY)
        case .topRight:
            return CGPoint(x: rect.maxX, y: rect.minY)
        case .bottomLeft:
            return CGPoint(x: rect.minX, y: rect.maxY)
        case .bottomRight:
            return CGPoint(x: rect.maxX, y: rect.maxY)
        }
    }
}

// MARK: UICircularRingGradientOptions

/**
 UICircularRingGradientOptions

 Struct for defining the options for the UICircularRingStyle.gradient case.

 ## Important ##
 Make sure the number of `colors` is equal to the number of `colorLocations`
 */
public struct UICircularRingGradientOptions {

    /// a default styling option for the gradient style
    public static let `default` = UICircularRingGradientOptions(startPosition: .topRight,
                                                            endPosition: .bottomLeft,
                                                            colors: [.red, .blue],
                                                            colorLocations: [0, 1])

    /// the start location for the gradient
    public let startPosition: UICircularRingGradientPosition

    /// the end location for the gradient
    public let endPosition: UICircularRingGradientPosition

    /// the colors to use in the gradient, the count of this list must match the count of `colorLocations`
    public let colors: [UIColor]

    /// the locations of where to place the colors, valid numbers are from 0.0 - 1.0
    public let colorLocations: [CGFloat]

    /// create a new UICircularRingGradientOptions
    public init(startPosition: UICircularRingGradientPosition,
                endPosition: UICircularRingGradientPosition,
                colors: [UIColor],
                colorLocations: [CGFloat]) {
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.colors = colors
        self.colorLocations = colorLocations
    }
}
