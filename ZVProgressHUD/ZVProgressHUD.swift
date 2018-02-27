//
//  ZVProgressHUD.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/12.
//  Copyright © 2017年 zevwings. All rights reserved.
//

public typealias ZVProgressHUDCompletionHandler = () -> ()

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
    
    public enum DisplayType {
        case indicator(title: String?, type: IndicatorView.IndicatorType)
        case text(value: String)
    }
    
    public enum DisplayStyle {
        case light
        case dark
        case custom(backgroundColor: UIColor, foregroundColor: UIColor)
    }
    
    public enum MaskType {
        case none
        case clear
        case black
        case custom(color: UIColor)
    }
    
    internal static let shared = ZVProgressHUD(frame: .zero)
    
    internal var displayStyle: DisplayStyle = .light
    internal var maskType: MaskType = .none
    
    internal var maxSupportedWindowLevel: UIWindowLevel = UIWindowLevelNormal
    internal var fadeInAnimationTimeInterval: TimeInterval = AnimationDuration.fadeIn
    internal var fadeOutAnimationTImeInterval: TimeInterval = AnimationDuration.fadeOut
    
    internal var minimumDismissTimeInterval: TimeInterval = 3.0
    internal var maximumDismissTimeInterval: TimeInterval = 10.0
    
    internal var cornerRadius: CGFloat = 8.0
    internal var offset: UIOffset = .zero
    
    internal var font: UIFont = .systemFont(ofSize: 16.0)
    
    internal var strokeWith: CGFloat = 3.0
    internal var indicatorSize: CGSize = .init(width: 48.0, height: 48.0)
    internal var animationType: IndicatorView.AnimationType = .flat

    internal var contentInsets: UIEdgeInsets = .init(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    internal var titleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0 )
    internal var indicatorEdgeInsets: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

    private var _fadeOutTimer: Timer?
    private var _fadeInDeleyTimer: Timer?
    private var _fadeOutDelayTimer: Timer?
    
    private lazy var maskLayer: CALayer = { [unowned self] in
        let maskLayer = CALayer()
        return maskLayer
    }()
    
    private lazy var baseView: UIControl = {
        let baseView = UIControl()
        baseView.backgroundColor = .clear
        baseView.alpha = 0
        return baseView
    }()
    
    private lazy var indicatorView: IndicatorView = {
        let indicatorView = IndicatorView()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = .clear
        
        addTarget(self, action: #selector(overlayRecievedTouchUpInsideEvent(_:)), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZVProgressHUD {
    
    func show(with displayType: DisplayType, delay delayTimeInterval: TimeInterval = 0) {
        
        OperationQueue.main.addOperation { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.fadeOutTimer = nil
            
            strongSelf.updateViewHierarchy()

            strongSelf.titleLabel.font = strongSelf.font
            strongSelf.indicatorView.strokeWidth = strongSelf.strokeWith
            strongSelf.baseView.layer.cornerRadius = strongSelf.cornerRadius
            strongSelf.baseView.backgroundColor = strongSelf.displayStyle.backgroundColor

            // set property form maskType
            strongSelf.isUserInteractionEnabled = strongSelf.maskType.isUserInteractionEnabled
            strongSelf.maskLayer.backgroundColor = strongSelf.maskType.backgroundColor
            
            // set property form displayStyle
            strongSelf.titleLabel.textColor = strongSelf.displayStyle.foregroundColor
            strongSelf.indicatorView.tintColor = strongSelf.displayStyle.foregroundColor
            
            // set property form displayType
            strongSelf.titleLabel.text = displayType.title
            strongSelf.titleLabel.isHidden = displayType.title.isEmpty
            strongSelf.indicatorView.indcatorType = displayType.indicatorType
            strongSelf.indicatorView.isHidden = displayType.indicatorType == nil
            
            // display
            let displayTimeInterval = strongSelf.displayTimeInterval(for: displayType)
            if delayTimeInterval > 0 {
                strongSelf.fadeInDeleyTimer = Timer.scheduledTimer(timeInterval: delayTimeInterval, target: strongSelf, selector: #selector(strongSelf.fadeIn(with:)), userInfo: displayTimeInterval, repeats: false)
            } else {
                strongSelf.fadeIn(with: displayTimeInterval)
            }
        }
    }
    
    
    func dismiss(with delayTimeInterval: TimeInterval = 0, completion: ZVProgressHUDCompletionHandler? = nil) {
        
        if delayTimeInterval > 0 {
            fadeOutDelayTimer = Timer.scheduledTimer(timeInterval: delayTimeInterval, target: self, selector: #selector(fadeOut(with:)), userInfo: completion, repeats: false)
        } else {
            fadeOut(with: completion)
        }
    }
    
    @objc private func dismiss(_ timer: Timer?) {
        dismiss()
    }
    
    @objc private func fadeIn(with data: Any?) {
        
        var displayTimeInterval: TimeInterval = 0
        
        if let timer = data as? Timer {
            displayTimeInterval = timer.userInfo as? TimeInterval ?? 0
        } else {
            displayTimeInterval = data as? TimeInterval ?? 0
        }
        
        updateSubviews()
        placeSubviews()
        
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
                    self.fadeOutTimer = Timer.scheduledTimer(timeInterval: displayTimeInterval, target: self, selector: #selector(self.dismiss(_:)), userInfo: nil, repeats: false)
                    RunLoop.main.add(self.fadeOutTimer!, forMode: .commonModes)
                }
            }
            
            if fadeInAnimationTimeInterval > 0 {
                UIView.animate(withDuration: fadeInAnimationTimeInterval,
                               delay: 0,
                               options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState],
                               animations: {
                                   animationBlock()
                               }, completion: { _ in
                                   completionBlock()
                               })
            } else {
                animationBlock()
                completionBlock()
            }
        } else {
            
            if displayTimeInterval > 0 {
                fadeOutTimer = Timer.scheduledTimer(timeInterval: displayTimeInterval, target: self, selector: #selector(self.dismiss(_:)), userInfo: nil, repeats: false)
                RunLoop.main.add(fadeOutTimer!, forMode: .commonModes)
            }
        }
    }
    
    @objc private func fadeOut(with data: Any?) {
        
        var completion: ZVProgressHUDCompletionHandler?
        if let timer = data as? Timer {
            completion = timer.userInfo as? ZVProgressHUDCompletionHandler
        } else {
            completion = data as? ZVProgressHUDCompletionHandler
        }
        
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
                strongSelf.baseView.removeFromSuperview()
                strongSelf.removeFromSuperview()
                
                // remove notifications from self
                NotificationCenter.default.removeObserver(strongSelf)
                
                // send the notification HUD did disAppear
                NotificationCenter.default.post(name: .ZVProgressHUDDidDisappear, object: self, userInfo: nil)
                
                // execute completion handler if exist
                completion?()
            }
            
            if strongSelf.fadeOutAnimationTImeInterval > 0 {
                UIView.animate(withDuration: strongSelf.fadeOutAnimationTImeInterval,
                               delay: 0,
                               options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState],
                               animations: {
                                    animationBlock()
                               }, completion: { _ in
                                    completionBlock()
                               })
            } else {
                animationBlock()
                completionBlock()
            }
            
            strongSelf.setNeedsDisplay()
        }
    }
    
    private func updateViewHierarchy() {
        
        if superview == nil {
            guard let sv = keyWindow else { return }
            sv.addSubview(self)
        } else {
            superview?.bringSubview(toFront: self)
        }
        
        if maskLayer.superlayer == nil {
            layer.addSublayer(maskLayer)
        }
        
        if baseView.superview == nil {
            addSubview(baseView)
        } else {
            bringSubview(toFront: baseView)
        }
        
        if indicatorView.superview == nil {
            baseView.addSubview(indicatorView)
        } else {
            baseView.bringSubview(toFront: indicatorView)
        }
        
        if titleLabel.superview == nil {
            baseView.addSubview(titleLabel)
        } else {
            baseView.bringSubview(toFront: titleLabel)
        }
    }
    
    private func displayTimeInterval(for displayType: DisplayType) -> TimeInterval {
        
        var displayTimeInterval: TimeInterval = displayType.dismissAtomically ? 3.0 : 0
        
        guard displayTimeInterval > 0 else { return 0 }
        
        displayTimeInterval = max(Double(displayType.title.count) * 0.06 + 0.5, minimumDismissTimeInterval)
        displayTimeInterval = min(displayTimeInterval, maximumDismissTimeInterval)
        
        return displayTimeInterval
    }
    
    private func registerNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: .UIApplicationDidChangeStatusBarOrientation,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: .UIKeyboardDidShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: .UIKeyboardDidHide,
                                               object: nil)
    }
}

