//
//  ZVProgressView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit

internal class ZVProgressView: UIView {

    private struct Default {
        static let progressLineWidth: CGFloat = 3.0
    }
    
    internal var lineWidth: CGFloat = 3.0 {
        didSet {
            self._progressLayer.lineWidth = self.lineWidth
            self._backgroundLayer.lineWidth = self.lineWidth * 0.5
            self._prepare()
        }
    }
    
    internal var color: UIColor? {
        get {
            if let strokeColor = self._progressLayer.strokeColor {
                return UIColor(cgColor: strokeColor)
            }
            return nil
        }
        set {
            self._backgroundLayer.strokeColor = newValue?.withAlphaComponent(0.75).cgColor
            self._progressLayer.strokeColor = newValue?.cgColor
        }
    }
    
    private lazy var _backgroundLayer: CAShapeLayer = {
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor(white: 1.0, alpha: 0.75).cgColor
        backgroundLayer.lineWidth = 1.5
        return backgroundLayer
    }()

    private lazy var _progressLayer: CAShapeLayer = {
        
        let progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 3
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0

        return progressLayer
    }()
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(_backgroundLayer)
        self.layer.addSublayer(_progressLayer)
    }
    
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        self._backgroundLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self._progressLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self._prepare()
    }
    
    private func _prepare() {
        
        self._backgroundLayer.path = self._getPath(by: _backgroundLayer)
        self._progressLayer.path = self._getPath(by: _progressLayer)
    }
    
    
    private func _getPath(by layer: CAShapeLayer) -> CGPath {
        let lineWidth = layer == self._backgroundLayer ? Default.progressLineWidth * 0.5 : Default.progressLineWidth
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.bounds.width * 0.5, self.bounds.height * 0.5) - lineWidth
        let startAngle = CGFloat( -0.5 * Double.pi)
        let endAngle = CGFloat(1.5 * Double.pi)
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
    }
    
    internal func update(progress value: Float) {
        var v = value
        if value > 1.0 { v = 1.0 }
        if value < 0.0 { v = 0.0 }
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
        CATransaction.setAnimationDuration(0.5)
        self._progressLayer.strokeEnd = CGFloat(v)
        CATransaction.commit()
    }
}


