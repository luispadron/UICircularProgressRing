//
//  SnapshotTest.swift
//
//
//  Created by Luis Padron on 5/28/20.
//

import SnapshotTesting
import XCTest

class SnapshotTest: XCTestCase {
    override func setUp() {
        super.setUp()

        //
        // This defines whether snapshot test recording
        #if SNAPSHOT_GENERATION
        record = true
        #else
        record = false
        #endif
        //
        //
    }
}
