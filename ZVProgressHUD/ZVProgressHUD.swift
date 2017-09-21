//
//  ZVProgressHUD.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/12.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit

// MARK: - 枚举定义
public extension ZVProgressHUD {
    
    fileprivate struct AnimationDuration {
        static let fadeIn: TimeInterval = 0.15
        static let fadeOut: TimeInterval = 0.25
        static let keyboard: TimeInterval = 0.25
    }
    
    fileprivate struct StateSize {
        static let width: CGFloat = 38.0
        static let height: CGFloat = 38.0
    }
    
    /// 显示位置
    public enum DisplayPosition {
        case center, bottom
    }
    
    /// 显示类型
    ///
    /// - state:  显示预定义状态文本
    /// - text:   显示纯文本
    /// - custom: 显示一个自定义视图
    public enum DisplayType {
        
        case state(title: String?, state: ZVProgressHUD.StateType)
        case text(label: String)
        case custom(view: UIView)
        
    }
    
    /// 显示风格
    ///
    /// - dark: 背景颜色为：UIColor(white: 0.0, alpha: 0.75) 前景颜色为：UIColor.white
    /// - ligtht: 背景颜色为：UIColor.white 前景颜色为：UIColor(white: 0.2, alpha: 1.0)
    /// - custom: 自定义背景颜色和前景颜色
    public enum DisplayStyle {
        case dark
        case ligtht
        case custom(backgroundColor: UIColor, foregroundColor: UIColor)
        
        var foregroundColor: UIColor {
            switch self {
            case .dark:
                return .white
            case .ligtht:
                return .init(white: 0.2, alpha: 1)
            case .custom(let color):
                return color.foregroundColor
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .dark:
                return .init(white: 0, alpha: 0.75)
            case .ligtht:
                return .white
            case .custom(let color):
                return color.backgroundColor
            }
        }
    }
    
    /// 加载动画类型
    ///
    /// - native: 本地
    /// - extended: 拓展
    public enum AnimationType {
        case native
        case extended
    }
    
    /// 遮罩层类型
    ///
    /// - none: 无遮罩
    /// - clear: 透明遮罩
    /// - black: 黑色遮罩
    /// - custom: 自定义遮罩
    public enum MaskType {
        case none
        case clear
        case black
        case custom(color: UIColor)
    }
    
    /// 状态类型
    ///
    /// - indicator: 指示器
    /// - error: 错误
    /// - success: 成功
    /// - warning: 警告
    /// - progress: 进度
    /// - custom: 自定义图片
    public enum StateType: Equatable {

        case error, success, warning
        case indicator
        case progress(value: Float)
        case custom(image: UIImage)
        
        /// 返回默认图片路径
        var path: String {
            switch self {
            case .error:
                return "error.png"
            case .success:
                return "success.png"
            case .warning:
                return "warning.png"
            default:
                return ""
            }
        }
        
        var hashValue: Int {
            switch self {
            case .error:
                return 0
            case .success:
                return 1
            case .warning:
                return 2
            case .indicator:
                return 3
            case .progress:
                return 4
            case .custom(let image):
                return image.hashValue
            }
        }
        
        public static func ==(lhs: ZVProgressHUD.StateType, rhs: ZVProgressHUD.StateType) -> Bool {
            if lhs.hashValue == rhs.hashValue {
                return true
            } else {
                return false
            }
        }
    }
}

// MARK: - 主方法
public class ZVProgressHUD: UIView {
    
    /// 设置遮罩类型
    internal var maskType: ZVProgressHUD.MaskType = .clear
    fileprivate var _lastDisplayType: ZVProgressHUD.DisplayType = .text(label: "")
    /// 改变现实类型，将会改变所有布局，自定义时最后设置该值
    /// eg:
    /// self.progressView.displayPosition = ...
    /// ... 除displayType之外的其他属性
    /// self.progressView.displayType = ...
    internal var displayType: ZVProgressHUD.DisplayType = .text(label: "") {
        didSet {
            self._disableActions = true
            self._isFinishedLayout = false
            self._prepare()
            self._placeSubView(showKeyboard: true)
            self._disableActions = false
            self._isFinishedLayout = true
        }
    }

    
    fileprivate var _disableActions: Bool = true
    fileprivate var _isFinishedLayout: Bool = false
    /// 显示位置
    internal var displayPosition: ZVProgressHUD.DisplayPosition = .center
    
