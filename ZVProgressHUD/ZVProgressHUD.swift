//
//  ZVProgressHUD.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/12.
//  Copyright © 2017年 zevwings. All rights reserved.
//

open class ZVProgressHUD: UIControl {
    
    private struct AnimationDuration {
        static let fadeIn: TimeInterval = 0.15
        static let fadeOut: TimeInterval = 0.15
        static let keyboard: TimeInterval = 0.25
    }

    internal static let shared = ZVProgressHUD(frame: .zero)
    
    internal var displayStyle: DisplayStyle = .light
    internal var maskType: MaskType = .none
    
    internal var maxSupportedWindowLevel: UIWindowLevel = UIWindowLevelNormal
    
    internal var cornerRadius: CGFloat = 8.0
    internal var offset: UIOffset = .zero
    
    internal var font: UIFont = .systemFont(ofSize: 16.0)
    
    internal var strokeWith: CGFloat = 3.0
    internal var indicatorSize: CGSize = .init(width: 48.0, height: 48.0)
    internal var animationType: IndicatorView.AnimationType = .flat

    internal var contentInsets: UIEdgeInsets = .init(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    internal var titleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0 )
    internal var indicatorEdgeInsets: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

    private lazy var maskLayer: CALayer = { [unowned self] in
        let maskLayer = CALayer()
        return maskLayer
    }()
    
    private lazy var baseView: UIControl = { [unowned self] in
        let baseView = UIControl()
        baseView.backgroundColor = .clear
        baseView.alpha = 0.0
        return baseView
    }()
    
    private lazy var indicatorView: IndicatorView = { [unowned self] in
        let indicatorView = IndicatorView()
        indicatorView.isUserInteractionEnabled = false
        indicatorView.alpha = 0.0
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
        titleLabel.alpha = 0.0
        return titleLabel
    }()
    
    private var _fadeOutTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0.0
        backgroundColor = .clear
        
        addTarget(self, action: #selector(overlayRecievedTouchUpInsideEvent(_:)), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func overlayRecievedTouchUpInsideEvent(_ sender: UIControl) {
        NotificationCenter.default.post(name: .ZVProgressHUDReceivedEventTouchUpInside, object: self, userInfo: nil)
    }
}

// MARK: - show / dismiss

extension ZVProgressHUD {
    
    func show(with displayType: DisplayType) {
        
        OperationQueue.main.addOperation { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.fadeOutTimer = nil
            
            strongSelf.updateViewHierarchy()

            strongSelf.isUserInteractionEnabled = strongSelf.maskType.isUserInteractionEnabled
            strongSelf.maskLayer.backgroundColor = strongSelf.maskType.backgroundColor
            
            strongSelf.baseView.layer.cornerRadius = strongSelf.cornerRadius
            strongSelf.baseView.backgroundColor = strongSelf.displayStyle.backgroundColor

            strongSelf.titleLabel.textColor = strongSelf.displayStyle.foregroundColor
            strongSelf.titleLabel.font = strongSelf.font
            
            strongSelf.indicatorView.strokeWidth = strongSelf.strokeWith
            strongSelf.indicatorView.tintColor = strongSelf.displayStyle.foregroundColor

            switch displayType {
            case .indicator(let title, let type):
                strongSelf.indicatorView.indcatorType = type
                strongSelf.titleLabel.text = title
                strongSelf.indicatorView.isHidden = false
                strongSelf.titleLabel.isHidden = title == nil || title!.isEmpty
                break
            case .text(let title):
                strongSelf.titleLabel.text = title
                strongSelf.indicatorView.isHidden = true
                strongSelf.titleLabel.isHidden = title.isEmpty
                break
            }
            
            strongSelf.fadeIn(with: displayType.dismissTimeInterval)
        }
    }
    
    @objc private func dismiss(_ timer: Timer? = nil) {
        dismiss(with: 0.0, completion: nil)
    }
    
