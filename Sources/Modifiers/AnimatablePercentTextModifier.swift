//
//  AnimatablePercentTextModifier.swift
//
//  Created by Luis Padron on 5/28/20.
//

import SwiftUI

struct AnimatablePercentTextModifier<Label: View>: AnimatableModifier {
    var percent: Double
    var animatableData: Double {
        get { percent }
        set { percent = newValue }
    }

    let label: (Double) -> Label

    func body(content: Content) -> some View {
        content.overlay(label(percent))
    }
}
