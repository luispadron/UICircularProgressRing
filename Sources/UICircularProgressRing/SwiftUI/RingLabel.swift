//
//  RingLabel.swift
//  
//
//  Created by Luis on 9/14/19.
//

import SwiftUI

/**
 # RingLabel

 A view which displays an animatable text that is formatted using the
 given `formatter`

 The "value" associated with the RingLabel must be `VectorArithmetic`, as this is a requirement
 for making the value `Animatable`.
 */
@available(OSX 10.15, iOS 13.0, *)
struct RingLabel<T: VectorArithmetic>: View {
    let value: T
    let formatter: UICircularRingValueFormatter
    let style: RingLabelStyle

    var body: some View {
        EmptyView()
            .modifier(
                RingLabelModifier(value: value,
                                  formatter: formatter,
                                  style: style)
            )
    }
}

/**
 # RingLabelModifier

 An `AnimatableModifier` responsible for animating the text of the ring label.
 Ex: Animating the number transisions from "0%" -> "100%"
 */
@available(OSX 10.15, iOS 13.0, *)
private struct RingLabelModifier<T: VectorArithmetic>: AnimatableModifier {
    var value: T
    let formatter: UICircularRingValueFormatter
    let style: RingLabelStyle

    var animatableData: T {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        ValueText(text: formatter.string(for: value), style: style)
    }

    /**
     # ValueText

     A simple extension view on `Text`.
     Handles displaying the given text returned from the `RingLabelModifier.formatter`, also
     controls the look of the labels text, such as font, color, etc.
     */
    private struct ValueText: View {
        let text: String?
        let style: RingLabelStyle

        var body: some View {
            text.map {
                style.generateView(with: $0)
            }
        }
    }
}

/// helper to convert label style into a view
@available(OSX 10.15, iOS 13.0, *)
private extension RingLabelStyle {
    func generateView(with string: String) -> some View {
        Text(string)
            .font(font)
            .foregroundColor(textColor)
    }
}
