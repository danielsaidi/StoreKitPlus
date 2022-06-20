// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "StoreKitPlus",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "StoreKitPlus",
            targets: ["StoreKitPlus"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "StoreKitPlus",
            dependencies: []),
        .testTarget(
            name: "StoreKitPlusTests",
            dependencies: ["StoreKitPlus"]),
    ]
)
