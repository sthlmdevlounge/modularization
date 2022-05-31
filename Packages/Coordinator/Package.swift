// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coordinator",
    products: [
        .library(
            name: "Coordinator",
            type: .dynamic,
            targets: ["Coordinator"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Coordinator",
            dependencies: []),
        .testTarget(
            name: "CoordinatorTests",
            dependencies: ["Coordinator"]),
    ]
)
