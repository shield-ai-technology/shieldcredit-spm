// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let version = "1-5-34"
let shieldcredit_checksum = "d1e99745587037fc6791dbc04753cb8e60a82a0bba7326921ccee560e8d4e442"

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
