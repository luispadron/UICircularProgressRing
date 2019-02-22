//
//  ValueFormatterTests.swift
//  UICircularProgressRingTests
//
//  Created by Luis on 2/22/19.
//  Copyright © 2019 Luis Padron. All rights reserved.
//

import XCTest
@testable import UICircularProgressRing

final class ValueFormatterTests: XCTestCase {

    struct LameFormatter: UICircularRingValueFormatter {
        func string(for value: Any) -> String? {
            guard let value = value as? CGFloat else { return nil }
            return "Lame \(value)"
        }
    }

    func testCustomFormatter() {
        let formatter = LameFormatter()
        XCTAssertEqual(formatter.string(for: CGFloat(69.420))!, "Lame 69.42")
        XCTAssertNil(formatter.string(for: "Wow this should fail!"))
    }

}
