//
//  ZVDownloadingView.swift
//  ZVProgressHUDExample
//
//  Created by zevwings on 2020/12/22.
//  Copyright © 2020 zevwings. All rights reserved.
//

import UIKit
import ZVProgressHUD

class ZVDownloadingView: UIView {

    private lazy var containerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 28, width: 210, height: 104))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.contentMode = .topRight
        button.addTarget(self, action: #selector(closeButonClicked(_:)), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12)
        return button
    }()
    
    private lazy var progressView: ZVProgressView = {
        let view = ZVProgressView(frame: CGRect(x: 76, y: 42, width: 58, height: 58))
        view.strokeColor = UIColor(red: 0.90, green: 0, blue: 0.27, alpha: 1)
        view.progressLabelColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)
        view.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return view
    }()
 
    private lazy var describeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 44, width: 170, height: 20))
        label.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment  = .center
        return label
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 210, height: 160))
        
        addSubview(containerView)
        
        containerView.frame = CGRect(x: 0, y: 28, width: 210, height: 104)
        containerView.addSubview(closeButton)
        closeButton.frame = CGRect(x: 166, y: 0, width: 44, height: 44)
        containerView.addSubview(describeLabel)
        describeLabel.frame = CGRect(x: 42, y: 44, width: 126.0, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        containerView.frame = CGRect(x: 0, y: 0, width: 210, height: 160)
        containerView.addSubview(progressView)
        progressView.frame = CGRect(x: 76, y: 42, width: 58, height: 58)
        describeLabel.frame = CGRect(x: 63, y: 111, width: 84, height: 20)
    }
    
    func update(_ progress: Float) {
        describeLabel.text = "Progress \("\(Int(progress * 100))%")"
        progressView.updateProgress(progress)
    }
    
    func show(with title: String) {
        describeLabel.text = title
    }

    func dismiss() {
        progressView.removeFromSuperview()
        containerView.frame = CGRect(x: 0, y: 28, width: 210, height: 104)
        describeLabel.frame = CGRect(x: 42, y: 44, width: 126.0, height: 20)
    }
    
    @objc private func closeButonClicked(_ sender: Any) {
        dismiss()
        ZVProgressHUD.dismiss()
        
    }
}

private class ZVProgressView: UIView {
    
    var strokeWidth: CGFloat = 3.0 {
        didSet {
            foregroundLayer.lineWidth = strokeWidth
            backgroundLayer.lineWidth = strokeWidth
        }
    }
    
    var strokeColor: UIColor = .black {
        didSet {
            foregroundLayer.strokeColor = strokeColor.cgColor
            backgroundLayer.strokeColor = strokeColor.withAlphaComponent(0.5).cgColor
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
        label.textColor = strokeColor
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
        let radius = (min(self.bounds.height, self.bounds.width) - self.strokeWidth * 2) / 2.0
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

