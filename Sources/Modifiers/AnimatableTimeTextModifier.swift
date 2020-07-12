//
//  AnimatableTimeTextModifier.swift
//
//  Created by Luis Padron on 5/28/20.
//

import SwiftUI

struct AnimatableTimeTextModifier<Label: View>: AnimatableModifier {
    var timeInterval: TimeInterval
    var animatableData: TimeInterval {
        get { timeInterval }
        set { timeInterval = newValue }
    }

    let label: (TimeInterval) -> Label

    func body(content: Content) -> some View {
        content.overlay(label(timeInterval))
    }
}
