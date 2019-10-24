//
//  ProgressHUD+Operations.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2019/9/29.
//  Copyright © 2019 zevwings. All rights reserved.
//

import UIKit

// MARK: - Handle

public extension ProgressHUD {
    
    /// show a toast
    ///
    /// - Parameters:
    ///   - text: toast content
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    func showText(
        _ text: String,
        in superview: UIView? = nil,
        on position: Position = .bottom,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        show(
            with: .text(value: text),
            in: superview,
            on: position,
            delay: delayTimeInterval
        )
    }
    
    /// show a success message
    ///
    /// - Parameters:
    ///   - title: the success message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    func showSuccess(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        show(
            with: .indicator(title: title, type: .success),
            in: superview,
            on: position,
            delay: delayTimeInterval
        )
    }
    
    /// show a error message
    ///
    /// - Parameters:
    ///   - title: the error message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    func showError(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        show(
            with: .indicator(title: title, type: .error),
            in: superview,
            on: position,
            delay: delayTimeInterval
        )
    }
    
    /// show a warning message
    ///
    /// - Parameters:
    ///   - title: the warning message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    func showWarning(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        show(
            with: .indicator(title: title, type: .warning),
            in: superview,
            on: position,
            delay: delayTimeInterval
        )
    }
    
    /// show a waiting alert
    ///
    /// - Parameters:
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    func show(
        with title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        show(
            with: .indicator(title: title, type: .indicator(style: animationType)),
            in: superview,
            on: position,
            delay: delayTimeInterval
        )
    }
    
    /// show the progress of some task
    ///
    /// - Parameters:
    ///   - progress: the progress of your task
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    func showProgress(
        _ progress: Float,
        title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        show(
            with: .indicator(title: title, type: .progress(value: progress)),
            in: superview,
            on: position,
            delay: delayTimeInterval
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
    func showImage(
        _ image: UIImage,
        title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        dismissAtomically: Bool = true,
        delay delayTimeInterval: TimeInterval = 0.0
    ) {
        show(
            with: .indicator(title: title, type: .image(value: image, dismissAtomically: dismissAtomically)),
            in: superview,
            on: position,
            delay: delayTimeInterval
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
    func showAnimation(
        _ images: [UIImage],
        duration: TimeInterval = 0.0,
        title: String = "",
        in superview: UIView? = nil,
        on position: Position = .center,
        delay delayTimeInterval: TimeInterval = 0.0) {
        
        if images.isEmpty { return }
        
        let animationDuration: TimeInterval
        if duration == 0 {
            animationDuration = Double(images.count) * 0.1
        } else {
            animationDuration = duration
        }
        
        show(
            with: .indicator(title: title, type: .animation(value: images, duration: animationDuration)),
            in: superview,
            on: position,
            delay: delayTimeInterval
        )
    }
    
    /// show custom display type @see ZVProgressHUD.DisplayType
    ///
    /// - Parameters:
    ///   - displayType: ZVProgressHUD.DisplayType
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    func show(
        with displayType: DisplayType,
        in superview: UIView? = nil,
        on position: Position,
        delay delayTimeInterval: TimeInterval = 0
    ) {
        internalShow(
            with: displayType,
            in: superview,
            on: position,
            delay: delayTimeInterval
        )
    }
    
    /// dismiss the hud
    ///
    /// - Parameters:
    ///   - delay: the view will dissmiss delay the `delayTimeInterval`
    ///   - completion: dismiss completion handler
    func dismiss(
        with delayTimeInterval: TimeInterval = 0,
        completion: ProgressHUDCompletionHandler? = nil
    ) {
        internalDismiss(
            with: delayTimeInterval,
            completion: completion
        )
    }
}
