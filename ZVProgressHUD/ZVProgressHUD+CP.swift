//
//  ZVProgressHUD+CP.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2019/9/9.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

import Foundation

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
    
    class var maxSupportedWindowLevel: UIWindow.Level {
        get {
            return shared.maxSupportedWindowLevel
        }
        set {
            shared.maxSupportedWindowLevel = newValue
        }
    }
    
    class var fadeInAnimationTimeInterval: TimeInterval {
        get {
            return shared.fadeInAnimationTimeInterval
        }
        set {
            shared.fadeInAnimationTimeInterval = newValue
        }
    }
    
    class var fadeOutAnimationTImeInterval: TimeInterval {
        get {
            return shared.fadeOutAnimationTImeInterval
        }
        set {
            shared.fadeOutAnimationTImeInterval = newValue
        }
    }
    
    class var minimumDismissTimeInterval: TimeInterval {
        get {
            return shared.minimumDismissTimeInterval
        }
        set {
            shared.minimumDismissTimeInterval = newValue
        }
    }
    
    class var maximumDismissTimeInterval: TimeInterval {
        get {
            return shared.maximumDismissTimeInterval
        }
        set {
            shared.maximumDismissTimeInterval = newValue
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
    
    class var animationType: ZVIndicatorView.AnimationType {
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
