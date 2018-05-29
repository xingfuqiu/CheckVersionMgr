### APP 新版本检查提示库
![](https://ws2.sinaimg.cn/large/006tKfTcgy1frsdg9v9uaj30my0j0dgc.jpg)
### 特性
* 通过 Bundle ID 自动检查更新
* 可设置两次提醒的间隔
* 两种跳转方式 (InApp/App Store)
* 支持自定义弹窗,需要自己实现提示方式
* 系统默认 `UIAlertController` 弹窗提示方式
### 安装
* Cocoapods
```
pod 'CheckVersionMgr-Swift'
```
### 使用
step 1
```swift
import CheckVersionMgr_Swift
```
step 2
```swift
CheckVersionMgr.shared.checkVersionWithSystemAlert()
```
or

```swift
let cvm = CheckVersionMgr.shared
cvm.CheckAgainInterval = 1
cvm.openTrackUrlInAppStore = false
cvm.checkVersionWithSystemAlert()
```