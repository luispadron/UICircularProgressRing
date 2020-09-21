// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "UICircularProgressRing",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "UICircularProgressRing",
            targets: ["UICircularProgressRing"]
        )
    ],
    dependencies: [
        .package(
            name: "SnapshotTesting", 
            url: "https://github.com/pointfreeco/swift-snapshot-testing.git", 
            from: "1.8.1"
        )
    ],
    targets: [
        .target(
            name: "UICircularProgressRing",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "UICircularProgressRingTests",
            dependencies: [
                "UICircularProgressRing"
            ],
            path: "Tests"
        ),
        .testTarget(
            name: "UICircularProgressRingSnapshotTests",
            dependencies: [
                "UICircularProgressRing",
                "SnapshotTesting"
            ],
            path: "SnapshotTests"
        )
    ]
)
