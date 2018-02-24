//
//  ZVBackgroundView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit

public class CoverView: UIControl {
    
    public enum MaskType {
        case none
        case clear
        case black
        case custom(color: UIColor)
    }
    
    private var maskLayer: CALayer?
    
    var maskType: MaskType = .none {
        didSet {
            maskLayer?.backgroundColor = maskType.backgroundColor
            isUserInteractionEnabled = maskType.isUserInteractionEnabled
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        maskLayer = CALayer()
        maskLayer?.backgroundColor = maskType.backgroundColor
        layer.addSublayer(maskLayer!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.maskLayer?.frame = frame
    }
}

extension CoverView.MaskType: Equatable {
    
    public static func ==(lhs: CoverView.MaskType, rhs: CoverView.MaskType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension CoverView.MaskType: Hashable {
    
    public var hashValue: Int {
        switch self {
        case .none:
            return 0
        case .clear:
            return 1
        case .black:
            return 2
        case .custom(let color):
            return color.hashValue
        }
    }
}

extension CoverView.MaskType {
    
    var backgroundColor: CGColor {
        switch self {
        case .none, .clear: return UIColor.clear.cgColor
        case .black: return UIColor.init(white: 0.0, alpha: 0.5).cgColor
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

