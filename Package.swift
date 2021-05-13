// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangaDexLib",
    products: [
        .library(name: "MangaDexLib", targets: ["MangaDexLib"])
    ],
    targets: [
        .target(name: "MangaDexLib", path: "Sources"),
        .testTarget(name: "MangaDexLibTests", dependencies: ["MangaDexLib"])
    ]
)
