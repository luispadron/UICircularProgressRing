// swift-tools-version:5.1

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
            url: "https://github.com/luispadron/swift-snapshot-testing.git",
            .branch("master")
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
