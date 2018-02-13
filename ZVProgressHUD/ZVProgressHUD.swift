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
        case text(content: String)
        case custom(view: UIView)
    }
    
    public enum DisplayStyle {
        case ligtht
        case dark
        case custom(backgroundColor: UIColor, foregroundColor: UIColor)
    }
    
    private var indicatorView: IndicatorView?
    private var titleLabel: UILabel?
    private var baseView: UIControl?
    private var containerView: CoverView?
    
    public var displayType: DisplayType = .indicator(title: "", type: .success)
    public var displayStyle: DisplayStyle = .ligtht
    public var maskType: CoverView.MaskType = .none
    
    public convenience init(_ displayType: DisplayType, displayStyle: DisplayStyle = .ligtht) {
        self.init(frame: .zero)
        
        self.displayType = displayType
        self.displayStyle = displayStyle
        
        prepare()
        placeSubviews()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepare() {
        
        if containerView == nil {
            containerView = CoverView()
            containerView?.maskType = maskType
        }
        
        if baseView == nil {
            baseView = UIControl()
        }
        
        switch displayType {
        case .indicator(let title, let type):
            
            if titleLabel == nil, let title = title, !title.isEmpty {
                titleLabel = UILabel()
                titleLabel?.minimumScaleFactor = 0.5
                titleLabel?.textAlignment = .center
                titleLabel?.isUserInteractionEnabled = false
                titleLabel?.font = .systemFont(ofSize: 16.0)
                titleLabel?.backgroundColor = .clear
            }
            titleLabel?.textColor = displayStyle.foregroundColor
            titleLabel?.text = title
            
            if indicatorView == nil {
                indicatorView = IndicatorView()
                addSubview(indicatorView!)
            }
            
            indicatorView?.indcatorType = type
            indicatorView?.tintColor = displayStyle.foregroundColor

            break
        case .text(let content): break
        case .custom(let view): break
        }
        
        if let containerView = containerView, containerView.superview == nil {
            addSubview(containerView)
        }
        
        if let baseView = baseView, baseView.superview == nil {
            containerView?.addSubview(baseView)
        }
        
        if let titleLabel = titleLabel, titleLabel.superview == nil {
            baseView?.addSubview(titleLabel)
        }
        
        if let indicatorView = indicatorView, indicatorView.superview == nil {
            baseView?.addSubview(indicatorView)
        }
    }
    
    func placeSubviews() {
        
        if let titleLabel = titleLabel {
            titleLabel.frame = CGRect(x: 100, y: 100, width: 100, height: 21)
        }
        
        if let indicatorView = indicatorView {
            indicatorView.frame = CGRect(x: 100, y: 130, width: 38, height: 38)
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

extension UIView {

}
