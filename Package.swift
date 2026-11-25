// swift-tools-version:5.9

// ZJ 萤石定制 SDK；product 自动包含资源与隐私清单。
// 在宿主 App target 的 Other Linker Flags 中添加 -ObjC。

import PackageDescription

let package = Package(
    name: "ZJ_YSAdSDK",
    // 6.5.5 目标二进制继续按 iOS 11 构建；资源由资源 target 同步投递。
    platforms: [
        .iOS("11.0"),
    ],
    products: [
        .library(name: "ZJ_YSAdSDK", targets: ["ZJ_YSAdSDK", "ZJ_YSAdSDKResources"]),
    ],
    targets: [
        .binaryTarget(
            name: "ZJ_YSAdSDK",
            url: "https://download-adsdk.voiceads.cn/ios_sdk/6.5.5/zjys/ZJ_YSAdSDK.xcframework.zip",
            checksum: "1bbc004fbd3f68132ecee7ecdfd13f26e69a137c6cebb58b6c40e2d03b4cd379"
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
