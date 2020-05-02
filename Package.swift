// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MangaDexLib",
    products: [
        .library(name: "MangaDexLib", targets: ["MangaDexLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", .branch("master"))
    ],
    targets: [
        .target(name: "MangaDexLib", dependencies: ["SwiftSoup"], path: "Sources"),
        .testTarget(name: "MangaDexLibTests", dependencies: ["MangaDexLib"])
    ]
)
