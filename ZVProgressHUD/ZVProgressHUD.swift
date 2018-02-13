//
//  ZVProgressHUD.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/12.
//  Copyright © 2017年 zevwings. All rights reserved.
//

public class ZVProgressHUD: UIView {

    public enum DisplayType {
        case indicator(title: String?, type: IndicatorView.IndicatorType)
        case text(title: String)
        case custom(animationImages: [UIImage])
    }
    
    public enum DisplayStyle {
        case light
        case dark
        case custom(backgroundColor: UIColor, foregroundColor: UIColor)
    }
    
    private var indicatorView: IndicatorView?
    private var titleLabel: UILabel?
    private var baseView: UIControl?
    private var coverView: CoverView?
    
    public var displayType: DisplayType = .indicator(title: "", type: .success)
    public var displayStyle: DisplayStyle = .light
    public var maskType: CoverView.MaskType = .black
    public var cornerRadius: CGFloat = 8.0
    
    public var titleEdgeInsets: UIEdgeInsets = .zero
    public var indicatorEdgeInsets: UIEdgeInsets = .zero

    public convenience init(_ displayType: DisplayType, displayStyle: DisplayStyle = .light) {
        self.init(frame: .zero)
        
        self.displayType = displayType
        self.displayStyle = displayStyle
        prepare()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubviews()
    }
    
    func prepare() {
        
        if coverView == nil {
            coverView = CoverView()
        }
        coverView?.maskType = maskType

        if baseView == nil {
            baseView = UIControl()
        }
        baseView?.backgroundColor = displayStyle.backgroundColor
        baseView?.layer.cornerRadius = cornerRadius
        
        switch displayType {
        case .indicator(let title, let type):
            
            if titleLabel == nil, let title = title, !title.isEmpty {
                titleLabel = UILabel.default
            }
            titleLabel?.textColor = displayStyle.foregroundColor
            titleLabel?.text = title
            
            if indicatorView == nil {
                indicatorView = IndicatorView()
            }
            
            indicatorView?.indcatorType = type
            indicatorView?.tintColor = displayStyle.foregroundColor

            break
        case .text(let title):
            
            if titleLabel == nil, !title.isEmpty {
                titleLabel = UILabel.default
            }
            titleLabel?.textColor = displayStyle.foregroundColor
            titleLabel?.text = title

            break
        case .custom(let animationImages):
            
            if indicatorView == nil {
                indicatorView = IndicatorView()
            }
            
            indicatorView?.indcatorType = .custom(animationImages: animationImages, duration: 0.3)
            indicatorView?.tintColor = displayStyle.foregroundColor
            
            break
        }
        
        if let coverView = coverView, coverView.superview == nil {
            addSubview(coverView)
        }
        
        if let baseView = baseView, baseView.superview == nil {
            coverView?.addSubview(baseView)
        }
        
        if let titleLabel = titleLabel, titleLabel.superview == nil {
            baseView?.addSubview(titleLabel)
        }
        
        if let indicatorView = indicatorView, indicatorView.superview == nil {
            baseView?.addSubview(indicatorView)
        }
    }
    
    func placeSubviews() {

        coverView?.frame = frame

        var textSize: CGSize = .zero
        if let titleLabel = titleLabel {
            let maxSize = CGSize(width: frame.width * 0.7, height: frame.width * 0.7)
            textSize = titleLabel.getTextWidth(with: maxSize)
            titleLabel.frame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        }
        
        if let indicatorView = indicatorView {
            indicatorView.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
        }
        
        
        baseView?.frame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let sv = newSuperview {
            self.frame = sv.frame
        } else {
            self.frame = .zero
        }
    }
    
}

public extension ZVProgressHUD {
    
    func setMaskType(_ maskType: CoverView.MaskType) {
        coverView?.maskType = maskType
//        self.maskType = maskType;
    }
    
    func setDisplayType(_ displayType: DisplayStyle) {
        
    }
}

public extension ZVProgressHUD.DisplayType {
    
}

extension ZVProgressHUD.DisplayStyle {
    
    var foregroundColor: UIColor {
        switch self {
        case .dark:
            return .white
        case .light:
            return .init(white: 0.2, alpha: 1)
        case .custom(let color):
            return color.foregroundColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .dark:
            return .init(white: 0, alpha: 0.75)
        case .light:
            return .white
        case .custom(let color):
            return color.backgroundColor
        }
    }
}

extension UIView {

}

extension UILabel {
    
    class var `default`: UILabel {
        let label = UILabel()
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.font = .systemFont(ofSize: 16.0)
        label.backgroundColor = .clear
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return label
    }
    
    func getTextWidth(with maxSize: CGSize) -> CGSize {
        guard let text = self.text, !text.isEmpty else { return .zero }
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics, .truncatesLastVisibleLine]
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: self.font]
        return (text as NSString).boundingRect(with: maxSize, options: options, attributes: attributes, context: nil).size
    }

}
