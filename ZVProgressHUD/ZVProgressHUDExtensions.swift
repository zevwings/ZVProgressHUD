//
//  ProgressHUD+Operations.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2019/9/29.
//  Copyright © 2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

// MARK: - Configuration

public extension ZVProgressHUD {

    class func setDisplayStyle(_ displayStyle: DisplayStyle) {
        shared.configuration.displayStyle = displayStyle
    }
    
    class func setMaskType(_ maskType: MaskType) {
        shared.configuration.maskType = maskType
    }
    
    class func setCornerRadius(_ cornerRadius: CGFloat) {
        shared.configuration.cornerRadius = cornerRadius
    }
    
    class func setOffset(_ offset: UIOffset) {
        shared.configuration.offset = offset
    }
    
    class func setTitleLabelFont(_ font: UIFont) {
        shared.configuration.titleLabelFont = font
    }
    
    class func setTitleLabelColor(_ color: UIColor?) {
        shared.configuration.titleLabelColor = color
    }
    
    class func setProgressLabelFont(_ font: UIFont) {
        shared.configuration.progressLabelFont = font
    }
    
    class func setProgressLabelColor(_ color: UIColor?) {
        shared.configuration.progressLabelColor = color
    }
    
    class func setProgressLabelHidden(_ isProgressLabelHidden: Bool) {
        shared.configuration.isProgressLabelHidden = isProgressLabelHidden
    }
    
    class func setStrokeWidth(_ strokeWidth: CGFloat) {
        shared.configuration.strokeWidth = strokeWidth
    }

    class func setIndicatorSize(_ size: CGSize) {
        shared.configuration.indicatorSize = size
    }
    
    class func setAnimationType(_ animationType: ZVIndicatorView.AnimationType) {
        shared.configuration.animationType = animationType
    }
    
    class func setContentInsets(_ indets: UIEdgeInsets) {
        shared.configuration.contentInsets = indets
    }
    
    class func setTitleEdgeInsets(_ indets: UIEdgeInsets) {
        shared.configuration.titleEdgeInsets = indets
    }
    
    class func setIndicatorEdgeInsets(_ indets: UIEdgeInsets) {
        shared.configuration.indicatorEdgeInsets = indets
    }
    
    class func setLogo(_ logo: UIImage?) {
        shared.configuration.logo = logo
    }

    class func setLogoSize(_ size: CGSize) {
        shared.configuration.logoSize = size
    }
}

// MARK: - Props

public extension ZVProgressHUD {
    
    class func setMaxSupportedWindowLevel(_ windowLevel: UIWindow.Level) {
        shared.maxSupportedWindowLevel = windowLevel
    }
    
    class func setFadeInAnimationTimeInterval(_ timeInterval: TimeInterval) {
        shared.fadeInAnimationTimeInterval = timeInterval
    }
    
    class func setFadeOutAnimationTImeInterval(_ timeInterval: TimeInterval) {
        shared.fadeOutAnimationTImeInterval = timeInterval
    }
    
    class func setMinimumDismissTimeInterval(_ timeInterval: TimeInterval) {
        shared.minimumDismissTimeInterval = timeInterval
    }
    
    class func setMaximumDismissTimeInterval(_ timeInterval: TimeInterval) {
        shared.maximumDismissTimeInterval = timeInterval
    }
    
    class func setMaximumContentSize(_ size: CGSize) {
        shared.maximumContentSize = size
    }
    
}

// MARK: - Handle

public extension ZVProgressHUD {
    
    /// show a toast
    ///
    /// - Parameters:
    ///   - text: toast content
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showText(
        _ text: String,
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: .text(value: text),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show a success message
    ///
    /// - Parameters:
    ///   - title: the success message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showSuccess(
        with title: String = "",
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: .indicator(title: title, type: .success),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show a error message
    ///
    /// - Parameters:
    ///   - title: the error message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showError(
        with title: String = "",
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: .indicator(title: title, type: .error),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show a warning message
    ///
    /// - Parameters:
    ///   - title: the warning message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showWarning(
        with title: String = "",
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: .indicator(title: title, type: .warning),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show a waiting alert
    ///
    /// - Parameters:
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func show(
        with title: String = "",
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        let animationType: ZVIndicatorView.AnimationType
        if let configuration = configuration {
            animationType = configuration.animationType
        } else {
            animationType = shared.configuration.animationType
        }
        shared.internalShow(
            displayType: .indicator(title: title, type: .indicator(style: animationType)),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show the progress of some task
    ///
    /// - Parameters:
    ///   - progress: the progress of your task
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showProgress(
        _ progress: Float,
        title: String = "",
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: .indicator(title: title, type: .progress(value: progress)),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show a custom image
    ///
    /// - Parameters:
    ///   - image: your image
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - dismissAtomically: if `true` the `HUD` will dissmiss atomically
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showImage(
        _ image: UIImage,
        title: String = "",
        in superview: UIView? = nil,
        dismissAtomically: Bool = true,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: .indicator(title: title, type: .image(value: image, dismissAtomically: dismissAtomically)),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show the animation waiting alert
    ///
    /// - Parameters:
    ///   - images: animation image array
    ///   - duration: animation duration @see UIImage
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showAnimation(
        _ images: [UIImage],
        duration: TimeInterval = 0.0,
        title: String = "",
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        if images.isEmpty { return }

        let animationDuration: TimeInterval
        if duration == 0 {
            animationDuration = Double(images.count) * 0.1
        } else {
            animationDuration = duration
        }

        shared.internalShow(
            displayType: .indicator(title: title, type: .animation(value: images, duration: animationDuration)),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show the animation waiting alert
    ///
    /// - Parameters:
    ///   - images: animation image array
    ///   - duration: animation duration @see UIImage
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showCustomView(
        _ view: UIView,
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: .customeView(view: view),
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// show custom display type @see ZVProgressHUD.DisplayType
    ///
    /// - Parameters:
    ///   - displayType: ZVProgressHUD.DisplayType
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func show(
        with displayType: DisplayType,
        in superview: UIView? = nil,
        delay delayTimeInterval: TimeInterval = 0.0,
        with configuration: Configuration? = nil
    ) {
        shared.internalShow(
            displayType: displayType,
            in: superview,
            delay: delayTimeInterval,
            with: configuration
        )
    }
    
    /// dismiss the hud
    ///
    /// - Parameters:
    ///   - delay: the view will dissmiss delay the `delayTimeInterval`
    ///   - completion: dismiss completion handler
    class func dismiss(
        delay: TimeInterval = 0.0,
        completion: CompletionHandler? = nil
    ) {
        shared.internalDismiss(with: delay, completion: completion)
    }
}

#endif
