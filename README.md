# ZJ 萤石广告 SDK

提供开屏、插屏和自渲染信息流，支持图片与视频素材，最低 iOS 11.0。

当前 `6.5.3-beta.2` 为首发候选，尚未发布。完成发布后可通过 CocoaPods、SwiftPM 或手动集成。

## 接入入口

- [完整接入指南](docs/接入指南/README.md)
- [CocoaPods 示例](ZJ_YSAdSDKSimple/README.md)
- [更新记录](CHANGELOG.md)

```objc
#import <ZJ_YSAdSDK/ZJ_YSAdSDK.h>
```

模块和 Pod 名为 `ZJ_YSAdSDK`，类名使用 `ZJ_IFLY` 前缀，业务方法与代理回调使用 `zj_` 前缀。初始化方法、系统协议方法和属性访问器沿用原名。

升级或迁移时替换旧 SDK 与资源包，勿同时链接旧 YS 库。SwiftPM 与手动集成需在 App target 添加 `-ObjC`；手动集成同时复制 `ZJ_YSAdSDK.bundle`。

<!-- ifly-release-status: {"version": "6.5.3-beta.2", "status": "CANDIDATE", "distribution": "tos", "releaseUrl": null} -->
