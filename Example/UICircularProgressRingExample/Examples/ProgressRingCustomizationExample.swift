//
//  ProgressRingCustomizationExample.swift
//  UICircularProgressRingExample
//
//  Created by Luis on 5/30/20.
//  Copyright © 2020 Luis. All rights reserved.
//

import SwiftUI
import UICircularProgressRing

struct ProgressRingCustomizationExample: View {
    let customizationViews = CustomizationView.allCases

    var body: some View {
        return List(customizationViews) { view in
            ModifierRow(customizationView: view)
        }
        .navigationBarTitle("Customization")
    }
}

// MARK: Modifier Views

enum CustomizationView: String, CaseIterable {
    case lineWidth
    case color
    case axis
    case clockwise
}

extension CustomizationView: Identifiable {
    var id: String {
        rawValue
    }
}

struct ModifierRow: View {
    let customizationView: CustomizationView

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                Text(customizationView.title)
                    .font(.system(.headline))
                    .bold()
                Text(customizationView.description)
                    .font(.system(.subheadline))
                    .foregroundColor(.gray)
            }

            customizationView.view
        }
        .padding(.vertical, 16)
    }
}


struct LineWidthModifier: View {
    @State var lineWidth: Double = 20

    var body: some View {
        VStack {
            Slider(value: $lineWidth, in: 5...40) {
                Text("Line width:")
            }

            ProgressRing(
                progress: .constant(.percent(0.7)),
                innerRingStyle: .init(color: .color(.blue), strokeStyle: .init(lineWidth: CGFloat(lineWidth)))
            )
            .frame(width: 200, height: 200)
        }
    }
}

struct ColorModifier: View {
    @State var isGradient = false

    var body: some View {
        VStack {
            Toggle(isOn: $isGradient) {
                Text(".gradient() vs. .color()")
            }

            ProgressRing(
                progress: .constant(.percent(0.7)),
                innerRingStyle: .init(color: color, strokeStyle: .init(lineWidth: 16))
            )
            .animation(.easeInOut(duration: 1))
            .frame(width: 200, height: 200)
        }
    }

    var color: RingColor {
        if isGradient {
            return RingColor.gradient(.init(gradient: .init(colors: [.red, .green, .blue]), center: .top))
        } else {
            return RingColor.color(.blue)
        }
    }
}

struct AxisModifier: View {
    let axes: [RingAxis] = [.top, .bottom, .leading, .trailing]
    @State private var selectedAxis = 0

    var body: some View {
        VStack {
            Picker("", selection: $selectedAxis) {
                ForEach(Array(axes.enumerated()), id: \.element) { index, axis in
                    Text(axis.title).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            ProgressRing(
                progress: .constant(.percent(0.7)),
                axis: axes[selectedAxis]
            )
            .animation(.easeInOut(duration: 1))
            .frame(width: 200, height: 200)
        }
    }
}

struct ClockwiseModifier: View {
    @State private var clockwise = false

    var body: some View {
        VStack {
            Toggle(isOn: $clockwise) {
                Text("Clockwise")
            }

            ProgressRing(
                progress: .constant(.percent(0.7)),
                clockwise: clockwise
            )
            .animation(.easeInOut(duration: 1))
            .frame(width: 200, height: 200)
        }
    }
}

// MARK: - Extensions

private extension CustomizationView {

    var title: String {
        switch self {
        case .lineWidth:
            return ".lineWidth"
        case .color:
            return ".color"
        case .axis:
            return ".axis"
        case .clockwise:
            return ".clockwise"
        }
    }

    var description: String {
        switch self {
        case .lineWidth:
            return "Modifies the width of the inner or outer ring."
        case .color:
            return "Either .color or .gradient."
        case .axis:
            return "Which axis to begin drawing."
        case .clockwise:
            return "Draw in a clockwise manner or not."
        }
    }

    var view: AnyView {
        switch self {
        case .lineWidth:
            return AnyView(LineWidthModifier())
        case .color:
            return AnyView(ColorModifier())
        case .axis:
            return AnyView(AxisModifier())
        case .clockwise:
            return AnyView(ClockwiseModifier())
        }
    }
}

private extension RingAxis {
    var title: String {
        switch self {
        case .top:
            return ".top"
        case .bottom:
            return ".bottom"
        case .leading:
            return ".leading"
        case .trailing:
            return ".trailing"
        }
    }
}
