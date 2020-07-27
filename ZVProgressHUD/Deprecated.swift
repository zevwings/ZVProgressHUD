//
//  ZVProgressHUD+CF.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2019/9/9.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

@available(*, deprecated, renamed: "ZVProgressHUD", message: "renamed ProgressHUD will remove in future")
public typealias ProgressHUD = ZVProgressHUD

public extension ZVProgressHUD {
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var displayStyle: DisplayStyle {
        get {
            return shared.displayStyle
        }
        set {
            shared.displayStyle = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var maskType: MaskType {
        get {
            return shared.maskType
        }
        set {
            shared.maskType = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var maxSupportedWindowLevel: UIWindow.Level {
        get {
            return shared.maxSupportedWindowLevel
        }
        set {
            shared.maxSupportedWindowLevel = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var fadeInAnimationTimeInterval: TimeInterval {
        get {
            return shared.fadeInAnimationTimeInterval
        }
        set {
            shared.fadeInAnimationTimeInterval = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var fadeOutAnimationTImeInterval: TimeInterval {
        get {
            return shared.fadeOutAnimationTImeInterval
        }
        set {
            shared.fadeOutAnimationTImeInterval = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var minimumDismissTimeInterval: TimeInterval {
        get {
            return shared.minimumDismissTimeInterval
        }
        set {
            shared.minimumDismissTimeInterval = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var maximumDismissTimeInterval: TimeInterval {
        get {
            return shared.maximumDismissTimeInterval
        }
        set {
            shared.maximumDismissTimeInterval = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var cornerRadius: CGFloat {
        get {
            return shared.cornerRadius
        }
        set {
            shared.cornerRadius = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var offset: UIOffset {
        get {
            return shared.offset
        }
        set {
            shared.offset = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var font: UIFont {
        get {
            return shared.font
        }
        set {
            shared.font = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var strokeWith: CGFloat {
        get {
            return shared.strokeWith
        }
        set {
            shared.strokeWith = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var indicatorSize: CGSize {
        get {
            return shared.indicatorSize
        }
        set {
            shared.indicatorSize = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var animationType: AnimationType {
        get {
            return shared.animationType
        }
        set {
            shared.animationType = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var contentInsets: UIEdgeInsets {
        get {
            return shared.contentInsets
        }
        set {
            shared.contentInsets =  newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var titleEdgeInsets: UIEdgeInsets {
        get {
            return shared.titleEdgeInsets
        }
        set {
            shared.titleEdgeInsets = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var indicatorEdgeInsets: UIEdgeInsets {
        get {
            return shared.indicatorEdgeInsets
        }
        set {
            shared.indicatorEdgeInsets = newValue
        }
    }
    
    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var logo: UIImage? {
        get {
            return shared.logo
        }
        set {
            shared.logo = newValue
        }
    }

    @available(*, deprecated, message: "this attribute will remove in future, use singleton instead.")
    class var logoSize: CGSize {
        get {
            return shared.logoSize
        }
        set {
            shared.logoSize = newValue
        }
    }
}

public extension ZVProgressHUD {
    
    /// show a toast
    ///
    /// - Parameters:
    ///   - text: toast content
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func showText(
        _ text: String,
        in superview: UIView? = nil,
        on position: Position = .bottom,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.showText(text,
                        in: superview,
                        on: position,
                        delay: delayTimeInterval)
    }
    
    /// show a success message
    ///
    /// - Parameters:
    ///   - title: the success message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func showSuccess(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.showSuccess(with: title,
                           in: superview,
                           on: position,
                           delay: delayTimeInterval)
    }
    
    /// show a error message
    ///
    /// - Parameters:
    ///   - title: the error message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func showError(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.showError(with: title,
                         in: superview,
                         on: position,
                         delay: delayTimeInterval)
    }
    
    /// show a warning message
    ///
    /// - Parameters:
    ///   - title: the warning message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func showWarning(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.showWarning(with: title,
                           in: superview,
                           on: position,
                           delay: delayTimeInterval)
    }
    
    /// show a waiting alert
    ///
    /// - Parameters:
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func show(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.show(with: title,
                    in: superview,
                    on: position,
                    delay: delayTimeInterval)
    }
    
    /// show the progress of some task
    ///
    /// - Parameters:
    ///   - progress: the progress of your task
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func showProgress(
        _ progress: Float,
        title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.showProgress(progress,
                            title: title,
                            in: superview,
                            on: position,
                            delay: delayTimeInterval)
    }
    
    /// show a custom image
    ///
    /// - Parameters:
    ///   - image: your image
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - dismissAtomically: if `true` the `HUD` will dissmiss atomically
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func showImage(
        _ image: UIImage,
        title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        dismissAtomically: Bool = true,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.showImage(image,
                         title: title,
                         in: superview,
                         on: position,
                         dismissAtomically: dismissAtomically,
                         delay: delayTimeInterval)
    }
    
    /// show the animation waiting alert
    ///
    /// - Parameters:
    ///   - images: animation image array
    ///   - duration: animation duration @see UIImage
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func showAnimation(
        _ images: [UIImage],
        duration: TimeInterval = 0.0,
        title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.showAnimation(images,
                             duration: duration,
                             title: title,
                             in: superview,
                             on: position,
                             delay: delayTimeInterval)
    }
    
    /// show custom display type @see ZVProgressHUD.DisplayType
    ///
    /// - Parameters:
    ///   - displayType: ZVProgressHUD.DisplayType
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func show(
        with displayType: DisplayType,
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        shared.show(with: displayType,
                    in: superview,
                    on: position,
                    delay: delayTimeInterval)
    }
    
    /// dismiss the hud
    ///
    /// - Parameters:
    ///   - delay: the view will dissmiss delay the `delayTimeInterval`
    ///   - completion: dismiss completion handler
    @available(*, deprecated, message: "this method will remove in future, use singleton instead.")
    class func dismiss(
        delay: TimeInterval = 0.0,
        completion: ZVProgressHUDCompletionHandler? = nil
    ) {
        shared.dismiss(with: delay, completion: completion)
    }
}

#endif
