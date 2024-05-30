// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "StoreKitPlus",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "StoreKitPlus",
            targets: ["StoreKitPlus"]
        )
    ],
    targets: [
        .target(
            name: "StoreKitPlus",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "StoreKitPlusTests",
            dependencies: ["StoreKitPlus"]
        )
    ]
)
