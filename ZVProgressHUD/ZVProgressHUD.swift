//
//  ZVProgressHUD.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/12.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

public typealias ZVProgressHUDCompletionHandler = () -> Void

public extension Notification.Name {
    
    static let ZVProgressHUDReceivedTouchUpInsideEvent = Notification.Name("com.zevwings.progresshud.touchup.inside")
    
    static let ZVProgressHUDWillAppear = Notification.Name("com.zevwings.progresshud.willAppear")
    static let ZVProgressHUDDidAppear = Notification.Name("com.zevwings.progresshud.didAppear")
    
    static let ZVProgressHUDWillDisappear = Notification.Name("com.zevwings.progresshud.willDisappear")
    static let ZVProgressHUDDidDisappear = Notification.Name("com.zevwings.progresshud.didDisappear")
}

open class ZVProgressHUD: UIControl {
    
    private struct AnimationDuration {
        static let fadeIn: TimeInterval = 0.15
        static let fadeOut: TimeInterval = 0.15
        static let keyboard: TimeInterval = 0.25
    }

    /// the position of the `HUD`
    public enum Position {
        case top
        case center
        case bottom
    }

    // MARK: Public
    
    public static let shared = ZVProgressHUD(frame: .zero)
    
    public var displayStyle: DisplayStyle = .light
    public var maskType: MaskType = .none
    public var position:Position = .center
    
    public var maxSupportedWindowLevel: UIWindow.Level = .normal
    public var fadeInAnimationTimeInterval: TimeInterval = AnimationDuration.fadeIn
    public var fadeOutAnimationTImeInterval: TimeInterval = AnimationDuration.fadeOut
    
    public var minimumDismissTimeInterval: TimeInterval = 3.0
    public var maximumDismissTimeInterval: TimeInterval = 10.0
    
    public var cornerRadius: CGFloat = 8.0
    public var offset: UIOffset = .zero
    
    public var font: UIFont = .systemFont(ofSize: 16.0)
    
    public var strokeWith: CGFloat = 3.0
    public var animationType: AnimationType = .flat

    public var contentInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    public var titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
    public var indicatorEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

    public var indicatorSize = CGSize(width: 48.0, height: 48.0)

    public var logo: UIImage?
    public var logoSize = CGSize(width: 30.0, height: 30.0)
    
    public var completionHandler: ZVProgressHUDCompletionHandler?
    
    // MARK: Private
    
    private var _fadeOutTimer: Timer?
    private var _fadeInDeleyTimer: Timer?
    private var _fadeOutDelayTimer: Timer?

    private var displayType: DisplayType?
    
    private var containerView: UIView?

    // MARK: UI
    
    private lazy var maskLayer: CALayer = { [unowned self] in
        let maskLayer = CALayer()
        return maskLayer
    }()
    
    private lazy var baseView: UIControl = {
        let baseView = UIControl()
        baseView.backgroundColor = .clear
        baseView.alpha = 0
        baseView.layer.masksToBounds = true
        return baseView
    }()
    
    private lazy var indicatorView: ZVIndicatorView = {
        let indicatorView = ZVIndicatorView()
        indicatorView.isUserInteractionEnabled = false
        indicatorView.alpha = 0
        return indicatorView
    }()
    
    private lazy var titleLabel: UILabel = { [unowned self] in
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = self.font
        titleLabel.backgroundColor = .clear
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.alpha = 0
        return titleLabel
    }()
    
    private lazy var logoView: UIImageView = { [unowned self] in
        
        let logoView = UIImageView(frame: .zero)
        logoView.tintColor = self.displayStyle.foregroundColor
        logoView.contentMode = .scaleAspectFit
        logoView.layer.masksToBounds = true
        return logoView
    }()
    
    // MARK: Init
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = .clear
        
