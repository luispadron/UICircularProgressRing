//
//  UICircularProgressRingSnapshotTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis Padron on 1/6/20.
//

import SnapshotTesting
import XCTest

@testable import UICircularProgressRing

final class UICircularProgressRingSnapshotTests: XCTestCase {

    private var ring: UICircularProgressRing!

    override func setUp() {
        super.setUp()
        ring = UICircularProgressRing()
        ring.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        ring.startProgress(to: 75, duration: 0)
        ring.backgroundColor = .white
    }

    override func tearDown() {
        super.tearDown()
        ring = nil
    }

    func test_defaults() {
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_ontop_style() {
        ring.style = .ontop
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_dashed_style() {
        ring.style = .dashed(pattern: [0.3, 0.5])
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_dotted_style() {
        ring.style = .dotted
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_bordered_style() {
        ring.style = .bordered(width: 2, color: .red)
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_ontop_style_AND_knob() {
        ring.valueKnobStyle = .init(size: 16, color: .orange)
        ring.style = .ontop
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_dashed_style_AND_knob() {
        ring.valueKnobStyle = .init(size: 16, color: .orange)
        ring.style = .dashed(pattern: [0.3, 0.5])
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_dotted_style_AND_knob() {
        ring.valueKnobStyle = .init(size: 16, color: .orange)
        ring.style = .dotted
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_bordered_style_AND_knob() {
        ring.valueKnobStyle = .init(size: 16, color: .orange)
        ring.style = .bordered(width: 2, color: .red)
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_custom_knob_path() {
        ring.valueKnobStyle = .init(size: 16, color: .orange, path: .init({ rect in
            UIBezierPath(roundedRect: rect, cornerRadius: 4)
        }))
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_gradient_default() {
        ring.gradientOptions = .default
        assertSnapshot(matching: self.ring, as: .image)
    }

    func test_gradient() {
        ring.gradientOptions = UICircularRingGradientOptions(startPosition: .top, endPosition: .bottom, colors: [.red, .green, .blue], colorLocations: [0, 0.5, 1])
        assertSnapshot(matching: self.ring, as: .image)
    }
}
