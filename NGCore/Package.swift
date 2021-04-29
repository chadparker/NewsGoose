// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NGCore",
    platforms: [
        .iOS(.v10),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "NGCore",
            targets: ["NGCore"]),
    ],
    dependencies: [
        .package(name: "GRDB", url: "https://github.com/groue/GRDB.swift.git", from: "5.7.4"),
    ],
    targets: [
        .target(
            name: "NGCore",
            dependencies: ["GRDB"]),
        .testTarget(
            name: "NGCoreTests",
            dependencies: ["NGCore"]),
    ]
)