        addTarget(self, action: #selector(overlayRecievedTouchUpInsideEvent(_:)), for: .touchUpInside)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Operations

extension ZVProgressHUD {
    
    func internalShow(
        with displayType: DisplayType,
        in superview: UIView? = nil,
        on position: Position,
        delay delayTimeInterval: TimeInterval = 0
    ) {
        OperationQueue.main.addOperation { [weak self] in
            
            guard let strongSelf = self else { return }

            if strongSelf.superview != superview {
                strongSelf.indicatorView.removeFromSuperview()
                strongSelf.titleLabel.removeFromSuperview()
                strongSelf.baseView.removeFromSuperview()
                strongSelf.logoView.removeFromSuperview()
                strongSelf.removeFromSuperview()
            }
            
            strongSelf.fadeOutTimer = nil
            strongSelf.fadeInDeleyTimer = nil
            strongSelf.fadeOutDelayTimer = nil
            
            strongSelf.position = position

            if let superview = superview {
                strongSelf.containerView = superview
            } else {
                strongSelf.containerView = strongSelf.getKeyWindow()
            }
            
            // set property form displayType
            strongSelf.displayType = displayType
            strongSelf.titleLabel.text = displayType.title
            strongSelf.titleLabel.isHidden = displayType.title.isEmpty
            strongSelf.indicatorView.indcatorType = displayType.indicatorType
            
            strongSelf.updateViewHierarchy()

            strongSelf.titleLabel.font = strongSelf.font
            strongSelf.indicatorView.strokeWidth = strongSelf.strokeWith
            strongSelf.baseView.layer.cornerRadius = strongSelf.cornerRadius
            strongSelf.baseView.backgroundColor = strongSelf.displayStyle.backgroundColor
            strongSelf.logoView.image = strongSelf.logo
            
            // set property form maskType
            strongSelf.isUserInteractionEnabled = strongSelf.maskType.isUserInteractionEnabled
            strongSelf.maskLayer.backgroundColor = strongSelf.maskType.backgroundColor
            
            // set property form displayStyle
            strongSelf.titleLabel.textColor = strongSelf.displayStyle.foregroundColor
            strongSelf.indicatorView.tintColor = strongSelf.displayStyle.foregroundColor
            
            // display
            if delayTimeInterval > 0 {
                strongSelf.fadeInDeleyTimer = Timer.scheduledTimer(
                    timeInterval: delayTimeInterval,
                    target: strongSelf,
                    selector: #selector(strongSelf.fadeInTimerAction(_:)),
                    userInfo: nil,
                    repeats: false
                )
            } else {
                strongSelf.fadeIn()
            }
        }
    }

    func internalDismiss(
        with delayTimeInterval: TimeInterval = 0,
        completion: ZVProgressHUDCompletionHandler? = nil
    ) {
        
        if delayTimeInterval > 0 {
            fadeOutDelayTimer = Timer.scheduledTimer(
                timeInterval: delayTimeInterval,
                target: self,
                selector: #selector(fadeOutTimerAction(_:)),
                userInfo: completion,
                repeats: false
            )
        } else {
            fadeOut(with: completion)
        }
    }
    
    @objc private func fadeInTimerAction(_ timer: Timer?) {
        fadeIn()
    }
    
    @objc private func fadeIn() {
        
        guard let displayType = displayType else { return }
        
        //swiftlint:disable:next line_length
        let displayTimeInterval = displayType.getDisplayTimeInterval(minimumDismissTimeInterval, maximumDismissTimeInterval)

        updateSubviews()
        
        let keybordHeight = getVisibleKeyboardHeight()
        placeSubviews(keybordHeight)
        
        if self.alpha != 1.0 {
            
            // send the notification HUD will appear
            NotificationCenter.default.post(name: .ZVProgressHUDWillAppear, object: self, userInfo: nil)
            
            let animationBlock = {
                self.alpha = 1.0
                self.baseView.alpha = 1.0
                self.indicatorView.alpha = 1.0
                self.titleLabel.alpha = 1.0
            }
            
            let completionBlock = {
                
                guard self.alpha == 1.0 else { return }
                
                self.fadeInDeleyTimer = nil
                
                // register keyboard notification and orientation notification
                self.registerNotifications()
                
                // send the notification HUD did appear
                NotificationCenter.default.post(name: .ZVProgressHUDDidAppear, object: self, userInfo: nil)
                
                if displayTimeInterval > 0 {
                    self.fadeOutTimer = Timer.scheduledTimer(
                        timeInterval: displayTimeInterval,
                        target: self,
                        selector: #selector(self.fadeOutTimerAction(_:)),
                        userInfo: nil,
                        repeats: false
                    )
                    RunLoop.main.add(self.fadeOutTimer!, forMode: RunLoop.Mode.common)
                } else {
                    if displayType.indicatorType.progressValueChecker.0 &&
                        displayType.indicatorType.progressValueChecker.1 >= 1.0 {
                        self.dismiss()
                    }
                }
            }
            
            if fadeInAnimationTimeInterval > 0 {
                UIView.animate(
                    withDuration: fadeInAnimationTimeInterval,
                    delay: 0,
                    options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState],
                    animations: {
                        animationBlock()
                    }, completion: { _ in
                        completionBlock()
                    }
                )
            } else {
                animationBlock()
                completionBlock()
            }
        } else {
            
            if displayTimeInterval > 0 {
                fadeOutTimer = Timer.scheduledTimer(
                    timeInterval: displayTimeInterval,
                    target: self,
                    selector: #selector(self.fadeInTimerAction(_:)),
                    userInfo: nil,
                    repeats: false
                )
                RunLoop.main.add(fadeOutTimer!, forMode: RunLoop.Mode.common)
            } else {
                if displayType.indicatorType.progressValueChecker.0 &&
                    displayType.indicatorType.progressValueChecker.1 >= 1.0 {
                    fadeOut()
                }
            }
        }
    }

    @objc private func fadeOutTimerAction(_ timer: Timer?) {
        
        let completion = timer?.userInfo as? ZVProgressHUDCompletionHandler
        fadeOut(with: completion)
    }

    @objc private func fadeOut(with completion: ZVProgressHUDCompletionHandler? = nil) {
        
        OperationQueue.main.addOperation { [weak self] in
            
            guard let strongSelf = self else { return }
            
            // send the notification HUD will disAppear
            NotificationCenter.default.post(name: .ZVProgressHUDWillDisappear, object: self, userInfo: nil)
            
            let animationBlock = {
                strongSelf.alpha = 0
                strongSelf.baseView.alpha = 0
                strongSelf.baseView.backgroundColor = .clear
                strongSelf.indicatorView.alpha = 0
                strongSelf.titleLabel.alpha = 0
            }
            
            let completionBlock = {
                
                guard strongSelf.alpha == 0 else { return }
                
                strongSelf.fadeOutTimer = nil
                strongSelf.fadeOutDelayTimer = nil
                
                // update view hierarchy
                strongSelf.indicatorView.removeFromSuperview()
                strongSelf.titleLabel.removeFromSuperview()
                strongSelf.baseView.removeFromSuperview()
                strongSelf.logoView.removeFromSuperview()
                strongSelf.removeFromSuperview()
                
                strongSelf.containerView = nil
                
                // remove notifications from self
                NotificationCenter.default.removeObserver(strongSelf)
                
                // send the notification HUD did disAppear
                NotificationCenter.default.post(name: .ZVProgressHUDDidDisappear, object: self, userInfo: nil)
                
                // execute completion handler
                completion?()
                strongSelf.completionHandler?()
            }
            
            if strongSelf.fadeOutAnimationTImeInterval > 0 {
                UIView.animate(
                    withDuration: strongSelf.fadeOutAnimationTImeInterval,
                    delay: 0,
                    options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState],
                    animations: {
                        animationBlock()
                    }, completion: { _ in
                        completionBlock()
                    }
                )
            } else {
                animationBlock()
                completionBlock()
            }
            
            strongSelf.setNeedsDisplay()
        }
    }
}

