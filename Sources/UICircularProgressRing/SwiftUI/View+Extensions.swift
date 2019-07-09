//
//  View+Extensions.swift
//  
//
//  Created by Luis on 7/9/19.
//

import Foundation
import SwiftUI

extension View {
    /// modifies the `View` by creating a copy and editing the given `keypath` with given `value`
    func modifying<T>(_ keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}
