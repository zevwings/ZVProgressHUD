//
//  ZVBackgroundView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit

internal class ZVBackgroundView: UIControl {
    
    private lazy var _coloredLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    
    internal override var frame: CGRect {
        didSet {
            self._coloredLayer.frame = frame
        }
    }
    
    internal var maskType: ZVProgressHUD.MaskType = .none {
        didSet {
            if self._coloredLayer.superlayer == nil {
                self.layer.addSublayer(_coloredLayer)
            }
            switch self.maskType {
            case .none:
                self._coloredLayer.backgroundColor = UIColor.clear.cgColor
                self.isUserInteractionEnabled = false
                break
            case .clear:
                self._coloredLayer.backgroundColor = UIColor.clear.cgColor
                self.isUserInteractionEnabled = true
                break
            case .black:
                self._coloredLayer.backgroundColor = UIColor(white: 0, alpha: 0.35).cgColor
                self.isUserInteractionEnabled = true
                break
            case .custom(let color):
                self._coloredLayer.backgroundColor = color.cgColor
                self.isUserInteractionEnabled = true
                break
            }
        }
    }
    
    // MARK: 初始化方法
    
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