// MARK: - Update Subviews

private extension ZVProgressHUD {
    
    func updateViewHierarchy() {
        
        if superview == nil {
            containerView?.addSubview(self)
        } else {
            containerView?.bringSubviewToFront(self)
        }
        
        if maskLayer.superlayer == nil {
            layer.addSublayer(maskLayer)
        }
        
        if baseView.superview == nil {
            addSubview(baseView)
        } else {
            bringSubviewToFront(baseView)
        }
        
        if let displayType = displayType, displayType.indicatorType.showLogo, logo != nil, logoView.superview == nil {
            baseView.addSubview(logoView)
        } else {
            baseView.bringSubviewToFront(logoView)
        }
        
        if indicatorView.superview == nil {
            baseView.addSubview(indicatorView)
        } else {
            baseView.bringSubviewToFront(indicatorView)
        }
        
        if titleLabel.superview == nil {
            baseView.addSubview(titleLabel)
        } else {
            baseView.bringSubviewToFront(titleLabel)
        }
    }
    
    func updateSubviews() {
        
        guard let containerView = containerView else { return }
        
        frame = CGRect(origin: .zero, size: containerView.frame.size)
        maskLayer.frame = CGRect(origin: .zero, size: containerView.frame.size)
        
        if !indicatorView.isHidden {
            indicatorView.frame = CGRect(origin: .zero, size: indicatorSize)
        }
        
        if let displayType = displayType, displayType.indicatorType.showLogo, logo != nil {
            logoView.frame = CGRect(origin: .zero, size: logoSize)
        }
        
        var labelSize: CGSize = .zero
        if !titleLabel.isHidden, let title = titleLabel.text as NSString?, title.length > 0 {
            let maxSize = CGSize(width: frame.width * 0.618, height: frame.width * 0.618)
            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
            let options: NSStringDrawingOptions = [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin]
            labelSize = title.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil).size
            titleLabel.frame = CGRect(origin: .zero, size: labelSize)
        }
        
