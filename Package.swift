// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let version = "1-5-31"
let shieldcredit_checksum = "8e26cb0edcdbda1c3a248cf3c436d78cea50fdb3d24af40c0ffb688d489371e7"

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
