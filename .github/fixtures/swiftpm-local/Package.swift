// swift-tools-version:5.9

// Release CI 将本次正式二进制和受版本控制的资源复制到本清单旁，
// 以本地 binaryTarget 实际构建 SwiftPM 产品，再链接最小消费端。

import PackageDescription

let package = Package(
    name: "ZJ_YSAdSDKReleaseValidation",
    platforms: [
        .iOS("11.0"),
    ],
    products: [
        .library(
            name: "ZJ_YSAdSDK",
            targets: ["ZJ_YSAdSDK", "ZJ_YSAdSDKResources"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "ZJ_YSAdSDK",
            path: "ZJ_YSAdSDK.xcframework"
        ),
        .target(
            name: "ZJ_YSAdSDKResources",
            path: "spm/ZJ_YSAdSDKResources",
            resources: [
                .copy("ZJ_YSAdSDK.bundle"),
            ]
        ),
    ]
)