        let labelHeight = titleLabel.isHidden ? 0 : labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
        let indicatorHeight = indicatorView.isHidden ?
            0 :
            indicatorSize.height + indicatorEdgeInsets.top + indicatorEdgeInsets.bottom
        
        let contentHeight = labelHeight + indicatorHeight + contentInsets.top + contentInsets.bottom
        let maxWidth = max(labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right,
                           indicatorSize.width + indicatorEdgeInsets.left + indicatorEdgeInsets.right)
        let contetnWidth = maxWidth + contentInsets.left + contentInsets.right
        
        let contentSize = CGSize(width: contetnWidth, height: contentHeight)
        let oldOrigin = self.baseView.frame.origin
        baseView.frame = CGRect(origin: oldOrigin, size: contentSize)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let centerX: CGFloat = contetnWidth / 2.0
        var centerY: CGFloat = contentHeight / 2.0

        // Indicator
        if labelHeight > 0 && !indicatorView.isHidden {
            centerY = contentInsets.top + indicatorEdgeInsets.top + indicatorSize.height / 2.0
        }
        indicatorView.center = CGPoint(x: centerX, y: centerY)
        logoView.center = CGPoint(x: centerX, y: centerY)

        // Label
        if indicatorHeight > 0 && !titleLabel.isHidden {
            centerY = contentInsets.top + indicatorHeight + titleEdgeInsets.top + labelSize.height / 2.0
        }
        titleLabel.center = CGPoint(x: centerX, y: centerY)
        
        CATransaction.commit()
    }
        
    @objc func placeSubviews(_ keybordHeight: CGFloat = 0, animationDuration: TimeInterval = 0) {
        
        guard let containerView = containerView else { return }

        frame = CGRect(origin: .zero, size: containerView.frame.size)
        maskLayer.frame = CGRect(origin: .zero, size: containerView.frame.size)
                
        let keyWindow = getKeyWindow()
        let orenitationFrame = frame
        var statusBarFrame: CGRect = .zero
        if containerView == keyWindow {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        
        // safe area bottom height
        let bottomInset: CGFloat
        if #available(iOS 11.0, *) {
            bottomInset = keyWindow?.safeAreaInsets.bottom ?? 0.0
        } else {
            bottomInset = 0
        }
        
        // if tabBar is hidden, bottom instantce is 24.0 + 12.0
        // otherwise, if keyboard is show, ignore tabBar height.
        let  defaultBottomInset: CGFloat
        if keybordHeight > 0 {
            defaultBottomInset = 0
        } else {
            let tabBarHeight = keyWindow?.rootViewController?.tabBarController?.tabBar.frame.height ?? 24.0
            defaultBottomInset = tabBarHeight + bottomInset
        }
        
        // if navigationBar is hidden, top instantce is 24.0
        let defaultTopInset: CGFloat
        if let navigationController = keyWindow?.rootViewController?.navigationController {
            defaultTopInset = navigationController.navigationBar.frame.height
        } else {
            defaultTopInset = 24.0
        }
        
        var activeHeight = orenitationFrame.height
        
        if keybordHeight > 0 {
            activeHeight += statusBarFrame.height * 2
        }
        
        activeHeight -= keybordHeight
        
        let distanceOfNavigationBarOrTabBar: CGFloat = 12
        
        //swiftlint:disable line_length
        let posY: CGFloat
        switch position {
        case .top:
            posY = defaultTopInset + statusBarFrame.height + distanceOfNavigationBarOrTabBar + baseView.frame.height * 0.5 + offset.vertical
        case .center:
            posY = activeHeight * 0.45 + offset.vertical
        case .bottom:
            posY = activeHeight - defaultBottomInset - distanceOfNavigationBarOrTabBar - baseView.frame.height * 0.5 + offset.vertical
        }
        //swiftlint:enable line_length

        let posX = orenitationFrame.width / 2.0 + offset.horizontal

        let center = CGPoint(x: posX, y: posY)
        
        if animationDuration == 0 {
            baseView.center = center
        } else {
            UIView.animate(
                withDuration: animationDuration,
                delay: 0,
                options: [.allowUserInteraction, .beginFromCurrentState],
                animations: {
                    self.baseView.center = center
                    self.baseView.setNeedsDisplay()
            })
        }
    }
}

