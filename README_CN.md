# ZVProgressHUD
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
![CocoaPods Compatible](https://img.shields.io/badge/pod-1.0.0-4BC51D.svg?style=flat)[](https://cocoapods.org)
![Platform](https://img.shields.io/badge/platform-ios-9F9F9F.svg)[](http://cocoadocs.org/docsets/Alamofire)

<br/>

ZVProgressHUD is a pure-swift and wieldy HUD.

## Requirements

- iOS 8.0+
- Swift 3.0

## Installation
### Cocoapod
[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects.
<br/>

You can install Cocoapod with the following command

```
$ sudo gem install cocoapods
```
To integrate `ZVProgressHUD` into your project using CocoaPods, specify it into your `Podfile`

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    use_frameworks!
    pod 'ZVProgressHUD', '~> 2.0.0'
end
```

Then，install your dependencies with [CocoaPods](https://cocoapods.org).

```
$ pod install
```
### Carthage

[Carthage](https://github.com/Carthage/Carthage) is intended to be the simplest way to add frameworks to your application.

You can install Carthage with [Homebrew](https://brew.sh) using following command:

```
$ brew update
$ brew install carthage
```

To integrate `ZVProgressHUD` into your project using Carthage, specify it into your `Cartfile`

```
github "zevwings/ZVProgressHUD" ~> 0.0.1
```

Then，build the framework with Carthage
using `carthage update` and drag `ZVProgressHUD.framework` into your project.

#### Note:
The framework is under the Carthage/Build, and you should drag it into  `Target` -> `Genral` -> `Embedded Binaries`

## Usage
You can use `import ZVProgressHUD` when you needed to use `ZVProgressHUD`

当你进行一个任务时，你可以使用如下步骤进行

```
ZVProgressHUD.show()
DispatchQueue.global().async {
    ZVProgressHUD.dismiss()
}
```
*备注：* 不需要去指定隐藏`HUD`的线程，它一定是在主线程中完成。

#### Showing the HUD
你可以在开启一个任务时，使用如下代码，来展示等待的`HUD`

```
ZVProgressHUD.show(with: "do something", in: someview, delay: 0.0)
```

#### Dismiss the HUD

```
ZVProgressHUD.dismiss(delay: 0.0) { // do somthing on hud dismiss}
```

#### Showing the confirmation

```
ZVProgressHUD.showWarning(with: "warning" in: someview, delay: 0.0)
ZVProgressHUD.showError(with: "error", in: someview, delay: 0.0)
ZVProgressHUD.showSuccess(with: "success", in: someview, delay: 0.0)
```

#### Showing the toast

```
ZVProgressHUD.showText("text", in: someview, delay: 0.0)
```

#### Showing the custom image

```
ZVProgressHUD.showImage(customImege, title: "custom image", in: someview, dismissAtomically: false, delay: 0.0)
```

#### Showing the progress

```
ZVProgressHUD.showProgress(0.5, title: "show progress", in: someview, delay: 0.0)
```

#### Showing the animation

```
ZVProgressHUD.showAnimation(imageArray, duration: duration, title: "show animation", in: someview, delay: 0.0)
```

#### Custom HUD Properties

```
class var displayStyle: DisplayStyle

class var maskType: MaskType

class var maxSupportedWindowLevel: UIWindowLevel
class var fadeInAnimationTimeInterval: TimeInterval

class var fadeOutAnimationTImeInterval: TimeInterval

class var minimumDismissTimeInterval: TimeInterval

class var maximumDismissTimeInterval: TimeInterval

class var cornerRadius: CGFloat

class var offset: UIOffset

class var font: UIFont

class var strokeWith: CGFloat
class var indicatorSize: CGSize
class var animationType: IndicatorView.AnimationType
class var contentInsets: UIEdgeInsets
class var titleEdgeInsets: UIEdgeInsets
class var indicatorEdgeInsets: UIEdgeInsets
```

#### Notifications
当 `ZVProgressHUD.maskType` 不为 `ZVProgressHUD.MaskType.none` 时，点击`ZVProgressHUD._overlayView`会发送一个全局的 `.ZVProgressHUDDidReceiveTouchEvent` 通知，你可以使用这个通知自定义操作
