# Manual 接入示例

此独立示例固定使用 SDK `6.5.3`；仓库当前发布版本另见[根 README](../README.md)。工程包含与本仓 CocoaPods Demo 对应的广告示例页面，应用 Bundle Identifier 独立，可以分别安装对比。示例源码是生成时的独立副本。

## 获取示例

下载 [GitHub main 分支源码 ZIP](https://github.com/LJMcarryu/ZJYSIFLYADLib_iOS/archive/refs/heads/main.zip)，解压后进入 `ZJYSIFLYADLib_iOS-main/ZJYSIFLYADLibManualSimple/`。必须下载完整源码，不能只下载工程文件或准备脚本。也可使用 Git：

```bash
git clone --branch main --single-branch https://github.com/LJMcarryu/ZJYSIFLYADLib_iOS.git
cd ZJYSIFLYADLib_iOS/ZJYSIFLYADLibManualSimple
```

以下命令均在这个示例目录执行。历史 Tag 的示例不会随 main 更新；运行前核对本页、依赖锁文件及资源版本。将 SDK 接入自己的 App 时，请按[接入指南](../docs/接入指南/README.md)操作。

## 运行

先准备本地库，再打开共享 workspace（需要 Python 3）：

```bash
python3 准备SDK.py
open ZJYSIFLYADLibManualSimple.xcworkspace
```

准备脚本按 `sdk-artifacts.json` 下载并校验固定版本的官方 XCFramework，放入 `Vendor/`。工程直接链接这些本地库，不使用 SwiftPM 或 CocoaPods，Xcode 构建过程不会联网下载库。`Vendor/` 不提交 Git；已经准备好的副本可离线构建。也可以从清单中的官方链接自行下载 ZIP，再运行 `python3 准备SDK.py --archive-dir /绝对路径/下载目录`。本地库被修改时脚本会拒绝复用；确认需要重建后使用 `--refresh`。

工程按静态库方式链接 XCFramework（**Do Not Embed**）。**资源随 GitHub 示例源码下载**：同版资源和隐私清单保存在 `SDKResources/`，已配置 Copy Bundle Resources；`准备SDK.py` 只下载二进制，不下载 bundle。若缺少该目录，重新获取完整示例源码，不要混用其他版本。`--archive-dir` 接受清单指定的各模块 `.xcframework.zip`，不接受完整合包或资源包代替。

在 Xcode 选择 **ZJYSIFLYADLibManualSimple** scheme，再选择模拟器或真机。真机运行时设置自己的 Team 与 Bundle Identifier，替换源码 `Supporting Files` 中的广告位配置。示例 ID 不保证填充。工程最低声明 iOS 11.0，实际可用系统范围需结合所用 Xcode 与 SDK 验证。

App target 已配置 `$(inherited) -ObjC`、`AdSupport.framework` 和 Optional 的 `AppTrackingTransparency.framework`。请保留应用隐私流程与系统授权处理；构建通过不代表广告已成功加载或展示。

页面使用与各广告形式 API 见[接入指南](../docs/接入指南/README.md)；广告位宏、页面按钮与回调观察见 [CocoaPods 示例说明](../ZJ_YSAdSDKSimple/README.md)。本副本的源码目录仍为 `ZJ_YSAdSDKSimple/`，请修改本副本中的配置文件。运行后检查首页 SDK 版本；日志或请求失败须按实际回调和系统日志定位，编译通过与广告有填充分开检查。

## 构建检查

```bash
xcodebuild -workspace ZJYSIFLYADLibManualSimple.xcworkspace \
  -scheme ZJYSIFLYADLibManualSimple -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO build
```

## 已验证范围

本版示例使用 Xcode 26.2 完成 Debug 构建：iOS Simulator 的 arm64 / x86_64，以及 iOS 设备架构的 arm64；同时核对链接符号、同版资源及隐私清单。设备架构构建关闭代码签名，未验证实际设备运行、广告加载、填充或展示。工程声明 iOS 11.0，未据此验证 iOS 11 的运行兼容性。

## 版本维护

此示例不会随仓库当前版本自动升级。更新依赖时同时更新工程、锁文件或资产摘要、同版资源及说明，并重新验证模拟器与设备架构。不得混用不同版本的库与资源。`示例来源.json` 记录本副本的 SDK Tag 和示例源码提交。
