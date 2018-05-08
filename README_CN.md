# ZVProgressHUD
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
![CocoaPods Compatible](https://img.shields.io/badge/pod-1.0.0-4BC51D.svg?style=flat)[](https://cocoapods.org)
![Platform](https://img.shields.io/badge/platform-ios-9F9F9F.svg)[](http://cocoadocs.org/docsets/Alamofire)


`ZVProgressHUD` 是用纯`swift`开发，简单易用的提示工具。

## 版本支持

- iOS 8.0+ 
- Swift 4.0

## 安装
### Cocoapod
[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects.

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

## 使用方法
当你在需要使用`ZVProgressHUD `使用`import ZVProgressHUD`导入即可。

### 任务提示
当你需要任务提示时，使用如下代码即可

```
ZVProgressHUD.show()
```

通过如下代码自定义动画类型

```
/// 动画类型，默认为 .flat
public enum AnimationType {
	//使用自定义`ZVActivityIndicator`
	case flat		
	//使用系统自带`UIActivityIndicator`
	case native	
}

/// 你可以通过类属性修改动画类型
ZVProgressHUD.animationType = .flat
```

当你需要改变`ZVProgressHUD`的显示父视图时，只需要在调用`show`方法时，指定父视图即可

```
// 你也可以延迟视图显示，通过`delay`参数
ZVProgressHUD.show(with: "正在加载", in: superview, delay: 0.0)
```

### 关闭提示
当你需要关闭任务提示时，使用如下代码即可

```
ZVProgressHUD.dismiss()
```

### 展示一个确认信息
当需要展示任务确认信息时，调用如下方法

```
ZVProgressHUD.showError(with: "保存失败")
ZVProgressHUD.showSuccess(with: "保存成功")
ZVProgressHUD.showWarning(with: "存储信息有误")
```

### 展示自定义图片
当你需要展示自定义图片时，可以使用如下方法

```
let image = UIImage(named: "smile")
ZVProgressHUD.showImage(image!)
// 或者
ZVProgressHUD.showImage(image!, title: "微笑每一天")
```

### 展示自定义动画
当你需要展示自定义动画时，可以使用如下方法

```
var images = [UIImage]()
for index in 1 ... 3 {
    let image = UIImage(named: "loading_0\(index)")
    images.append(image!)
}

ZVProgressHUD.showAnimation(images)
```

### 展示任务进度

```
ZVProgressHUD.showProgress(0.0, title: "任务进度")
```

### 自定义属性

```
// 设置显示前景色、背景色
class var displayStyle: DisplayStyle 

// 设置遮罩类型
class var maskType: MaskType 

// 基础视图圆角    
class var cornerRadius: CGFloat 

// 基础视图的偏移量
class var offset: UIOffset 

// 字体
class var font: UIFont 

// 当动画类型为`flat`时，改变圆环宽度
class var strokeWith: CGFloat 

// 指示视图大小
class var indicatorSize: CGSize 

// 设置动画类型，默认为`flat`
class var animationType: IndicatorView.AnimationType 

```

### 自定义边距

```
// 设置整体内容边距
class var contentInsets: UIEdgeInsets 

// 设置文本边距
class var titleEdgeInsets: UIEdgeInsets 

// 设置指示器边距
class var indicatorEdgeInsets: UIEdgeInsets 
```

### 通知

你可以使用对应类型的通知，自定义相关操作。

```
extension NSNotification.Name {
	
	 // 接受到点击时间
    public static let ZVProgressHUDReceivedTouchUpInsideEvent: Notification.Name

	 // 视图将要展示
    public static let ZVProgressHUDWillAppear: Notification.Name

	 // 视图完成展示
    public static let ZVProgressHUDDidAppear: Notification.Name

	 // 视图将要消失
    public static let ZVProgressHUDWillDisappear: Notification.Name

	 // 视图完成消失
    public static let ZVProgressHUDDidDisappear: Notification.Name
}
```
