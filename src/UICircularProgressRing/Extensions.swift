//
//  Extensions.swift
//  UICircularProgressRing
//
//  Created by Luis on 2/5/19.
//  Copyright © 2019 Luis Padron. All rights reserved.
//

/**
 * This file includes internal extensions.
 */

/// Helper extension to allow removing layer animation based on AnimationKeys enum
internal extension CALayer {
    func removeAnimation(forKey key: UICircularRing.AnimationKeys) {
        removeAnimation(forKey: key.rawValue)
    }

    func animation(forKey key: UICircularRing.AnimationKeys) -> CAAnimation? {
        return animation(forKey: key.rawValue)
    }

    func value(forKey key: UICircularRing.AnimationKeys) -> Any? {
        return value(forKey: key.rawValue)
    }
}

/**
 A private extension to CGFloat in order to provide simple
 conversion from degrees to radians, used when drawing the rings.
 */
internal extension CGFloat {
    var toRads: CGFloat { return self * CGFloat.pi / 180 }
}

/**
 A private extension to UILabel, in order to cut down on code repeation.
 This function will update the value of the progress label, depending on the
 parameters sent.
 At the end sizeToFit() is called in order to ensure text gets drawn correctly
 */
internal extension UILabel {
    // swiftlint:disable function_parameter_count next_line
    func update(withValue value: CGFloat, valueIndicator: String, rightToLeft: Bool,
                showsDecimal: Bool, decimalPlaces: Int, valueDelegate: UICircularRing?) {
        if rightToLeft {
            if showsDecimal {
                text = "\(valueIndicator)" + String(format: "%.\(decimalPlaces)f", value)
            } else {
                text = "\(valueIndicator)\(Int(value))"
            }

        } else {
            if showsDecimal {
                text = String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
            } else {
                text = "\(Int(value))\(valueIndicator)"
            }
        }
        valueDelegate?.willDisplayLabel(label: self)
        sizeToFit()
    }
}

/// adds simple conversion to CGFloat
internal extension TimeInterval {
    var float: CGFloat { return CGFloat(self) }
}

/// adds simple conversion to TimeInterval
internal extension CGFloat {
    var interval: TimeInterval { return TimeInterval(self) }
}
