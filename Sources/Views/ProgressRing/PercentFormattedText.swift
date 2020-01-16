//
//  PercentFormattedText.swift
//  
//
//  Created by Luis on 5/30/20.
//

import SwiftUI

/// A view which displays the current percentage using a number formatter.
public struct PercentFormattedText {
    /// the percent to display.
    let percent: Double

    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }()
}

extension PercentFormattedText: View {
    public var body: some View {
        Text(self.numberFormatter.string(from: .init(floatLiteral: self.percent)) ?? "NaN")
            .font(.system(.title))
            .animation(nil) // disable frame animation for implicit animations.
    }
}
