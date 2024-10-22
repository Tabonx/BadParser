// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BadParser",
    products: [
        .library(
            name: "BadParser",
            targets: ["BadParser"]
        ),
    ],
    targets: [
        .target(
            name: "BadParser"),
        .testTarget(
            name: "BadParserTests",
            dependencies: [
                "BadParser",
            ],
            path: "Tests",
            resources: [
                .copy("TestData"),
            ]
        ),
    ]
)
