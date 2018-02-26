//
//  ZVProgressHUD+Public.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2018/2/25.
//  Copyright © 2018年 zevwings. All rights reserved.
//

import Foundation

// MARK: - 公共类属性设置

public extension ZVProgressHUD {
    
    class var displayStyle: DisplayStyle {
        get {
            return shared.displayStyle
        }
        set {
            shared.displayStyle = newValue
        }
    }
    
    class var maskType: MaskType {
        get {
            return shared.maskType
        }
        set {
            shared.maskType = newValue
        }
    }
    
    class var cornerRadius: CGFloat {
        get {
            return shared.cornerRadius
        }
        set {
            shared.cornerRadius = newValue
        }
    }
    
    class var offset: UIOffset {
        get {
            return shared.offset
        }
        set {
            shared.offset = newValue
        }
    }
    
    class var font: UIFont {
        get {
            return shared.font
        }
        set {
            shared.font = newValue
        }
    }
    
    class var strokeWith: CGFloat {
        get {
            return shared.strokeWith
        }
        set {
            shared.strokeWith = newValue
        }
    }
    
    class var indicatorSize: CGSize {
        get {
            return shared.indicatorSize
        }
        set {
            shared.indicatorSize = newValue
        }
    }
    
    class var animationType: IndicatorView.AnimationType {
        get {
            return shared.animationType
        }
        set {
            shared.animationType = newValue
        }
    }
    
    class var contentInsets: UIEdgeInsets {
        get {
            return shared.contentInsets
        }
        set {
            shared.contentInsets =  newValue
        }
    }
    
    class var titleEdgeInsets: UIEdgeInsets {
        get {
            return shared.titleEdgeInsets
        }
        set {
            shared.titleEdgeInsets = newValue
        }
    }
    
    class var indicatorEdgeInsets: UIEdgeInsets {
        get {
            return shared.indicatorEdgeInsets
        }
        set {
            shared.indicatorEdgeInsets = newValue
        }
    }
}

// MARK: - 公共显示/隐藏

public extension ZVProgressHUD {
    
    class func show(label title: String) {
        shared.show(with: .text(title: title))
    }
    
    class func showSuccess(with title: String = "") {
        shared.show(with: .indicator(title: title, type: .success))
    }
    
    class func showError(with title: String = "") {
        shared.show(with: .indicator(title: title, type: .error))
    }
    
    
    class func showWarning(with title: String = "") {
        shared.show(with: .indicator(title: title, type: .warning))
    }
    
    class func show(with title: String = "") {
        shared.show(with: .indicator(title: title, type: .indicator(style: animationType)))
    }
    
    class func show(progress: Float, title: String = "") {
        shared.show(with: .indicator(title: title, type: .progress(value: progress)))
    }
    
    class func show(image: UIImage, title: String = "", dismissAtomically: Bool = true) {
        shared.show(with: .indicator(title: title, type: .image(value: image, dismissAtomically: dismissAtomically)))
    }
    
    class func show(animation images: [UIImage], duration: TimeInterval = 0.0, title: String = "") {
        
        guard images.count > 0 else { return }
        var d = duration
        if d == 0 {
            d = Double(images.count) * 0.1
        }
        let displayType: DisplayType = .indicator(title: title, type: .custom(animationImages: images, duration: d))
        shared.show(with: displayType)
    }
    
    class func dismiss(delay: TimeInterval = 0.0, completion: (() -> ())? = nil) {
        shared.dismiss(with: delay, completion: completion)
    }
}
