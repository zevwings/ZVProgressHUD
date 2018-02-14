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
    
    public var titleEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    // 同时存在titleLabele 与 indicatorView时 indicatorEdgeInsets.bottom 无效
    public var indicatorEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

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

        var indicatorSize: CGSize = .zero
        if let indicatorView = indicatorView {
            indicatorSize = CGSize(width: 38, height: 38)
            indicatorView.frame = CGRect(origin: .zero, size: indicatorSize)
        }
        
        var titleSize: CGSize = .zero
        if let titleLabel = titleLabel {
            titleSize = titleLabel.getTextWidth(with: CGSize(width: frame.width * 0.7, height: frame.width * 0.7))
            titleLabel.frame = CGRect(origin: .zero, size: titleSize)
        }
        
        var size: CGSize = .zero
        var titleCenter: CGPoint = .zero
        var indicatorCenter: CGPoint = .zero
        
        if indicatorSize != .zero && titleSize != .zero {
            
            let titleWidth = titleSize.width + titleEdgeInsets.left + titleEdgeInsets.right
            let titleHeight = titleSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom * 1.5
            let indicatorWidth = indicatorSize.width + indicatorEdgeInsets.left + indicatorEdgeInsets.right
            let indicatorHeight = indicatorSize.height + indicatorEdgeInsets.top / 2.0
            let width = max(titleWidth, indicatorWidth)
            let height = titleHeight + indicatorHeight
            size = CGSize(width: width, height: height)
            indicatorCenter = CGPoint(x: width / 2.0, y: indicatorSize.height / 2.0 + indicatorEdgeInsets.top / 2.0)
            titleCenter = CGPoint(x: width / 2.0, y: titleSize.height / 2.0  + titleEdgeInsets.top + indicatorSize.height + indicatorEdgeInsets.top / 2.0)
        } else if indicatorSize == .zero && titleSize != .zero {
            
            let width = titleSize.width + titleEdgeInsets.left + titleEdgeInsets.right
            let height = titleSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
            size = CGSize(width: width, height: height)
            titleCenter = CGPoint(x: width / 2.0, y: height / 2.0)
        } else if indicatorSize != .zero && titleSize == .zero {
            
            let width = indicatorSize.width + indicatorEdgeInsets.left + indicatorEdgeInsets.right
            let height = indicatorSize.height + indicatorEdgeInsets.top + indicatorEdgeInsets.bottom
            size = CGSize(width: width, height: height)
            indicatorCenter = CGPoint(x: width / 2.0, y: height / 2.0)
        }

        let origin = CGPoint(x: (coverView!.frame.width - size.width) / 2.0, y: (coverView!.frame.height - size.height) / 2.0 - 64)
        
        baseView?.frame = CGRect(origin: origin, size: size)
        titleLabel?.center = titleCenter
        indicatorView?.center = indicatorCenter
    }
}

extension ZVProgressHUD {
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubviews()
        
        print("self.frame : \(frame)")
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

