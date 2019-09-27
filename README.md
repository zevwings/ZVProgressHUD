# ZVProgressHUD
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
![CocoaPods Compatible](https://img.shields.io/badge/pod-1.0.0-4BC51D.svg?style=flat)[](https://cocoapods.org)
![Platform](https://img.shields.io/badge/platform-ios-9F9F9F.svg)[](http://cocoadocs.org/docsets/Alamofire)


ZVProgressHUD is a pure-swift and wieldy HUD.

[中文文档](https://github.com/zevwings/ZVProgressHUD/blob/master/README_CN.md)

## Requirements

- iOS 8.0+ 
- Swift 5.0

## Appetize
You can run this demo at [Appetize](https://appetize.io/embed/39txw9h5d7mrkckm6f9vp9mn2r?device=iphone5s&scale=100&autoplay=false&orientation=portrait&deviceColor=white)


## Installation
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
You can use `import ProgressHUD` when you needed to use `ZVProgressHUD`.

### Showing a HUD
When you start a task, You can using following code:

```
// class method
ProgressHUD.shared.show()
// or you can use instance method 
let hud = ProgressHUD()
hud.show()
```

you can custom animation type, use following code:

```
/// the animation type, default is flat
public enum AnimationType {
	case flat		
	case native	
}

/// this code will modify global animation type.
ProgressHUD.shared.animationType = .flat
```

when you want modify the superview of `ZVProgressHUD`, use the following code:

```
// the HUD will show delay 0.0
ZVProgressHUD.show(with: "Loading", in: superview, delay: 0.0)
```

### Dismiss a HUD
you can use a simple code to close HUD.

```
// class method
ProgressHUD.shared.dismiss()
// or you can use instance method 
hud.dismiss()
```

### Showing a confirm
when you want show a comfirm infomation, use the following code:

```
ProgressHUD.shared.showError(with: "error")
ProgressHUD.shared.showSuccess(with: "success")
ProgressHUD.shared.showWarning(with: "warning")
```

### Showing a custom image 
you also can show a custom image, use the following code:

```
let image = UIImage(named: "smile")
ProgressHUD.shared.showImage(image!)
// or
ProgressHUD.shared.showImage(image!, title: "smile everyday!")
```

### Showing a custom animation
you can use the following code to custom a animation indicator.

```
var images = [UIImage]()
for index in 1 ... 3 {
    let image = UIImage(named: "loading_0\(index)")
    images.append(image!)
}

ProgressHUD.shared.showAnimation(images)
```

### Showing a progress

```
ProgressHUD.shared.showProgress(0.0, title: "Progress")
```

### Custom logo

```
// set logoSize of HUD, CGSize(30, 30)
class var logoSize: CGSize 
// set logo image of HUD, default is nil
class var logo: UIImage 
```

### Custom properties

```
// set displayStyle type of HUD, default is dark.
class var displayStyle: DisplayStyle 

// set mask type of HUD
class var maskType: MaskType 

// the cornerRadius of basic view   
class var cornerRadius: CGFloat 

// the offset of basic view
class var offset: UIOffset 

// the font of title label
class var font: UIFont 

// you can change the line width of indicator when animation type is `flat`
class var strokeWith: CGFloat 

// the size of indicator
class var indicatorSize: CGSize 

// the animation type, default is `flat`
class var animationType: IndicatorView.AnimationType 

```

### Custom Insets of content

```
class var contentInsets: UIEdgeInsets 

class var titleEdgeInsets: UIEdgeInsets 

class var indicatorEdgeInsets: UIEdgeInsets 
```

### Notifications

you can add an observer to do something from hud's notifications.

```
extension NSNotification.Name {
	
	 // this hud did disappear
    public static let ProgressHUDReceivedTouchUpInsideEvent: Notification.Name

	 // this hud will appear
    public static let ProgressHUDWillAppear: Notification.Name

	 // this hud did appear
    public static let ProgressHUDDidAppear: Notification.Name

	 // this hud will disappear
    public static let ProgressHUDWillDisappear: Notification.Name

	 // this hud did disappear
    public static let ProgressHUDDidDisappear: Notification.Name
}
```

## License
`ZVProgressHUD` distributed under the terms and conditions of the [MIT License](https://github.com/zevwings/ZVProgressHUD/blob/master/LICENSE)



