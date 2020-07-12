//
//  TimerRingSnapshotTests.swift
//  UICircularProgressRingSnapshotTests
//
//  Created by Luis Padron on 6/9/20.
//

import SnapshotTesting
import SwiftUI
import XCTest

@testable import UICircularProgressRing

final class TimerRingSnapshotTests: SnapshotTest {
    func test_timerRing_default() {
        let sut = TimerRing(
            time: .minutes(1),
            elapsedTime: .seconds(30),
            isDone: .constant(false)
        ) { time in
            Text(String(time))
        }
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_axis() {
        let axes: [RingAxis] = [.top, .bottom, .leading, .trailing]

         let sut = Group {
            ForEach(0..<4) { index in
                TimerRing(
                    time: .minutes(1),
                    elapsedTime: .seconds(30),
                    axis: axes[index],
                    isDone: .constant(false)
                 )
                 .frame(width: 200, height: 200)
             }
         }

         assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_clockwise() {
        let values: [Bool] = [false, true]

         let sut = Group {
             ForEach(0..<2) { index in
                 TimerRing(
                     time: .minutes(1),
                     elapsedTime: .seconds(30),
                     clockwise: values[index],
                     isDone: .constant(false)
                  )
                 .frame(width: 200, height: 200)
             }
         }

         assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_style_innerRingColor() {
        let colors: [RingColor] = [
            .color(.red),
            .gradient(.init(gradient: .init(colors: [.red, .blue]), center: .center))
        ]

        let sut = Group {
            ForEach(0..<1) { index in
                TimerRing(
                    time: .minutes(1),
                    elapsedTime: .seconds(30),
                    innerRingStyle: .init(color: colors[index], strokeStyle: .init(lineWidth: 16)),
                    isDone: .constant(false)
                 )
                .frame(width: 200, height: 200)
            }
        }

        assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_outerRingColor() {
        let colors: [RingColor] = [
            .color(.red),
            .gradient(.init(gradient: .init(colors: [.red, .blue]), center: .center))
        ]

        let sut = Group {
            ForEach(0..<1) { index in
                TimerRing(
                    time: .minutes(1),
                    elapsedTime: .seconds(30),
                    outerRingStyle: .init(color: colors[index], strokeStyle: .init(lineWidth: 32)),
                    isDone: .constant(false)
                 )
                .frame(width: 200, height: 200)
            }
        }

        assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_style_innerRing_strokeStyleLineWidth() {
        let sut = TimerRing(
            time: .minutes(1),
            elapsedTime: .seconds(30),
            innerRingStyle: .init(color: .color(.blue), strokeStyle: .init(lineWidth: 10)),
            isDone: .constant(false)
         )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_outerRing_strokeStyleLineWidth() {
        let sut = TimerRing(
            time: .minutes(1),
            elapsedTime: .seconds(30),
            outerRingStyle: .init(color: .color(.gray), strokeStyle: .init(lineWidth: 40)),
            isDone: .constant(false)
         )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_innerRingPadding() {
        let sut = TimerRing(
            time: .minutes(1),
            elapsedTime: .seconds(30),
            innerRingStyle: .init(color: .color(.blue), strokeStyle: .init(lineWidth: 10), padding: 0),
            isDone: .constant(false)
        )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }

    func test_timerRing_outerRingPadding() {
        let sut = TimerRing(
            time: .minutes(1),
            elapsedTime: .seconds(30),
            outerRingStyle: .init(color: .color(.gray), strokeStyle: .init(lineWidth: 32), padding: 8),
            isDone: .constant(false)
        )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }
}
