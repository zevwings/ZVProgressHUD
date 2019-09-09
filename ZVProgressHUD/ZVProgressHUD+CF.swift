//
//  ZVProgressHUD+CF.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2019/9/9.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

import Foundation

public extension ZVProgressHUD {
    
    /// show a toast
    ///
    /// - Parameters:
    ///   - text: toast content
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showText(_ text: String,
                        in superview: UIView? = nil,
                        on position: Position = .bottom,
                        delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.showText(text, in: superview, on: position, delay: delayTimeInterval)
    }
    
    /// show a success message
    ///
    /// - Parameters:
    ///   - title: the success message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showSuccess(with title: String = "",
                           in superview: UIView? = nil,
                           on position: Position = .center,
                           delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.showSuccess(with: title, in: superview, on: position, delay: delayTimeInterval)
    }
    
    
    /// show a error message
    ///
    /// - Parameters:
    ///   - title: the error message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    
    class func showError(with title: String = "",
                         in superview: UIView? = nil,
                         on position: Position = .center,
                         delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.showError(with: title, in: superview, on: position, delay: delayTimeInterval)
    }
    
    /// show a warning message
    ///
    /// - Parameters:
    ///   - title: the warning message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showWarning(with title: String = "",
                           in superview: UIView? = nil,
                           on position: Position = .center,
                           delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.showWarning(with: title, in: superview, on: position, delay: delayTimeInterval)
    }
    
    /// show a waiting alert
    ///
    /// - Parameters:
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func show(with title: String = "",
                    in superview: UIView? = nil,
                    on position: Position = .center,
                    delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.show(with: title, in: superview, on: position, delay: delayTimeInterval)
    }
    
    /// show the progress of some task
    ///
    /// - Parameters:
    ///   - progress: the progress of your task
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showProgress(_ progress: Float,
                            title: String = "",
                            in superview: UIView? = nil,
                            on position: Position = .center,
                            delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.showProgress(progress, title: title, in: superview, on: position, delay: delayTimeInterval)
    }
    
    /// show a custom image
    ///
    /// - Parameters:
    ///   - image: your image
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - dismissAtomically: if `true` the `HUD` will dissmiss atomically
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showImage(_ image: UIImage,
                         title: String = "",
                         in superview: UIView? = nil,
                         on position: Position = .center,
                         dismissAtomically: Bool = true,
                         delay delayTimeInterval: TimeInterval = 0.0) {
        shared.showImage(image, title: title, in: superview, on: position, dismissAtomically: dismissAtomically, delay: delayTimeInterval)
    }
    
    /// show the animation waiting alert
    ///
    /// - Parameters:
    ///   - images: animation image array
    ///   - duration: animation duration @see UIImage
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showAnimation(_ images: [UIImage],
                             duration: TimeInterval = 0.0,
                             title: String = "",
                             in superview: UIView? = nil,
                             on position: Position = .center,
                             delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.showAnimation(images, duration: duration, title: title, in: superview, on: position, delay: delayTimeInterval)
    }
    
    /// show custom display type @see ZVProgressHUD.DisplayType
    ///
    /// - Parameters:
    ///   - displayType: ZVProgressHUD.DisplayType
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func show(with displayType: DisplayType,
                    in superview: UIView? = nil,
                    on position: Position = .center,
                    delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.show(with: displayType, in: superview, on: position, delay: delayTimeInterval)
    }
    
    /// dismiss the hud
    ///
    /// - Parameters:
    ///   - delay: the view will dissmiss delay the `delayTimeInterval`
    ///   - completion: dismiss completion handler
    class func dismiss(delay: TimeInterval = 0.0, completion: ZVProgressHUDCompletionHandler? = nil) {
        shared.dismiss(with: delay, completion: completion)
    }
}