    func dismiss(with delayTimeInterval: TimeInterval, completion: (() -> ())? = nil) {
        
        OperationQueue.main.addOperation { [weak self] in
            guard let strongSelf = self else { return }
         
            NotificationCenter.default.post(name: .ZVProgressHUDWillDisappear, object: self, userInfo: nil)
            
            let animationBlock = {
                strongSelf.alpha = 0.0
                strongSelf.baseView.alpha = 0.0
                strongSelf.baseView.backgroundColor = .clear
                strongSelf.indicatorView.alpha = 0.0
                strongSelf.titleLabel.alpha = 0.0
            }
            
            let completionBlock = {
                
                if strongSelf.alpha == 0.0 {
                    
                    strongSelf.baseView.removeFromSuperview()
                    strongSelf.removeFromSuperview()
                    
                    NotificationCenter.default.removeObserver(strongSelf)
                    
                    NotificationCenter.default.post(name: .ZVProgressHUDDidDisappear, object: self, userInfo: nil)
                    
                    completion?()
                }
            }
            
            // TODO: - 屡清dismiss delay 思路
            if delayTimeInterval > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayTimeInterval) {
                    UIView.animate(withDuration: AnimationDuration.fadeOut, delay: 0, options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState], animations: {
                        animationBlock()
                    }, completion: { _ in
                        completionBlock()
                    })
                }
            } else {
                animationBlock()
                completionBlock()
            }
            
            strongSelf.setNeedsDisplay()
        }
    }
    
    @objc func fadeIn(with dismissTimeInterval: TimeInterval = 0.0) {
        
        updateSubview()
        positionHUD()
        
        if self.alpha != 1.0 {
            
            NotificationCenter.default.post(name: .ZVProgressHUDWillAppear, object: self, userInfo: nil)
            
            let animationBlock = {
                self.alpha = 1.0
                self.baseView.alpha = 1.0
                self.indicatorView.alpha = 1.0
                self.titleLabel.alpha = 1.0
            }
            
            let completionBlock = {
                
                guard self.alpha == 1.0 else { return }
                
                self.registerNotifications()
                
                NotificationCenter.default.post(name: .ZVProgressHUDDidAppear, object: self, userInfo: nil)
                
                if dismissTimeInterval > 0.0 {
                    self.fadeOutTimer = Timer.scheduledTimer(timeInterval: dismissTimeInterval, target: self, selector: #selector(self.dismiss(_:)), userInfo: nil, repeats: false)
                    RunLoop.main.add(self.fadeOutTimer!, forMode: .commonModes)
                }
            }
            
            UIView.animate(withDuration: AnimationDuration.fadeIn, delay: 0, options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState], animations: {
                animationBlock()
            }, completion: { _ in
                completionBlock()
            })
            
            UIView.animate(withDuration: AnimationDuration.fadeIn, animations: {
            }, completion: { _ in
                
            })
        } else {
            if dismissTimeInterval > 0.0 {
                self.fadeOutTimer = Timer.scheduledTimer(timeInterval: dismissTimeInterval, target: self, selector: #selector(self.dismiss(_:)), userInfo: nil, repeats: false)
                RunLoop.main.add(self.fadeOutTimer!, forMode: .commonModes)
            }
        }
    }
    
    func updateViewHierarchy() {
        
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
    
    func registerNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(positionHUD(_:)),
                                               name: .UIApplicationDidChangeStatusBarOrientation,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(positionHUD(_:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(positionHUD(_:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(positionHUD(_:)),
                                               name: .UIKeyboardDidShow,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(positionHUD(_:)),
                                               name: .UIKeyboardDidHide,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(positionHUD(_:)),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
    }
}

// MARK: - Update Subviews

private extension ZVProgressHUD {
    
    func updateSubview() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        maskLayer.frame = frame
        
        var indicatorSize: CGSize = .zero
        if !indicatorView.isHidden {
            indicatorSize = self.indicatorSize
            indicatorView.frame = CGRect(origin: .zero, size: indicatorSize)
        }
        
        var labelSize: CGSize = .zero
        if !titleLabel.isHidden, let title = titleLabel.text as NSString? {
            let maxSize = CGSize(width: frame.width * 0.5, height: frame.width * 0.5)
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
    
    @objc func positionHUD(_ notification: Notification? = nil) {
        
        guard let keyWindow = keyWindow else { return }

        var keybordHeight: CGFloat = 0.0
        var animationDuration: TimeInterval = 0.0
        
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
                    keybordHeight = keyboardFrame?.height ?? 0.0
                }
            }
        } else {
            keybordHeight = visibleKeyboardHeight
        }

        let posX = orenitationFrame.width / 2.0 + offset.horizontal
        let posY = (orenitationFrame.height - keybordHeight - statusBarFrame.height) / 2.0 + offset.vertical
        let center: CGPoint = .init(x: posX, y: posY)

        if notification != nil {
            UIView.animateKeyframes(withDuration: animationDuration,
                                    delay: 0,
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

// MARK: - Getter & Setter

extension ZVProgressHUD {
    
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
        
        guard keyboardWindow != nil, !keyboardWindow.isHidden else { return 0.0 }
        
        var containerView: UIView!
        for subview in keyboardWindow.subviews {
            if NSStringFromClass(subview.classForCoder) == "UIInputSetContainerView" {
                containerView = subview
            }
        }
        
        guard containerView != nil else { return 0.0 }
        
        for subview in containerView.subviews {
            if NSStringFromClass(subview.classForCoder) == "UIInputSetHostView" {
                return subview.frame.height
            }
        }

        return 0.0
    }
}
