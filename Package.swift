// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UICircularProgressRing",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "UICircularProgressRing",
            targets: ["UICircularProgressRing"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.7.0")
    ],
    targets: [
        .target(name: "UICircularProgressRing", dependencies: [], path: "Sources"),
        .testTarget(name: "UICircularProgressRingTests", dependencies: ["UICircularProgressRing", "SnapshotTesting"], path: "Tests"),
    ]
)