    /// 显示风格
    internal var displayStyle: ZVProgressHUD.DisplayStyle = .dark
    
    /// 文本标题与其他空间边距
    internal var titleInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    
    /// 状态视图与其他空间边距，如果状态视图和文本标题存在时，bottom 无效
    internal var stateInsets = UIEdgeInsets(top: 24 , left: 24, bottom: 24, right: 24)

    /// 自定义视图与其他空间边距
    internal var customInsets = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    
    /// baseView偏离位置
    internal var offset = CGPoint(x: 0, y: 0)
    
    /// 文本字体
    internal var font: UIFont = .systemFont(ofSize: 14.0)
    
    /// baseView圆角 NOTE: 当视图为纯文本时圆角为该值的一般
    internal var cornerRadius: CGFloat = 12.0
    
    /// 整体延时时间
    internal var delay: TimeInterval = 0.0
    
    /// 加载动画类型
    internal var animationType: AnimationType = .extended
    
    /// 图片或指示器大小
    internal var stateSize: CGSize = CGSize(width: StateSize.width, height: StateSize.height)
    
    internal var lineWidth: CGFloat = 2.5
    
    // MARK: 基础控件
    
    fileprivate lazy var _overlayView: ZVBackgroundView = {
        let overlayView = ZVBackgroundView()
        overlayView.backgroundColor = UIColor.clear
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.addTarget(self,
                              action: #selector(ZVProgressHUD.overlayDidTouchUpInside(_:)),
                              for: .touchUpInside)
        return overlayView
    }()
    
    fileprivate lazy var _baseView: UIView = {
        let baseView = UIView()
        baseView.isUserInteractionEnabled = true
        return baseView
    }()
    
    fileprivate lazy var _stateLabel: UILabel = {
        let stateLabel = UILabel(frame: .zero)
        stateLabel.textColor = .white
        stateLabel.backgroundColor = .clear
        stateLabel.baselineAdjustment = .alignCenters
        stateLabel.textAlignment = .center
        stateLabel.numberOfLines = 0
        return stateLabel
    }()
    
    fileprivate lazy var _stateView: ZVStateView = {
        let stateView = ZVStateView()
        stateView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin ]
        return stateView
    }()
    
    fileprivate var _customView: UIView?
    
    /// 计时器
    fileprivate var _fadeOutTimer: Timer?
    
    /// 单例属性
    fileprivate static let shared = ZVProgressHUD(frame: .zero)

    // MARK: 初始化方法

    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(notification:)), name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: 通知
    @objc func orientationDidChange(notification: Notification) {
        self._placeSubView(showKeyboard: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        guard self.superview != nil else { return }
        UIView.animate(withDuration: AnimationDuration.keyboard) {
            guard let bounds = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
            }
            var frame = self.keyWindow?.frame ?? .zero
            let height = frame.height - bounds.height
            frame.size.height = height
            self._placeSubView(showKeyboard: true)

        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard self.superview != nil else { return }
        UIView.animate(withDuration: AnimationDuration.keyboard) {
            self._placeSubView(showKeyboard: false)
        }
    }
}

extension ZVProgressHUD {
    
    //MARK: 添加控件
    fileprivate func _prepare() {
        
        // 移除所有子视图
        _removeSubviews()
        
        if _overlayView.superview == nil {
            self.addSubview(_overlayView)
        }
        
        _overlayView.maskType = maskType
        
        switch self.maskType {
        case .none:
            self.isUserInteractionEnabled = false
        default:
            self.isUserInteractionEnabled = true
        }

        
        if _baseView.superview == nil {
            _overlayView.addSubview(_baseView)
        }
        
        _baseView.backgroundColor = self.displayStyle.backgroundColor
        
        switch self.displayType {
        case .text(let title):
            
            guard title.isEmpty == false else { return }
            _baseView.layer.cornerRadius = self.cornerRadius * 0.5
            if _stateLabel.superview == nil {
                _baseView.addSubview(_stateLabel)
            }
            _stateLabel.textColor = self.displayStyle.foregroundColor
            _stateLabel.font = self.font
            _stateLabel.text = title
            break
        case .state(let title, let state):
            
            _baseView.layer.cornerRadius = self.cornerRadius
            if _stateView.superview == nil {
                _baseView.addSubview(_stateView)
            }
            _stateView.color = self.displayStyle.foregroundColor
            _stateView.animationType = self.animationType
            _stateView.stateType = state
            _stateView.lineWidth = self.lineWidth
            guard let titleValue = title, titleValue.isEmpty == false else {
                self._stateLabel.text = nil
                return
            }
            if _stateLabel.superview == nil {
                _baseView.addSubview(_stateLabel)
            }
            _stateLabel.textColor = self.displayStyle.foregroundColor
            _stateLabel.text = titleValue
            _stateLabel.font = self.font
            break
        case .custom(let view):
            _customView = view
            _baseView.layer.cornerRadius = self.cornerRadius
            _baseView.addSubview(view)
            break
        }        
    }
    
