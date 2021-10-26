//
//  ZVProgressHUD.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/12.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

// MARK: - Notifications

public extension Notification.Name {
    
    static let ZVProgressHUDReceivedTouchUpInsideEvent = Notification.Name("com.zevwings.progresshud.touchup.inside")
    
    static let ZVProgressHUDWillAppear = Notification.Name("com.zevwings.progresshud.willAppear")
    static let ZVProgressHUDDidAppear = Notification.Name("com.zevwings.progresshud.didAppear")
    
    static let ZVProgressHUDWillDisappear = Notification.Name("com.zevwings.progresshud.willDisappear")
    static let ZVProgressHUDDidDisappear = Notification.Name("com.zevwings.progresshud.didDisappear")
}

// MARK: - ZVProgressHUD

open class ZVProgressHUD: UIControl {
    
    public typealias CompletionHandler = () -> Void

    public struct Configuration {
        
        public var displayStyle: DisplayStyle = .light
        public var maskType: MaskType = .none
        public var position: Position = .center
            
        public var cornerRadius: CGFloat = 8.0
        public var offset: UIOffset = .zero
        
        public var titleLabelFont: UIFont = .systemFont(ofSize: 16.0)
        public var titleLabelColor: UIColor?

        public var progressForegroundColor: UIColor?
        public var progressBackgroundColor: UIColor?
        public var progressLabelFont: UIFont = .systemFont(ofSize: 12.0)
        public var progressLabelColor: UIColor?
        public var isProgressLabelHidden: Bool = false
        
        public var strokeWidth: CGFloat = 3.0
        public var animationType: ZVIndicatorView.AnimationType = .flat

        public var contentInsets = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
        public var titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        public var indicatorEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)

        public var indicatorSize = CGSize(width: 56.0, height: 56.0)

        public var logo: UIImage?
        public var logoSize = CGSize(width: 30.0, height: 30.0)
        
