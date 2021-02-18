// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZVProgressHUD",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "ZVProgressHUD",
            targets: ["ZVProgressHUD"]),
    ],
    dependencies: [
         .package(url: "https://github.com/zevwings/ZVActivityIndicatorView.git", from: "0.2.1"),
    ],
    targets: [
        .target(
            name: "ZVProgressHUD",
            dependencies: ["ZVActivityIndicatorView"],
            path: "./ZVProgressHUD",
            exclude: ["Info.plist"],
            resources: [
                .process("Resource.bundle")
            ],
            swiftSettings: [
                .define("ZVProgressHUD_SPM")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
