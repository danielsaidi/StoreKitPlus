// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "StoreKitPlus",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
        .tvOS(.v16),
        .watchOS(.v9),
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
            name: "StoreKitPlus"
        ),
        .testTarget(
            name: "StoreKitPlusTests",
            dependencies: ["StoreKitPlus"]
        )
    ]
)
