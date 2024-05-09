// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let version = "1-5-38"
let shieldcredit_checksum = "15357d60b7b28ec4ad869345a14169531615661aef63176b710a7c186f0f8e3b"

let package = Package(
    name: "shieldcredit-spm",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ShieldCredit",
            targets: ["ShieldCreditTarget"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/shield-ai-technology/shieldfraud-spm.git", branch: "main")
    ],
    targets: [
        .binaryTarget(
            name: "ShieldCredit",
            url: "https://s3.amazonaws.com/cashshield-sdk/shieldcredit-ios-swift-\(version).zip",
            checksum: shieldcredit_checksum
        ),
        .target(
            name: "ShieldCreditTarget",
            dependencies: [
              .target(name: "ShieldCredit"),
              .product(name: "ShieldFraud", package: "shieldfraud-spm")
            ]
          )
    ]
)
