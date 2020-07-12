//
//  ProgressRingSnapshotTests.swift
//  UICircularProgressRingSnapshotTests
//
//  Created by Luis on 5/30/20.
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import UICircularProgressRing

final class ProgressRingSnapshotTests: XCTestCase {
    func test_progressRing_default() {
        let sut = ProgressRing(progress: .constant(.percent(0.5))).frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_axis() {
        let axes: [RingAxis] = [.top, .bottom, .leading, .trailing]

         let sut = Group {
             ForEach(0..<4) { index in
                 ProgressRing(
                     progress: .constant(.percent(0.5)),
                     axis: axes[index]
                 )
                 .frame(width: 200, height: 200)
             }
         }

         assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_clockwise() {
        let values: [Bool] = [false, true]

         let sut = Group {
             ForEach(0..<2) { index in
                 ProgressRing(
                     progress: .constant(.percent(0.5)),
                     clockwise: values[index]
                 )
                 .frame(width: 200, height: 200)
             }
         }

         assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_style_innerRingColor() {
        let colors: [RingColor] = [
            .color(.red),
            .gradient(.init(gradient: .init(colors: [.red, .blue]), center: .center))
        ]

        let sut = Group {
            ForEach(0..<1) { index in
                ProgressRing(
                    progress: .constant(.percent(0.5)),
                    innerRingStyle: .init(color: colors[index], strokeStyle: .init(lineWidth: 16))
                )
                .frame(width: 200, height: 200)
            }
        }

        assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_outerRingColor() {
        let colors: [RingColor] = [
            .color(.red),
            .gradient(.init(gradient: .init(colors: [.red, .blue]), center: .center))
        ]

        let sut = Group {
            ForEach(0..<1) { index in
                ProgressRing(
                    progress: .constant(.percent(0.5)),
                    outerRingStyle: .init(color: colors[index], strokeStyle: .init(lineWidth: 32))
                )
                .frame(width: 200, height: 200)
            }
        }

        assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_innerRing_strokeStyleLineWidth() {
        let sut = ProgressRing(
            progress: .constant(.percent(0.5)),
            innerRingStyle: .init(color: .color(.blue), strokeStyle: .init(lineWidth: 10))
        )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_outerRing_strokeStyleLineWidth() {
        let sut = ProgressRing(
            progress: .constant(.percent(0.5)),
            outerRingStyle: .init(color: .color(.gray), strokeStyle: .init(lineWidth: 40))
        )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_innerRingPadding() {
        let sut = ProgressRing(
            progress: .constant(.percent(0.5)),
            innerRingStyle: .init(color: .color(.blue), strokeStyle: .init(lineWidth: 16), padding: 0)
        )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_progressRing_outerRingPadding() {
        let sut = ProgressRing(
            progress: .constant(.percent(0.5)),
            outerRingStyle: .init(color: .color(.gray), strokeStyle: .init(lineWidth: 32), padding: 8)
        )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }
}