    //MARK: 摆放控件
    fileprivate func _placeSubView(showKeyboard: Bool = false) {

        CATransaction.begin()
        CATransaction.setDisableActions(self._disableActions)

        let keyboardHeight = self.keyboardFrame.height

        var _frame: CGRect = keyWindow?.frame ?? .zero
        
        if showKeyboard {
            _frame.size.height -= keyboardHeight
        }
        
        self.frame = _frame
        
        self._overlayView.frame = self.frame
        
        let labelSize = self._stateLabel.textSize(with: .init(width: self.frame.width * 0.75,
                                                              height: self.frame.width * 0.75))
        
        let labelWidth = labelSize.width + self.titleInsets.left + self.titleInsets.right
        let stateWidth = stateSize.width + self.stateInsets.left + self.stateInsets.right
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        switch self.displayPosition {
        case .center:
            x = self._overlayView.frame.width * 0.5 - self.offset.x
            y = self._overlayView.frame.height * 0.5 - self.offset.y
            break
        case .bottom:
            x = self._overlayView.frame.width * 0.5 - self.offset.x
            y = self._overlayView.frame.height - 24 - self.offset.y
            break
        }
        
        switch self.displayType {
        case .text:
            let height = labelSize.height + self.titleInsets.top + self.titleInsets.bottom
            let baseX = x - labelWidth * 0.5
            let baseY = y - height *  (self.displayPosition == .center ? 0.5 : 1)
            self._baseView.frame = CGRect(x: baseX, y: baseY, width: labelWidth, height: height)
            self._stateLabel.frame = CGRect(x: self.titleInsets.left, y: self.titleInsets.top, width: labelSize.width, height: labelSize.height)
            break
        case .state(_, let state):
            
            var height = stateSize.height
            var width  = stateSize.width

            if state.hashValue == 3 || state.hashValue == 4 {
                height += self.lineWidth * 2
                width += self.lineWidth * 2
            }
            let baseW  = labelWidth > stateWidth ? labelWidth : stateWidth
            var baseH: CGFloat = 0
            
            if labelSize == .zero {
                baseH = labelSize.height + height + self.stateInsets.top + self.stateInsets.bottom
            } else {
                baseH = labelSize.height + self.titleInsets.top + self.titleInsets.bottom + height + self.stateInsets.top + self.stateInsets.bottom * 0.25
            }
            let baseX = x - baseW * 0.5
            let baseY = y - baseH * (self.displayPosition == .center ? 0.5 : 1)
            self._baseView.frame = CGRect(x: baseX, y: baseY, width: baseW, height: baseH)
            
            let stateX = baseW * 0.5 - width * 0.5
            self._stateView.frame = CGRect(x: stateX, y: self.stateInsets.top, width: width, height: height)
            
            let labelY = self.stateInsets.top + height + self.titleInsets.top
            let labelM = self.titleInsets.left + self.titleInsets.right
            let labelW = labelWidth < stateWidth ? stateWidth - labelM: labelWidth - labelM
            self._stateLabel.frame = CGRect(x: self.titleInsets.left, y: labelY, width: labelW, height: labelSize.height)
            break
        case .custom(let view):
            let baseX = x - view.frame.width * 0.5 + customInsets.left
            let baseY = y - view.frame.height * (self.displayPosition == .center ? 0.5 : 1) + customInsets.top
            let baseW = view.frame.width + customInsets.left + customInsets.right
            let baseH = view.frame.height + customInsets.top + customInsets.bottom
            self._baseView.frame = CGRect(x: baseX, y: baseY, width: baseW, height: baseH)
            
            var rect = view.frame
            rect.origin.x += customInsets.left
            rect.origin.y += customInsets.top
            view.frame = rect
            break
        }
        
        CATransaction.commit()
    }
    
