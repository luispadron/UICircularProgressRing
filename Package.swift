// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UICircularProgressRing",
    platforms: [.iOS(.v8)],
    products: [
        .library(
            name: "UICircularProgressRing",
            targets: ["UICircularProgressRing"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "UICircularProgressRing",
            dependencies: [],
						path: "src/UICircularProgressRing"),
    ]
)
