// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProtocolTests",
    products: [
        .library(
            name: "ProtocolTests",
            targets: ["ProtocolTests"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ProtocolTests",
            dependencies: []
        ),
        .testTarget(
            name: "ProtocolTestsTests",
            dependencies: ["ProtocolTests"]
        ),
    ]
)