// MARK: - Update Subviews

private extension ZVProgressHUD {
    
    func updateSubviews() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        maskLayer.frame = frame
        
        var indicatorSize: CGSize = .zero
        if !indicatorView.isHidden {
            indicatorSize = self.indicatorSize
            indicatorView.frame = CGRect(origin: .zero, size: indicatorSize)
        }
        
        var labelSize: CGSize = .zero
        if !titleLabel.isHidden, let title = titleLabel.text as NSString?, title.length > 0 {
            let maxSize = CGSize(width: frame.width * 0.618, height: frame.width * 0.618)
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
            let options: NSStringDrawingOptions = [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin]
            labelSize = title.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil).size
            titleLabel.frame = CGRect(origin: .zero, size: labelSize)
        }
        
        let labelHeight = labelSize.height > 0 ? labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom : 0
        let indicatorHeight = indicatorSize.height > 0 ? indicatorSize.height + indicatorEdgeInsets.top + indicatorEdgeInsets.bottom : 0
        
        let contentHeight = labelHeight + indicatorHeight + contentInsets.top + contentInsets.bottom
        let contetnWidth = max(labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, indicatorSize.width + indicatorEdgeInsets.left + indicatorEdgeInsets.right) + contentInsets.left + contentInsets.right

        let contentSize: CGSize = .init(width: contetnWidth, height: contentHeight)
        baseView.frame = .init(origin: .zero, size: contentSize)
        
        let centerX: CGFloat = contetnWidth / 2.0
        var centerY: CGFloat = contentHeight / 2.0

        // Indicator
        if labelHeight > 0 && !indicatorView.isHidden {
            centerY = contentInsets.top + indicatorEdgeInsets.top + indicatorSize.height / 2.0
        }
        indicatorView.center = .init(x: centerX, y: centerY)
        
        // Label
        if indicatorHeight > 0 && !titleLabel.isHidden {
            centerY = contentInsets.top + indicatorHeight + titleEdgeInsets.top + labelSize.height / 2.0
        }
        titleLabel.center = .init(x: centerX, y: centerY)
        
        CATransaction.commit()
    }
    
    @objc func placeSubviews(_ notification: Notification? = nil) {
        
        guard let keyWindow = keyWindow else { return }

        var keybordHeight: CGFloat = 0
        var animationDuration: TimeInterval = 0
        
        frame = keyWindow.frame
        maskLayer.frame = keyWindow.frame

        let orientation = UIApplication.shared.statusBarOrientation
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let orenitationFrame = frame
        
        if let notification = notification, let keyboardInfo = notification.userInfo {
            let keyboardFrame = keyboardInfo[UIKeyboardFrameBeginUserInfoKey] as? CGRect
            animationDuration = keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
            if notification.name == .UIKeyboardWillShow || notification.name == .UIKeyboardDidShow {
                if orientation == .portrait {
                    keybordHeight = keyboardFrame?.height ?? 0
                }
            }
        } else {
            keybordHeight = visibleKeyboardHeight
        }

        let posX = orenitationFrame.width / 2.0 + offset.horizontal
        let posY = (orenitationFrame.height - keybordHeight - statusBarFrame.height) / 2.0 + offset.vertical
        let center: CGPoint = .init(x: posX, y: posY)

        if notification != nil {
            UIView.animateKeyframes(withDuration: animationDuration, delay: 0,
                                    options: [.allowUserInteraction, .beginFromCurrentState],
                                    animations: { [unowned self] in
                                        self.baseView.center = center
                                        self.baseView.setNeedsDisplay()
                                    }, completion: nil)
        } else {
            baseView.center = center
        }
    }
}

