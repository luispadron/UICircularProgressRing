//
//  ProgressRingLabel.swift
//  
//
//  Created by Luis on 9/14/19.
//

import SwiftUI


@available(OSX 10.15, iOS 13.0, *)
struct ProgressRingLabelAnimator: AnimatableModifier {
    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(ValueText(value: value))
    }

    private struct ValueText: View {
        let value: Double

        var body: some View {
            Text("\(Int(value))%")
                .fontWeight(.medium)
                .foregroundColor(.black)
                .font(.body)
        }
    }
}

@available(OSX 10.15, iOS 13.0, *)
struct ProgressRingLabel: View {
    let progress: Double

    var body: some View {
        // TODO: Look into why the `Color.clear.overlay` is required
        // this seems to be a beta bug, as without this the view is broken
        Color.clear
            .overlay(EmptyView())
            .modifier(ProgressRingLabelAnimator(value: progress))
    }
}
