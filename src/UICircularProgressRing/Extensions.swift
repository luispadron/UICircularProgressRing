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

/// adds simple conversion to CGFloat
internal extension TimeInterval {
    var float: CGFloat { return CGFloat(self) }
}

/// adds simple conversion to TimeInterval
internal extension CGFloat {
    var interval: TimeInterval { return TimeInterval(self) }
}
