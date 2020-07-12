//
//  View+Visible.swift
//
//  Created by Luis on 5/28/20.
//

import SwiftUI

struct VisibleModifier: ViewModifier {
    let visible: Bool

    func body(content: Content) -> some View {
        Group {
            if visible {
                Color
                    .clear
                    .overlay(content)
            } else {
                Color
                    .clear
            }
        }
    }
}

extension View {
    func visible(_ visible: Bool) -> some View {
        self.modifier(VisibleModifier(visible: visible))
    }
}
