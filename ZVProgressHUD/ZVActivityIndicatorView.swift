//
//  ZActivityIndicatorView.swift
//  ZActivityIndicatorView
//
//  Created by ZhangZZZZ on 16/4/25.
//  Copyright © 2016年 ZhangZZZZ. All rights reserved.
//

internal class ZVActivityIndicatorView: UIView {
    
    internal private(set) var isAnimating: Bool = false
    internal var duration: TimeInterval = 1.5
    internal var timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    private lazy var _activityIndicatorLayer: CAShapeLayer = {
        let activityIndicatorLayer = CAShapeLayer()
        activityIndicatorLayer.lineCap = kCALineCapRound
        activityIndicatorLayer.lineWidth = self.lineWidth
        activityIndicatorLayer.frame = self.bounds
        activityIndicatorLayer.fillColor = UIColor.clear.cgColor
        activityIndicatorLayer.strokeColor = UIColor.black.cgColor
        activityIndicatorLayer.strokeStart = 0.0
        activityIndicatorLayer.strokeEnd = 1.0
        return activityIndicatorLayer
    }()
    
    internal var lineWidth: CGFloat = 1.0 {
        didSet {
            self._activityIndicatorLayer.lineWidth = self.lineWidth
            self.prepare()
        }
    }
    
    internal var hiddenWhenStopped: Bool = false {
        didSet {
            self.isHidden = !self.isAnimating && self.hiddenWhenStopped
        }
    }
    
    internal var color: UIColor? {
        get {
            if let strokeColor = self._activityIndicatorLayer.strokeColor {
                return UIColor(cgColor: strokeColor)
            }
            return nil
        }
        set {
            self._activityIndicatorLayer.strokeColor = newValue?.cgColor
        }
    }
    
    override internal init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(self._activityIndicatorLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(ZVActivityIndicatorView.resetAnimating), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    internal convenience init() {
        self.init(frame: .zero)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(NSNotification.Name.UIApplicationDidBecomeActive)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
        self._activityIndicatorLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.prepare()
    }
    
    func prepare() {
        
        let arcCenter: CGPoint = .init(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        let radius: CGFloat = (min(self.bounds.width, self.bounds.height) - self.lineWidth * 2) / 2
        let startAngle = CGFloat( -0.5 * Double.pi)
        let endAngle = CGFloat(1.5 * Double.pi)
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        
        self._activityIndicatorLayer.path = path.cgPath
        self._activityIndicatorLayer.strokeStart = 0.0
        self._activityIndicatorLayer.strokeEnd = 0.0
    }
    
    internal func startAnimating() {
        
        if self.isAnimating { return }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = self.duration / 0.375
        animation.fromValue = 0
        animation.toValue = CGFloat(2 * Double.pi)
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        self._activityIndicatorLayer.add(animation, forKey: "com.zevwings.animation.rotate")
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = self.duration / 1.5
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = self.timingFunction;

        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = self.duration / 1.5
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.timingFunction = self.timingFunction;

        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart";
        endHeadAnimation.beginTime = self.duration / 1.5
        endHeadAnimation.duration = self.duration / 3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = self.timingFunction;

        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = self.duration / 1.5
        endTailAnimation.duration = self.duration / 3.0
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = self.timingFunction;

        let animations = CAAnimationGroup()
        animations.duration = self.duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        animations.isRemovedOnCompletion = false
        self._activityIndicatorLayer.add(animations, forKey: "com.zevwings.animation.stroke")
        
        self.isAnimating = true
 
        if self.hiddenWhenStopped {
            self.isHidden = false
        }
    }
    
    internal func stopAnimating() {
        if !self.isAnimating { return }
        
        self._activityIndicatorLayer.removeAnimation(forKey: "com.zevwings.animation.rotate")
        self._activityIndicatorLayer.removeAnimation(forKey: "com.zevwings.animation.stroke")
        self.isAnimating = false;
        
        if self.hiddenWhenStopped {
            self.isHidden = true
        }
    }
    
    @objc internal func resetAnimating() {
        if self.isAnimating {
            self.stopAnimating()
            self.startAnimating()
        }
    }
}
