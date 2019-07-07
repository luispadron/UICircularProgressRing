// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "UICircularProgressRing",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "UICircularProgressRing",
            targets: ["UICircularProgressRing"]
        )
    ],
    targets: [
        .target(
            name: "UICircularProgressRing",
            dependencies: []
        ),
        .testTarget(
            name: "UICircularProgressRingTests",
            dependencies: ["UICircularProgressRing"]
        )
    ]
)
