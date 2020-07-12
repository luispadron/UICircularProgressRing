//
//  TimerRing+TimeUnit.swift
//  UICircularProgressRing
//
//  Created by Luis Padron on 6/5/20.
//

import Foundation

/// # TimerRingTimeUnit
///
/// Represents a unit of time.
public enum TimerRingTimeUnit {
    /// Time represented as minutes.
    case minutes(Double)
    /// Time represented as seconds.
    case seconds(Double)
    /// Time represented as milliseconds.
    case milliseconds(Double)
}

extension TimerRingTimeUnit: Equatable { }

extension TimerRingTimeUnit {

    /// returns `self` as a number of seconds.
    var timeInterval: TimeInterval {
        switch self {
        case .minutes(let minutes):
            return minutes * 60
        case .seconds(let seconds):
            return seconds
        case .milliseconds(let milliseconds):
            return milliseconds / 1000
        }
    }
}