    fileprivate func _removeSubviews() {
        
        if _overlayView.superview != nil {
            _overlayView.removeFromSuperview()
        }
        
        if _baseView.superview != nil {
            _baseView.removeFromSuperview()
        }
        
        if _stateView.superview != nil {
            _stateView.removeFromSuperview()
        }
        
        if _stateLabel.superview != nil {
            _stateLabel.removeFromSuperview()
        }
        
        if _customView?.superview != nil {
            _customView?.removeFromSuperview()
            _customView = nil
        }
    }
    
    @objc func overlayDidTouchUpInside(_ sender: Any) {
        NotificationCenter.default.post(name: .ZVProgressHUDDidReceiveTouchEvent, object: self, userInfo: nil)
    }

}

// MARK: - 类方法
extension ZVProgressHUD {
    
    // MARK: 属性设置
    
    /// 显示风格
    public static var displayStyle: ZVProgressHUD.DisplayStyle {
        get { return self.shared.displayStyle }
        set { self.shared.displayStyle = newValue }
    }
    
    /// 这只遮罩层类型
    public static var maskType: ZVProgressHUD.MaskType {
        get { return self.shared.maskType }
        set { self.shared.maskType = newValue }
    }
    
    /// 设置文本标签边距
    public static var titleInsets: UIEdgeInsets {
        get { return self.shared.titleInsets }
        set { self.shared.titleInsets = newValue }
    }

    /// 状态视图与其他空间边距，如果状态视图和文本标题存在时，bottom为其1/4
    public static var stateInsets: UIEdgeInsets {
        get { return self.shared.stateInsets }
        set { self.shared.stateInsets = newValue }
    }
    
    /// 自定义视图与其他空间边距
    public static var customInsets: UIEdgeInsets {
        get { return self.shared.customInsets }
        set { self.shared.customInsets = newValue}
    }

    /// baseView偏离位置
    public static var offset: CGPoint {
        get { return self.shared.offset }
        set { self.shared.offset = newValue }
    }
    
    /// 文本字体
    public static var font: UIFont {
        get { return self.shared.font }
        set { self.shared.font = newValue }
    }
    
    public static var delay: TimeInterval {
        get { return self.shared.delay }
        set { self.shared.delay = newValue }
    }
    
    /// baseView圆角 NOTE: 当视图为纯文本时圆角为该值的一般
    public static var cornerRadius: CGFloat {
        get { return self.shared.cornerRadius }
        set { self.shared.cornerRadius = newValue }
    }
    
    /// 图片或指示器大小
    /// NOTE: Resource.bundle 内图片大小为114px，请慎重设置该值
    public static var stateSize: CGSize {
        get { return self.shared.stateSize }
        set { self.shared.stateSize = newValue }
    }
    
    public static var animationType: ZVProgressHUD.AnimationType {
        get { return self.shared.animationType }
        set { self.shared.animationType = newValue }
    }
    
    public static var lineWidth: CGFloat {
        get { return self.shared.lineWidth }
        set { self.shared.lineWidth = newValue }
    }
    
    // MARK: 显示方法
    
    /// 显示纯文本
    public class func show(label: String,
                           on positon: ZVProgressHUD.DisplayPosition = .bottom) {
        self.show(with: .text(label: label), on: positon)
    }
    
    /// 显示文本和自定义图片
    public class func show(title: String = "",
                           image: UIImage,
                           on positon: ZVProgressHUD.DisplayPosition = .center) {
        self.show(title: title, state: .custom(image: image), on: positon)
    }
    
    /// 显示文本和进度条
    public class func show(title: String = "",
                           progress: Float,
                           on positon: ZVProgressHUD.DisplayPosition = .center) {
        self.show(title: title, state: .progress(value: progress), on: positon)
    }
    
    /// 显示文本和预定义类型
    public class func show(title: String = "",
                           state: ZVProgressHUD.StateType = .indicator,
                           on positon: ZVProgressHUD.DisplayPosition = .center) {
        self.show(with: .state(title: title, state: state), on: positon)
    }
    
