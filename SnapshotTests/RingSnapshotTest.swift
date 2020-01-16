//
//  RingSnapshotTest.swift
//
//
//  Created by Luis Padron on 5/28/20.
//

import SwiftUI
import SnapshotTesting
import XCTest

@testable import UICircularProgressRing

final class RingSnapshotTest: SnapshotTest {
    func test_ring_noText() {
        let ring = Ring(
            percent: 0.50,
            axis: .top,
            clockwise: true,
            color: .color(.blue),
            strokeStyle: .init(lineWidth: 20)
        )
            .frame(width: 200, height: 200)

        assertSnapshot(matching: ring, as: .image)
    }

    func test_ring_with_text() {
        let ring = Ring(
            percent: 0.76,
            axis: .top,
            clockwise: true,
            color: .color(.blue),
            strokeStyle: .init(lineWidth: 20)
        ) { percent in
            Text("\(percent * 100)%")
        }
            .frame(width: 200, height: 200)

        assertSnapshot(matching: ring, as: .image)
    }

    func test_ring_axis() {
        let allAxis = RingAxis.allCases
        let sut = Group {
            ForEach(allAxis, id: \.self) { axis in
                Ring(
                    percent: 0.5,
                    axis: axis,
                    clockwise: true,
                    color: .color(.blue),
                    strokeStyle: .init(lineWidth: 20)
                )
                .frame(width: 200, height: 200)
            }
        }


        assertSnapshot(matching: sut, as: .image)
    }

    func test_ring_clockwise() {
        let sut = Group {
            ForEach([false, true], id: \.self) { clockwise in
                Ring(
                    percent: 0.5,
                    axis: .top,
                    clockwise: clockwise,
                    color: .color(.blue),
                    strokeStyle: .init(lineWidth: 20)
                )
                .frame(width: 200, height: 200)
            }
        }


        assertSnapshot(matching: sut, as: .image)
    }

    func test_ring_color() {
         let sut = Group {
            ForEach([Color.blue, Color.red], id: \.self) { color in
                 Ring(
                     percent: 0.5,
                     axis: .top,
                     clockwise: true,
                     color: .color(color),
                     strokeStyle: .init(lineWidth: 20)
                 )
                .frame(width: 200, height: 200)
             }
         }


         assertSnapshot(matching: sut, as: .image)
     }

    func test_ring_strokeStyle() {
        let sut = Ring(
            percent: 0.5,
            axis: .top,
            clockwise: true,
            color: .color(.blue),
            strokeStyle: .init(lineWidth: 20, lineCap: .round, lineJoin: .round)
        )
        .frame(width: 200, height: 200)

        assertSnapshot(matching: sut, as: .image)
    }
}
