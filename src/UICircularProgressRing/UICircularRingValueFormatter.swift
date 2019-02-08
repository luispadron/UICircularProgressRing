//
//  UICircularRingValueFormatter.swift
//  UICircularProgressRing
//
//  Created by Luis on 2/7/19.
//  Copyright © 2019 Luis Padron. All rights reserved.
//

import Foundation

// MARK: UICircularRingValueFormatter

/**
 UICricularRingValueFormatter

 The base class for all the UICircularRing formatters.
 Subclasses should implement `string(forValue:)` as this is used
 to format the value into a string in the base class

 Two concrete implementations are provided, refer to `UICircularTimerRingFormatter`
 and `UICircularProgressRingFormatter`
 */
open class UICircularRingValueFormatter: Formatter {
    /// returns result of `string(forValue:)`
    open override func string(for obj: Any?) -> String? {
        guard let value = obj as? CGFloat else { return nil }
        return string(forValue: value)
    }

    /// always returns false
    open override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                      for string: String,
                                      errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        return false
    }

    /// not implemented
    open func string(forValue value: CGFloat) -> String? {
        fatalError("UICircularRingValueFormatter: string(forValue:) should be implemented when subclassing")
    }
}

// MARK: UICircularTimerRingFormatter

/**
 UICircularTimerRingFormatter

 The formatter used in UICircularTimerRing class, formats
 the ring value into a time string.
 */
final public class UICircularTimerRingFormatter: UICircularRingValueFormatter {
    // MARK: Members

    /// defines the units allowed to be used when converting string, by default `[.minute, .second]`
    public var units: NSCalendar.Unit = [.minute, .second] {
        didSet { formatter.allowedUnits = units }
    }

    /// the style of the formatted string, by default `.short`
    public var style: DateComponentsFormatter.UnitsStyle = .short {
        didSet { formatter.unitsStyle = style }
    }

    /// formatter which formats the time string of the ring label
    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = style
        return formatter
    }()

    // MARK: API

    /// formats the value of the ring using the date components formatter with given units/style
    public override func string(forValue value: CGFloat) -> String? {
        return formatter.string(from: value.interval)
    }
}

// MARK: UICircularProgressRingFormatter

/**
 UICircularProgressRingFormatter

 The formatter used in UICircularProgressRing class,
 responsible for formatting the value of the ring into a readable string
 */
final public class UICircularProgressRingFormatter: UICircularRingValueFormatter {

    // MARK: Members

    /**
     The name of the value indicator the value label will
     appened to the value
     Example: " GB" -> "100 GB"

     ## Important ##
     Default = "%"

     ## Author
     Luis Padron
     */
    public var valueIndicator: String = "%"

    /**
     A toggle for either placing the value indicator right or left to the value
     Example: true -> "GB 100" (instead of 100 GB)

     ## Important ##
     Default = false (place value indicator to the right)

     ## Author
     Elad Hayun
     */
    public var rightToLeft: Bool = false

    /**
     A toggle for showing or hiding floating points from
     the value in the value label

     ## Important ##
     Default = false (dont show)

     To customize number of decmial places to show, assign a value to decimalPlaces.

     ## Author
     Luis Padron
     */
    public var showFloatingPoint: Bool = false

    /**
     The amount of decimal places to show in the value label

     ## Important ##
     Default = 2

     Only used when showFloatingPoint = true

     ## Author
     Luis Padron
     */
    public var decimalPlaces: Int = 2

    /// formats the value of the progress ring using the given properties
    public override func string(forValue value: CGFloat) -> String? {
        if rightToLeft {
            if showFloatingPoint {
                return "\(valueIndicator)" + String(format: "%.\(decimalPlaces)f", value)
            } else {
                return "\(valueIndicator)\(Int(value))"
            }

        } else {
            if showFloatingPoint {
                return String(format: "%.\(decimalPlaces)f", value) + "\(valueIndicator)"
            } else {
                return "\(Int(value))\(valueIndicator)"
            }
        }
    }
}
