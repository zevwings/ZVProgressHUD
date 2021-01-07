//
//  ZVProgressView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

class ZVProgressView: UIView {
    
    var strokeWidth: CGFloat = 3.0 {
        didSet {
            foregroundLayer.lineWidth = strokeWidth
            backgroundLayer.lineWidth = strokeWidth
        }
    }
    
    var progressBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            backgroundLayer.strokeColor = progressBackgroundColor.cgColor
        }
    }
    
    var progressForegroundColor: UIColor = .black {
        didSet {
            foregroundLayer.strokeColor = progressForegroundColor.cgColor
        }
    }
    
    var progressLabelColor: UIColor = .black {
        didSet {
            progressLabel.textColor = progressLabelColor
        }
    }
    
    var font: UIFont = .systemFont(ofSize: 12) {
        didSet {
            progressLabel.font = font
        }
    }
    
    var isProgressLabelHidden: Bool = false {
        didSet {
            progressLabel.isHidden = isProgressLabelHidden
        }
    }
    
    var progress: Float = 0.0 {
        didSet {
            foregroundLayer.strokeEnd = CGFloat(progress)
            setNeedsDisplay()
        }
    }
    
    private lazy var progressLabel : UILabel = {
       let label = UILabel()
        label.textColor = progressLabelColor
        label.font = font
        label.textAlignment = .center
        label.frame = bounds
        return label
    }()

    private lazy var foregroundLayer: CAShapeLayer = {
        
        let foregroundLayer = CAShapeLayer()
        foregroundLayer.lineCap = .round
        foregroundLayer.lineWidth = strokeWidth
        foregroundLayer.frame = bounds
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeStart = 0.0
        foregroundLayer.strokeEnd = 0.0

        return foregroundLayer
    }()
    
    private lazy var backgroundLayer: CAShapeLayer = {
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.lineCap = .round
        backgroundLayer.lineWidth = strokeWidth
        backgroundLayer.frame = bounds
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeStart = 0.0
        backgroundLayer.strokeEnd = 1.0
        
        return backgroundLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(progressLabel)
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer)
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .clear
        
        let rect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        foregroundLayer.frame = rect
        backgroundLayer.frame = rect
        progressLabel.frame = rect
        prepare()
    }
    
    private func prepare() {
        
        let arcCenter = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        let radius = (min(self.bounds.height, self.bounds.width) - self.strokeWidth) / 2.0
        let startAngle = -CGFloat.pi / 2
        let endAngle = CGFloat.pi * 3 / 2

        let bezierPath = UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        foregroundLayer.path = bezierPath.cgPath
        backgroundLayer.path = bezierPath.cgPath
        
    }
    
    func updateProgress(_ progress: Float) {
        
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        CATransaction.setAnimationDuration(0.15)
        foregroundLayer.strokeEnd = CGFloat(progress)
        progressLabel.text = "\(Int(progress * 100))%"
        CATransaction.commit()
    }
}

#endif