// MARK: - Event Handler

private extension ZVProgressHUD {
    
    @objc func overlayRecievedTouchUpInsideEvent(_ sender: UIControl) {
        NotificationCenter.default.post(name: .ZVProgressHUDReceivedTouchUpInsideEvent, object: self, userInfo: nil)
    }
}

// MARK: - Getter & Setter

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
            
            if newValue != nil {
                _fadeOutTimer = newValue
            }
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
            
            if newValue != nil {
                _fadeInDeleyTimer = newValue
            }
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
            
            if newValue != nil {
                _fadeOutDelayTimer = newValue
            }
        }
    }
    
    var keyWindow: UIWindow? {
        var keyWindow: UIWindow?
        for window in UIApplication.shared.windows {
            guard
                window.screen == UIScreen.main,
                window.isHidden == false,
                window.alpha > 0,
                window.windowLevel >= UIWindowLevelNormal,
                window.windowLevel <= maxSupportedWindowLevel
            else { continue }
            
            keyWindow = window
            break
        }
        return keyWindow
    }
    
    var visibleKeyboardHeight: CGFloat {
        
        let windows = UIApplication.shared.windows
        var keyboardWindow: UIWindow!
        for window in windows.reversed() {
            if #available(iOS 9.0, *) {
                if NSStringFromClass(window.classForCoder) == "UIRemoteKeyboardWindow" {
                    keyboardWindow = window
                }
            } else {
                if NSStringFromClass(window.classForCoder) == "UITextEffectWindow" {
                    keyboardWindow = window
                }
            }
        }
        
        guard keyboardWindow != nil, !keyboardWindow.isHidden else { return 0 }
        
        var containerView: UIView!
        for subview in keyboardWindow.subviews {
            if NSStringFromClass(subview.classForCoder) == "UIInputSetContainerView" {
                containerView = subview
            }
        }
        
        guard containerView != nil else { return 0 }
        
        for subview in containerView.subviews {
            if NSStringFromClass(subview.classForCoder) == "UIInputSetHostView" {
                return subview.frame.height
            }
        }

        return 0
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
        }
    }
    
    var title: String {
        
        switch self {
        case .text(let value):
            return value
        case .indicator(let title, _):
            return title ?? ""
        }
    }
    
    var indicatorType: IndicatorView.IndicatorType? {
        switch self {
        case .text:
            return nil
        case .indicator(_, let type):
            return type
        }
    }
}

// MARK: - ZVProgressHUD.DisplayStyle

extension ZVProgressHUD.DisplayStyle {
    
    var foregroundColor: UIColor {
        switch self {
        case .dark:
            return .white
        case .light:
            return UIColor(white: 0.2, alpha: 1)
        case .custom(let color):
            return color.foregroundColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .dark:
            return UIColor(white: 0, alpha: 0.75)
        case .light:
            return .white
        case .custom(let color):
            return color.backgroundColor
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

