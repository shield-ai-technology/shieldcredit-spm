// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let version = "1-5-29"
let shieldcredit_checksum = "65692f1c294984d9fe659409b0a1633283fb17f18bb14f6b49a45562df8680b0"

let package = Package(
    name: "shieldcredit-spm",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ShieldCredit",
            targets: ["ShieldCredit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ShieldCredit",
            url: "https://s3.amazonaws.com/cashshield-sdk/shieldcredit-ios-swift-\(version).zip",
            checksum: shieldcredit_checksum
        )
    ]
)
