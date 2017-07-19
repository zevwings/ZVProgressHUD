# ZVProgressHUD
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
<br/>

ZVProgressHUD 是使用纯Swift开发，简单易用的提示控件。 

## Installation
### Cocoapod
第一步，安装 [CocoaPods](https://cocoapods.org)，关于Pods更多的介绍和功能，请移步[CocoaPods 主页](https://cocoapods.org)；

```
$ sudo gem install cocoapods
```
第二步, 使用[CocoaPods](https://cocoapods.org)集成 `ZVProgressHUD` ，并写入到你的`Podfile`中；

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    use_frameworks!
    pod 'ZVProgressHUD', :git => 'https://github.com/zevwings/ZVProgressHUD.git'
end
```

最后，使用[CocoaPods](https://cocoapods.org) 安装你的依赖库。

```
$ pod install
```
### Carthage 

第一步，使用[Homebrew](https://brew.sh)安装[Carthage](https://github.com/Carthage/Carthage)，关于Carthage更多的介绍和功能，请移步[Carthage 主页](https://github.com/Carthage/Carthage)；

```
$ brew update
$ brew install carthage
```

第二步， 使用[Carthage](https://github.com/Carthage/Carthage)集成 `ZVProgressHUD` ，并写入到你的`Cartfile`中；

```
github "zevwings/ZVProgressHUD" ~> 0.0.1
```

第三步，使用[Carthage](https://github.com/Carthage/Carthage) 安装依赖；

```
$ carthage update
```

最后，在Carthage/Build文件夹下面找到 `ZVProgressHUD.framework` 并拖到Targets -> Genral的Embedded Binaries下。

### Manual
第一步，下载本项目，并将 `ZVProgressHUD.xcodeproj` 拖到你的目录下；

第二步，在你的项目配置找到 Targets -> Genral -> Embedded Binaries，点击 `+` 按钮， 选择`ZVProgressHUD.framework` 并添加到工程。 

## Demo
### Appetize
你可以在线查看Demo: 
https://appetize.io/app/hkhybxa53yyw594zp8v5chee0r?device=iphone6s&scale=75&orientation=portrait&osVersion=10.0

## Usage
在需要使用 `ZVProgressHUD`时，使用 `import ZVProgressHUD`导入便可以使用

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



