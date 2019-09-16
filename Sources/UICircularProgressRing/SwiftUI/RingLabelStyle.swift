//
//  RingLabelStyle.swift
//  
//
//  Created by Luis on 9/15/19.
//

import SwiftUI

/**
 # RingLabelStyle

 Defines the style of the text displayed in the rings.
 */
@available(OSX 10.15, iOS 13.0, *)
public struct RingLabelStyle {
    let font: Font
    let textColor: Color

    public init(font: Font = .body,
                textColor: Color = .black) {
        self.font = font
        self.textColor = textColor
    }
}
