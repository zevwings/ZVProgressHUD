//
//  ZVProgressView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit

public class ZVProgressView: UIView {

    private struct Default {
        static let lineWidth: CGFloat = 3
    }
    
    internal var lineWidth: CGFloat = Default.lineWidth {
        didSet {
            self._prepare()
        }
    }
    
    override public var frame: CGRect {
        didSet {
        }
    }
    
    internal var color: UIColor?{
        get {
            if let strokeColor = self._foregroundLayer.strokeColor {
                return UIColor(cgColor: strokeColor)
            }
            return nil
        }
        set {
            self._foregroundLayer.strokeColor = newValue?.cgColor
            self._backgroundLayer.strokeColor = newValue?.withAlphaComponent(0.5).cgColor
        }
    }

    private lazy var _foregroundLayer: CAShapeLayer = { [unowned self] in
        
        let foregroundLayer = CAShapeLayer()
        foregroundLayer.lineCap = kCALineCapRound
        foregroundLayer.lineWidth = self.lineWidth
        foregroundLayer.frame = self.bounds
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = UIColor.white.cgColor
        foregroundLayer.strokeStart = 0.0
        foregroundLayer.strokeEnd = 0.0

        return foregroundLayer
    }()
    
    private lazy var _backgroundLayer: CAShapeLayer = {
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineCap = kCALineCapRound
        backgroundLayer.lineWidth = self.lineWidth
        backgroundLayer.frame = self.bounds
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.black.cgColor
        backgroundLayer.strokeStart = 0.0
        backgroundLayer.strokeEnd = 1.0
        
        return backgroundLayer
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.addSublayer(_backgroundLayer)
        self.layer.addSublayer(_foregroundLayer)
        self.layer.masksToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self._foregroundLayer.frame = rect
        self._backgroundLayer.frame = rect
        self._prepare()
 
    }
    
    private func _prepare() {
        
        let arcCenter: CGPoint = .init(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        let radius: CGFloat = (min(self.bounds.width, self.bounds.height) - self.lineWidth * 2) / 2
        let startAngle = CGFloat( -0.5 * Double.pi)
        let endAngle = CGFloat(1.5 * Double.pi)

        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        self._foregroundLayer.path = path
        self._backgroundLayer.path = path
    }
    
    internal func update(progress value: Float) {
        
        var v = value
        if value > 1.0 { v = 1.0 }
        if value < 0.0 { v = 0.0 }
    
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
        CATransaction.setAnimationDuration(0.25)
        self._foregroundLayer.strokeEnd = CGFloat(v)
        CATransaction.commit()
    }
}


