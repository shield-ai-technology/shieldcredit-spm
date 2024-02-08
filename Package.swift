// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let version = "1-5-33"
let shieldcredit_checksum = "8b918bd4f1e409dee07445b97b10754dbd21ce833612fdf7cf3ef3ac66639dbf"

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