// MARK: - Event Handler

private extension ZVProgressHUD {
    
    @objc func overlayRecievedTouchUpInsideEvent(_ sender: UIControl) {
        NotificationCenter.default.post(name: .ZVProgressHUDReceivedTouchUpInsideEvent, object: self, userInfo: nil)
    }
}

// MARK: - Notifications

private extension ZVProgressHUD {
    
    private func registerNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardNotification(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification?) {
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        var keybordHeight: CGFloat = 0
        var animationDuration: TimeInterval = 0

        if let notification = notification, let keyboardInfo = notification.userInfo {
            let keyboardFrame = keyboardInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            animationDuration = keyboardInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
            if notification.name == UIResponder.keyboardWillShowNotification ||
                notification.name == UIResponder.keyboardDidShowNotification {
                if orientation == .portrait {
                    keybordHeight = keyboardFrame?.height ?? 0
                }
            }
        } else {
            keybordHeight = getVisibleKeyboardHeight()
        }
        
        placeSubviews(keybordHeight, animationDuration: animationDuration)
    }
}

// MARK: - KeyWindow & Keyboard

private extension ZVProgressHUD {
    
    func getKeyWindow() -> UIWindow? {

        var keyWindow: UIWindow?
        UIApplication.shared.windows.forEach { window in
            if  window.screen == UIScreen.main,
                window.isHidden == false,
                window.alpha > 0,
                window.windowLevel >= UIWindow.Level.normal,
                window.windowLevel <= maxSupportedWindowLevel {
                keyWindow = window
                return
            }
        }
        return keyWindow
    }
    
    func getVisibleKeyboardHeight() -> CGFloat {
           
        var visibleKeyboardHeight: CGFloat = 0.0
        var keyboardWindow: UIWindow?
        UIApplication.shared.windows.reversed().forEach { window in
            let windowName = NSStringFromClass(window.classForCoder)
            if #available(iOS 9.0, *) {
                if windowName == "UIRemoteKeyboardWindow" {
                    keyboardWindow = window
                    return
                }
            } else {
                if windowName == "UITextEffectsWindow" {
                    keyboardWindow = window
                    return
                }
            }
        }

        var possibleKeyboard: UIView?
        keyboardWindow?.subviews.forEach({ subview in
            let viewClassName = NSStringFromClass(subview.classForCoder)
            if viewClassName.hasPrefix("UI") && viewClassName.hasSuffix("InputSetContainerView") {
                possibleKeyboard = subview
                return
            }
        })

        possibleKeyboard?.subviews.forEach({ subview in
            let viewClassName = NSStringFromClass(subview.classForCoder)
            if viewClassName.hasPrefix("UI") && viewClassName.hasSuffix("InputSetHostView") {
                let convertedRect = possibleKeyboard?.convert(subview.frame, to: self)
                let intersectedRect = convertedRect?.intersection(self.bounds)
                visibleKeyboardHeight = intersectedRect?.height ?? 0.0
                return
            }
        })
        
        return visibleKeyboardHeight
    }
}

// MARK: - Props

private extension ZVProgressHUD {
    
    var fadeOutTimer: Timer? {
        get {
            return _fadeOutTimer
        }
        set {
            if _fadeOutTimer != nil {
                _fadeOutTimer?.invalidate()
            }
            
            _fadeOutTimer = newValue
        }
    }
    
    var fadeInDeleyTimer: Timer? {
        get {
            return _fadeInDeleyTimer
        }
        set {
            if _fadeInDeleyTimer != nil {
                _fadeInDeleyTimer?.invalidate()
            }
            
            _fadeInDeleyTimer = newValue
        }
    }
    
    var fadeOutDelayTimer: Timer? {
        get {
            return _fadeOutDelayTimer
        }
        set {
            if _fadeOutDelayTimer != nil {
                _fadeOutDelayTimer?.invalidate()
            }
            
            _fadeOutDelayTimer = newValue
        }
    }
}

#endif
