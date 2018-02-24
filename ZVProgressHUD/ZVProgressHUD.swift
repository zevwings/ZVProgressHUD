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
    
    var displayType: DisplayType = .indicator(title: "", type: .success)
    var displayStyle: DisplayStyle = .light
    var maskType: CoverView.MaskType = .black
    var cornerRadius: CGFloat = 8.0
    
    var contentInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    var titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
    var indicatorSize: CGSize = .zero
    var indicatorEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    private var indicatorView: IndicatorView?
    private var titleLabel: UILabel?
    private var baseView: UIControl?
    private var coverView: CoverView?
    
    override init(frame: CGRect) {
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
            if indicatorSize != .zero {
                indicatorSize = self.indicatorSize
            } else {
                indicatorSize = CGSize(width: 38, height: 38)
            }
            indicatorView.frame = CGRect(origin: .zero, size: indicatorSize)
        }
        
        var titleSize: CGSize = .zero
        if let titleLabel = titleLabel {
            titleSize = titleLabel.getTextWidth(with: CGSize(width: frame.width * 0.7, height: frame.width * 0.7))
            titleLabel.frame = CGRect(origin: .zero, size: titleSize)
        }
        
        var contentSize: CGSize = .zero
        var titleCenter: CGPoint = .zero
        var indicatorCenter: CGPoint = .zero
        
        if indicatorSize != .zero && titleSize != .zero {
            
            let titleWidth = titleSize.width + titleEdgeInsets.left + titleEdgeInsets.right
            let titleHeight = titleSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
            let indicatorWidth = indicatorSize.width + indicatorEdgeInsets.left + indicatorEdgeInsets.right
            let indicatorHeight = indicatorSize.height + indicatorEdgeInsets.top + indicatorEdgeInsets.bottom
            let width = max(titleWidth, indicatorWidth) + contentInsets.left + contentInsets.right
            let height = titleHeight + indicatorHeight + contentInsets.top + contentInsets.bottom
            
            indicatorCenter = CGPoint(x: width / 2.0, y: indicatorSize.height / 2.0 + contentInsets.top + indicatorEdgeInsets.top)
            titleCenter = CGPoint(x: width / 2.0, y: titleSize.height / 2.0 + titleEdgeInsets.top + contentInsets.top + indicatorSize.height + indicatorEdgeInsets.top + indicatorEdgeInsets.bottom)
            contentSize = CGSize(width: width, height: height)
        } else if indicatorSize == .zero && titleSize != .zero {
            
            let width = titleSize.width + titleEdgeInsets.left + titleEdgeInsets.right + contentInsets.left + contentInsets.right
            let height = titleSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom + contentInsets.top + contentInsets.bottom
            
            titleCenter = CGPoint(x: width / 2.0, y: height / 2.0)
            contentSize = CGSize(width: width, height: height)
        } else if indicatorSize != .zero && titleSize == .zero {
            
            let width = indicatorSize.width + indicatorEdgeInsets.left + indicatorEdgeInsets.right + contentInsets.left + contentInsets.right
            let height = indicatorSize.height + indicatorEdgeInsets.top + indicatorEdgeInsets.bottom + contentInsets.top + contentInsets.bottom
            
            indicatorCenter = CGPoint(x: width / 2.0, y: height / 2.0)
            contentSize = CGSize(width: width, height: height)
        }

        let origin = CGPoint(x: (coverView!.frame.width - contentSize.width) / 2.0, y: (coverView!.frame.height - contentSize.height) / 2.0 - 64)
        
        baseView?.frame = CGRect(origin: origin, size: contentSize)
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

