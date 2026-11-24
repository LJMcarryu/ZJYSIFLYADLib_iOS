# ZJ 萤石广告 SDK

<!-- ifly-fast-release-notice:start -->
当前版本：`6.5.4`。本版尚未完成安装、构建与广告展示验证，请先在宿主 App 中联调。

<!-- ifly-release-status: {"version":"6.5.4","status":"FAST_UNVERIFIED","distribution":"tos","releaseUrl":"https://download-adsdk.voiceads.cn/ios_sdk/6.5.4/zjys/fast-release-record.json"} -->

<!-- ifly-fast-release-notice:end -->

提供开屏、插屏和自渲染信息流，支持图片与视频素材，最低 iOS 11.0。

本仓提供 `6.5.3` 版本的接入材料，支持 CocoaPods、SwiftPM 和手动集成。实际发布进度以 `release-state.json` 为准。

## 三种接入示例

| 接入方式 | 独立示例 | 首次准备 |
| --- | --- | --- |
| CocoaPods | [ZJ_YSAdSDKSimple](ZJ_YSAdSDKSimple/README.md) | 在示例目录运行 `pod install` |
| SwiftPM | [ZJYSIFLYADLibSwiftPMSimple](ZJYSIFLYADLibSwiftPMSimple/README.md) | 直接打开示例 workspace，Xcode 解析远程包 |
| 手动集成 | [ZJYSIFLYADLibManualSimple](ZJYSIFLYADLibManualSimple/README.md) | 运行示例内 `准备SDK.py`，再打开 workspace |

各示例固定的 SDK 版本与运行步骤以其 README 为准。一次只选择一种集成方式。

## 接入入口

- [完整接入指南](docs/接入指南/README.md)
- [CocoaPods 示例](ZJ_YSAdSDKSimple/README.md)
- [更新记录](CHANGELOG.md)

```objc
#import <ZJ_YSAdSDK/ZJ_YSAdSDK.h>
```

模块和 Pod 名为 `ZJ_YSAdSDK`，类名使用 `ZJ_IFLY` 前缀，业务方法与代理回调使用 `zj_` 前缀。初始化方法、系统协议方法和属性访问器沿用原名。

升级或迁移时替换旧 SDK 与资源包，勿同时链接旧 SDK。SwiftPM 与手动集成需在 App target 添加 `-ObjC`；手动集成同时复制 `ZJ_YSAdSDK.bundle`。