        public init() {}
    }
    
    public enum DisplayType {
        case indicator(title: String?, type: ZVIndicatorView.IndicatorType)
        case text(value: String)
        case customeView(view: UIView)
    }
    
    public enum DisplayStyle {
        case light
        case dark
        case custom((backgroundColor: UIColor, foregroundColor: UIColor))
    }
    
    public enum MaskType {
        case none
        case clear
        case black
        case custom(color: UIColor)
    }
    
    public enum Position {
        case top
        case center
        case bottom
    }
    
    private struct AnimationDuration {
        static let fadeIn: TimeInterval = 0.15
        static let fadeOut: TimeInterval = 0.15
        static let keyboard: TimeInterval = 0.25
    }

    // MARK: Public
    
    internal static let shared = ZVProgressHUD(frame: .zero)
    
    var maxSupportedWindowLevel: UIWindow.Level = .normal
    
    var fadeInAnimationTimeInterval: TimeInterval = ZVProgressHUD.AnimationDuration.fadeIn
    var fadeOutAnimationTImeInterval: TimeInterval = ZVProgressHUD.AnimationDuration.fadeOut
    
    var minimumDismissTimeInterval: TimeInterval = 3.0
    var maximumDismissTimeInterval: TimeInterval = 10.0
    
    // swiftlint:disable:next line_length
    var maximumContentSize = CGSize(width: UIScreen.main.bounds.width * 0.618, height: UIScreen.main.bounds.width * 0.618)
    // swiftlint:disable:previous: line_length

    /// 全局配置属性
    internal var configuration = Configuration()
            
    // MARK: Private
    
    private var _fadeOutTimer: Timer?
    private var _fadeInDeleyTimer: Timer?
    private var _fadeOutDelayTimer: Timer?

    private var _displayType: DisplayType?
    public var displayType: DisplayType? {
        return _displayType
    }
    
    private var _containerView: UIView?
    
    /// 展示自定视图时，保存临时视图
    private weak var _tempCustomView: UIView?

    /// 临时配置属性，在`HUD`消失时，清空
    private var _tempConfiguration: Configuration?

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
        titleLabel.backgroundColor = .clear
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.alpha = 0
        return titleLabel
    }()
    
    private lazy var logoView: UIImageView = { [unowned self] in
        
        let logoView = UIImageView(frame: .zero)
        logoView.contentMode = .scaleAspectFit
        logoView.layer.masksToBounds = true
        return logoView
    }()
    
    // MARK: Init
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private override init(frame: CGRect) {
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
        displayType: DisplayType,
        in superview: UIView?,
        delay delayTimeInterval: TimeInterval,
        with configuration: Configuration?
    ) {
        OperationQueue.main.addOperation { [weak self] in
            
            guard let `self` = self else { return }

            self._tempConfiguration = configuration
            
            if self.superview != superview {
                self.indicatorView.removeFromSuperview()
                self.titleLabel.removeFromSuperview()
                self.baseView.removeFromSuperview()
                self.logoView.removeFromSuperview()
                self.removeFromSuperview()
            }
            
            /// 确保自定义视图不会重复添加
            if let customView = self._tempCustomView {
                customView.removeFromSuperview()
            }
            
            self.fadeOutTimer = nil
            self.fadeInDeleyTimer = nil
            self.fadeOutDelayTimer = nil
            
            if let superview = superview {
                self._containerView = superview
            } else {
                self._containerView = self.getKeyWindow()
            }
            
            // set property form displayType
            self._displayType = displayType
            
            self.updateViewHierarchy()

            // set property form maskType
            self.isUserInteractionEnabled = self.maskType.isUserInteractionEnabled
            self.maskLayer.backgroundColor = self.maskType.backgroundColor
            
            self.baseView.layer.cornerRadius = self.cornerRadius
            self.baseView.backgroundColor = self.displayStyle.backgroundColor
            
            self.titleLabel.text = displayType.title
            self.titleLabel.isHidden = displayType.title.isEmpty
            self.titleLabel.font = self.titleLabelFont
            self.titleLabel.textColor = self.titleLabelColor

            self.indicatorView.indcatorType = displayType.indicatorType
            self.indicatorView.strokeWidth = self.strokeWidth
            self.indicatorView.tintColor = self.displayStyle.foregroundColor
            self.indicatorView.progressForegroundColor = self.progressForegroundColor
            self.indicatorView.progressBackgroundColor = self.progressBackgroundColor
            self.indicatorView.progressLabelFont = self.progressLabelFont
            self.indicatorView.progressLabelColor = self.progressLabelColor
            self.indicatorView.isProgressLabelHidden = self.isProgressLabelHidden
            
            self.logoView.image = self.logo
            self.logoView.tintColor = self.displayStyle.foregroundColor

            // display
            if delayTimeInterval > 0 {
                self.fadeInDeleyTimer = Timer.scheduledTimer(
                    timeInterval: delayTimeInterval,
                    target: self,
                    selector: #selector(self.fadeInTimerAction(_:)),
                    userInfo: nil,
                    repeats: false
                )
            } else {
                self.fadeIn()
            }
        }
    }

    func internalDismiss(
        with delayTimeInterval: TimeInterval = 0,
        completion: CompletionHandler? = nil
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
        
        guard let displayType = _displayType else { return }
        
        // swiftlint:disable:next line_length
        let displayTimeInterval = displayType.getDisplayTimeInterval(minimumDismissTimeInterval, maximumDismissTimeInterval)
        // swiftlint:disable:previous: line_length

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
                        self.internalDismiss()
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
                    selector: #selector(self.fadeOutTimerAction(_:)),
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
        
        let completion = timer?.userInfo as? CompletionHandler
        fadeOut(with: completion)
    }

    @objc private func fadeOut(with completion: CompletionHandler? = nil) {
        
        OperationQueue.main.addOperation { [weak self] in
            
            guard let `self` = self else { return }
            
            // send the notification HUD will disAppear
            NotificationCenter.default.post(name: .ZVProgressHUDWillDisappear, object: self, userInfo: nil)
            
            let animationBlock = {
                self.alpha = 0
                self.baseView.alpha = 0
                self.baseView.backgroundColor = .clear
                self.indicatorView.alpha = 0
                self.titleLabel.alpha = 0
            }
            
            let completionBlock = {
                
                guard self.alpha == 0 else { return }
                
                self.fadeOutTimer = nil
                self.fadeOutDelayTimer = nil
                
                // update view hierarchy
                self.indicatorView.removeFromSuperview()
                self.titleLabel.removeFromSuperview()
                self.baseView.removeFromSuperview()
                self.logoView.removeFromSuperview()
                self.removeFromSuperview()
                
                self._containerView = nil
                
                // remove notifications from self
                NotificationCenter.default.removeObserver(self)
                
                // send the notification HUD did disAppear
                NotificationCenter.default.post(name: .ZVProgressHUDDidDisappear, object: self, userInfo: nil)
                
                // execute completion handler
                completion?()
                
                self._tempConfiguration = nil
            }
            
            if self.fadeOutAnimationTImeInterval > 0 {
                UIView.animate(
                    withDuration: self.fadeOutAnimationTImeInterval,
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
            
            self.setNeedsDisplay()
        }
    }
}

// MARK: - Update Subviews

private extension ZVProgressHUD {
    
    func updateViewHierarchy() {
        
        guard let displayType = _displayType else { return }
        
        self.isUserInteractionEnabled = self.maskType.isUserInteractionEnabled
        
        if superview == nil {
            _containerView?.addSubview(self)
        } else {
            _containerView?.bringSubviewToFront(self)
        }
        
        if maskLayer.superlayer == nil {
            layer.addSublayer(maskLayer)
        }
        
        self.maskLayer.backgroundColor = self.maskType.backgroundColor
        
        if baseView.superview == nil {
            addSubview(baseView)
        } else {
            bringSubviewToFront(baseView)
        }
        
        baseView.layer.cornerRadius = cornerRadius
        baseView.backgroundColor = displayStyle.backgroundColor

        switch displayType {
        case let .indicator(title, indicatorType):
            updateIndicatorHierarchy(with: indicatorType)
            updateLabelHierarchy(with: title)
        case let .text(title):
            updateLabelHierarchy(with: title)
        case let .customeView(view):
            _tempCustomView = view
            baseView.addSubview(view)
        }
    }

    /// 更新 指示视图视图层级
    func updateIndicatorHierarchy(with indicatorType: ZVIndicatorView.IndicatorType) {

        if indicatorType.showLogo && logo != nil && logoView.superview == nil {
            baseView.addSubview(logoView)
        } else {
            baseView.bringSubviewToFront(logoView)
        }
        logoView.image = logo
        logoView.tintColor = displayStyle.foregroundColor

        /// 添加指示视图
        if indicatorView.superview == nil {
            baseView.addSubview(indicatorView)
        } else {
            baseView.bringSubviewToFront(indicatorView)
        }
        
        indicatorView.indcatorType = indicatorType
    }
    
    /// 更新描述标题视图层级
    func updateLabelHierarchy(with text: String?) {
        
        if titleLabel.superview == nil {
            baseView.addSubview(titleLabel)
        } else {
            baseView.bringSubviewToFront(titleLabel)
        }
        
        titleLabel.text = text
        titleLabel.isHidden = false
        titleLabel.font = titleLabelFont
        titleLabel.textColor = titleLabelColor
    }
    
    func updateSubviews() {
        
        guard let containerView = _containerView, let displayType = _displayType else { return }
        
        frame = CGRect(origin: .zero, size: containerView.frame.size)
        maskLayer.frame = CGRect(origin: .zero, size: containerView.frame.size)
        
        switch displayType {
        case .indicator, .text:
            
            if !indicatorView.isHidden {
                indicatorView.frame = CGRect(origin: .zero, size: indicatorSize)
            }
            
            if let displayType = _displayType, displayType.indicatorType.showLogo, logo != nil {
                logoView.frame = CGRect(origin: .zero, size: logoSize)
            }
            
            var labelSize: CGSize = .zero
            if !titleLabel.isHidden, let title = titleLabel.text as NSString?, title.length > 0 {
                let attributes: [NSAttributedString.Key: Any] = [.font: titleLabelFont]
                let options: NSStringDrawingOptions = [
                    .usesFontLeading,
                    .truncatesLastVisibleLine,
                    .usesLineFragmentOrigin
                ]
                labelSize = title.boundingRect(
                    with: maximumContentSize,
                    options: options,
                    attributes: attributes,
                    context: nil
                ).size
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
            let origin = self.baseView.frame.origin
            baseView.frame = CGRect(origin: origin, size: contentSize)

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
            
        case let .customeView(view):
            let origin = self.baseView.frame.origin
            baseView.frame = CGRect(origin: origin, size: view.frame.size)
        }
    }
        
    @objc func placeSubviews(_ keybordHeight: CGFloat = 0, animationDuration: TimeInterval = 0) {
        
        guard let containerView = _containerView else { return }

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
        
        // swiftlint:disable line_length
        let posY: CGFloat
        switch position {
        case .top:
            posY = defaultTopInset + statusBarFrame.height + distanceOfNavigationBarOrTabBar + baseView.frame.height * 0.5 + offset.vertical
        case .center:
            posY = activeHeight * 0.45 + offset.vertical
        case .bottom:
            posY = activeHeight - defaultBottomInset - distanceOfNavigationBarOrTabBar - baseView.frame.height * 0.5 + offset.vertical
        }
        // swiftlint:enable line_length

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

// MARK: - Timers

private extension ZVProgressHUD {
    
    var fadeOutTimer: Timer? {
        get {
            return _fadeOutTimer
        }
        set {
            if _fadeOutTimer != nil {
                _fadeOutTimer?.invalidate()
                _fadeOutTimer = nil
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
                _fadeInDeleyTimer = nil
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
                _fadeOutDelayTimer = nil
            }
            _fadeOutDelayTimer = newValue
        }
    }
}

// MARK: - Props

private extension ZVProgressHUD {
    
    var actualConfiguration: Configuration {
        if let configuration = _tempConfiguration {
            return configuration
        }
        return configuration
    }
    
    var displayStyle: DisplayStyle {
        return actualConfiguration.displayStyle
    }
    
    var maskType: MaskType {
        return actualConfiguration.maskType
    }
    
    var position: Position {
        return actualConfiguration.position
    }
    
    var cornerRadius: CGFloat {
        return actualConfiguration.cornerRadius
    }
    
    var offset: UIOffset {
        return actualConfiguration.offset
    }
    
    var titleLabelFont: UIFont {
        return actualConfiguration.titleLabelFont
    }
    
    var titleLabelColor: UIColor {
        if let color = _tempConfiguration?.titleLabelColor {
            return color
        }
        if let color = configuration.titleLabelColor {
            return color
        }
        return actualConfiguration.displayStyle.foregroundColor
    }
    
    var progressForegroundColor: UIColor {
        if let color = _tempConfiguration?.progressForegroundColor {
            return color
        }
        if let color = configuration.progressForegroundColor {
            return color
        }
        return actualConfiguration.displayStyle.foregroundColor
    }
    
    var progressBackgroundColor: UIColor {
        if let color = _tempConfiguration?.progressBackgroundColor {
            return color
        }
        if let color = configuration.progressBackgroundColor {
            return color
        }
        return actualConfiguration.displayStyle.foregroundColor.withAlphaComponent(0.5)
    }

    var progressLabelFont: UIFont {
        return actualConfiguration.progressLabelFont
    }
    
    var progressLabelColor: UIColor {
        if let color = _tempConfiguration?.progressLabelColor {
            return color
        }
        if let color = configuration.progressLabelColor {
            return color
        }
        return actualConfiguration.displayStyle.foregroundColor
    }
    
    var isProgressLabelHidden: Bool {
        return actualConfiguration.isProgressLabelHidden
    }

    var strokeWidth: CGFloat {
        return actualConfiguration.strokeWidth
    }
    
    var animationType: ZVIndicatorView.AnimationType {
        return actualConfiguration.animationType
    }

    var contentInsets: UIEdgeInsets {
        return actualConfiguration.contentInsets
    }
    var titleEdgeInsets: UIEdgeInsets {
        return actualConfiguration.titleEdgeInsets
    }
    
    var indicatorEdgeInsets: UIEdgeInsets {
        return actualConfiguration.indicatorEdgeInsets
    }

    var indicatorSize: CGSize {
        return actualConfiguration.indicatorSize
    }

    var logo: UIImage? {
        return actualConfiguration.logo
    }
    
    var logoSize: CGSize {
        return actualConfiguration.logoSize
    }

}

// MARK: - ZVProgressHUD.DisplayType

extension ZVProgressHUD.DisplayType {
    
    var dismissAtomically: Bool {
        switch self {
        case .text:
            return true
        case .indicator(_, let type):
            switch type {
            case .success, .error, .warning:
                return true
            case .image(_, let dismissAtomically):
                return dismissAtomically
            default:
                return false
            }
        case .customeView:
            return false
        }
    }

    var title: String {
        switch self {
        case .text(let value): return value
        case .indicator(let title, _): return title ?? ""
        case .customeView:
            return ""
        }
    }

    var indicatorType: ZVIndicatorView.IndicatorType {
        switch self {
        case .text: return .none
        case .indicator(_, let type): return type
        case .customeView: return .none
        }
    }

    func getDisplayTimeInterval(
        _ minimumDismissTimeInterval: TimeInterval,
        _ maximumDismissTimeInterval: TimeInterval
    ) -> TimeInterval {

        var displayTimeInterval: TimeInterval = dismissAtomically ? 3.0 : 0

        guard displayTimeInterval > 0 else { return 0 }

        displayTimeInterval = max(Double(title.count) * 0.06 + 0.5, minimumDismissTimeInterval)
        displayTimeInterval = min(displayTimeInterval, maximumDismissTimeInterval)

        return displayTimeInterval
    }
    
    var customView: UIView? {
        switch self {
        case let .customeView(view):
            return view
        default:
            return nil
        }
    }
}

// MARK: - ZVProgressHUD.DisplayStyle

extension ZVProgressHUD.DisplayStyle {
    var foregroundColor: UIColor {
        switch self {
        case .dark: return .white
        case .light: return UIColor(white: 0.2, alpha: 1)
        case .custom(let (foregroundColor, _)): return foregroundColor
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .dark: return UIColor(white: 0, alpha: 0.75)
        case .light: return .white
        case .custom(let (_, backgroundColor)): return backgroundColor
        }
    }
}

// MARK: - ZVProgressHUD.MaskType

extension ZVProgressHUD.MaskType {
    
    var backgroundColor: CGColor {
        switch self {
        case .none, .clear: return UIColor.clear.cgColor
        case .black: return UIColor.init(white: 0, alpha: 0.3).cgColor
        case .custom(let color): return color.cgColor
        }
    }

    var isUserInteractionEnabled: Bool {
        switch self {
        case .none: return false
        default: return true
        }
    }
}

// MARK: - ZVIndicatorView.IndicatorType

extension ZVIndicatorView.IndicatorType {
    
    var resource: String {
        switch self {
        case .error:
            return "error"
        case .success:
            return "success"
        case .warning:
            return "warning"
        default:
            return ""
        }
    }

    var shouldHidden: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }

    var progressValueChecker: (Bool, Float) {
        switch self {
        case .progress(let value):
            return (true, value)
        default:
            return (false, 0.0)
        }
    }

    var showLogo: Bool {
        switch self {
        case .indicator(let animationType):
            return animationType == .flat
        default:
            return false
        }
    }
}

#endif