    /// 显示自定义视图
    public class func show(view: UIView,
                           on positon: ZVProgressHUD.DisplayPosition = .center) {
        self.show(with: .custom(view: view), on: positon)
    }
    
    /// 根据显示类型进行显示
    public class func show(with displayType: ZVProgressHUD.DisplayType,
                           on positon: ZVProgressHUD.DisplayPosition = .center) {
        self.shared._show(with: displayType, on: positon)
    }
    
    /// 根据显示类型进行显示
    fileprivate func _show(with displayType: ZVProgressHUD.DisplayType,
                           on positon: ZVProgressHUD.DisplayPosition = .center) {
        
        DispatchQueue.main.async {
            guard let keyWindow = self.keyWindow else { return }
            
            var animated: Bool = true
            // 如果已经添加到window 不重复添加动画
            if self.superview != nil && self.alpha == 1.0 {
                animated = false
            } else {
                self.alpha = 0
            }
            
            self.displayPosition = positon
            self.displayType = displayType

            if self.superview == nil {
                keyWindow.addSubview(self)
            } else {
                self.superview?.bringSubview(toFront: self)
            }

            if animated {
                UIView.animate(withDuration: AnimationDuration.fadeIn, animations: {
                    self.alpha = 1.0
                })
            }
            
            if self._fadeOutTimer != nil { self._removeTimer() }
            if self.fadeOut.0 { self._addTimer() }
        }
    }
    
    /// 隐藏视图
    public class func dismiss() {
        self.shared._dismiss()
    }
    
    fileprivate func _dismiss() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: AnimationDuration.fadeOut, animations: {
                self.alpha = 0.0
            }, completion: { finished in
                self.removeFromSuperview()
            })
        }
    }
    
    private func _addTimer() {
        self._fadeOutTimer = Timer.schedule(delay: self.fadeOut.1, handler: { (timer) in
            self._dismiss()
            self._removeTimer()
        })
    }
    
    private func _removeTimer() {
        self._fadeOutTimer?.invalidate()
        self._fadeOutTimer = nil
    }
    
    /// key window
    fileprivate var keyWindow: UIWindow? {
        for window in UIApplication.shared.windows {
            if window.screen == UIScreen.main &&
                window.isHidden == false && window.alpha > 0 &&
                window.windowLevel == UIWindowLevelNormal {
                return window
            }
        }
        return nil
    }
    
    fileprivate var keyboardFrame: CGRect {
        
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
        
        var containerView: UIView!
        if keyboardWindow == nil { return .zero }
        if keyboardWindow.isHidden { return .zero }
        for subview in keyboardWindow.subviews {
            if NSStringFromClass(subview.classForCoder) == "UIInputSetContainerView" {
                containerView = subview
            }
        }
        
        if containerView == nil { return .zero }
        for subview in containerView.subviews {
            if NSStringFromClass(subview.classForCoder) == "UIInputSetHostView" {
                return subview.frame
            }
        }
        
        return .zero
    }
    
    fileprivate var fadeOut: (Bool, TimeInterval) {
        let delay: TimeInterval = self.delay > 0 ? self.delay : 3.0
        switch self.displayType {
        case .text:
            return (true, delay)
        case .custom:
            return (false, delay)
        case .state(_, let state):
            switch state {
            case .custom, .error, .success, .warning:
                return (true, delay)
            default:
                return (false, delay)
            }
        }
    }
}

// MARK: - 工具类
fileprivate extension UILabel {

    func textSize(with maxSize: CGSize) -> CGSize {
        if let value = self.text as NSString? {
            let size = value.boundingRect(with: maxSize,
                                          options: .usesLineFragmentOrigin,
                                          attributes: [NSAttributedStringKey.font: self.font],
                                          context: nil).size
            
            return CGSize(width: size.width + 0.5, height: size.height + 0.5);
        }
        return .zero
    }
}

extension Timer {
    
    @discardableResult
    class func schedule(delay: TimeInterval, handler: @escaping(Timer?) -> Void) -> Timer {
        
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .commonModes)
        return timer!
    }
}


// MARK: - 通知定义

public extension Notification.Name {
    
    static let ZVProgressHUDDidReceiveTouchEvent = Notification.Name(rawValue: "com.zevwings.progresshud.touchup.inside")
}

