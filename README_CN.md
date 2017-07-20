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
    pod 'ZVProgressHUD', :git => 'https://github.com/zevwings/ZVProgressHUD.git'
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

### Manual
Download this project, And drag `ZVProgressHUD.xcodeproj` into your own project.

In your target’s General tab, click the ’+’ button under `Embedded Binaries`

Select the `ZVProgressHUD.framework` to Add to your platform.

## Usage
You can use `import ZVProgressHUD` when you needed to use `ZVProgressHUD`

当你进行一个任务时，你可以使用如下步骤进行

```
ZVProgressHUD.show()
DispatchQueue.global().async {
    ZVProgressHUD.dismiss()
}
```
备注：不需要去指定隐藏`HUD`的线程，它一定是在主线程中完成。

#### Showing the HUD
你可以在开启一个任务时，使用如下代码，来展示等待的`HUD`

```
ZVProgressHUD.show()
ZVProgressHUD.show(with: .state(title: "Loading...", state: .indicator))
```

#### Dismiss the HUD

```
ZVProgressHUD.dismiss()
```

#### Showing the confirmation

```
ZVProgressHUD.show(with: .state(title: "Error", state: .error))
ZVProgressHUD.show(with: .state(title: "Success", state: .success))
ZVProgressHUD.show(with: .state(title: "Warning", state: .warning))
```
#### Showing the custom image

```
let image = UIImage(named: "cost")
ZVProgressHUD.show(image: image!)

let image = UIImage(named: "cost")
ZVProgressHUD.show(with: .state(title: "Cost", state: .custom(image: image!)))
```

#### Showing the progress

```
ZVProgressHUD.show(title: title, progress: progress)
```

#### Showing the custom view

```
let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
customView.backgroundColor = UIColor.white
let label = UILabel(frame: CGRect(x: 0, y: 30, width: 100, height: 40 ))
label.textAlignment = .center
label.font = UIFont.systemFont(ofSize: 14.0)
label.textColor = UIColor(red: 215.0 / 255.0, green: 22.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
label.text = "custom view"
customView.addSubview(label)
ZVProgressHUD.customInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
ZVProgressHUD.show(with: .custom(view: customView))
```

#### Custom HUD Properties

```
public static var displayStyle: ZVProgressHUD.DisplayStyle     

/// 设置遮罩层类型
public static var maskType: ZVProgressHUD.MaskType
    
/// 设置文本标签边距
public static var titleInsets: UIEdgeInsets 

/// 状态视图与其他空间边距，如果状态视图和文本标题存在时，bottom无效
public static var stateInsets: UIEdgeInsets

/// 自定义视图与其他空间边距
public static var customInsets: UIEdgeInsets

/// baseView偏离位置
public static var offset: CGPoint 
    
/// 文本字体
public static var font: UIFont 

/// 设置整体消失时间 
public static var delay: TimeInterval 

/// baseView圆角 NOTE: 当视图为纯文本时圆角为该值的一般
public static var cornerRadius: CGFloat
```

#### Notifications
当 `ZVProgressHUD.maskType` 不为 `ZVProgressHUD.MaskType.none` 时，点击`ZVProgressHUD._overlayView`会发送一个全局的 `.ZVProgressHUDDidReceiveTouchEvent` 通知，你可以使用这个通知自定义操作



