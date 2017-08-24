//
//  ZVStateView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit

// MARK: - 状态指示

internal class ZVStateView: UIView {
    
    internal var color: UIColor?
    internal var animationType: ZVProgressHUD.AnimationType = .extended
    internal var lineWidth: CGFloat = 2.5 {
        didSet {
            self._progressView.lineWidth = self.lineWidth
            self._indicatorView.lineWidth = self.lineWidth
        }
    }
    
    override var frame: CGRect {
        didSet {
            let frame = CGRect(origin: .zero,
                               size: .init(width: self.frame.width, height: self.frame.height))
            self._imageView.frame = frame
            self._indicatorView.frame = frame
            self._progressView.frame = frame
            self._nativeIndicatorView.frame = frame
        }
    }
    
    /// 设置状态类型
    internal var stateType: ZVProgressHUD.StateType = .indicator {
        didSet {
            switch self.stateType {
            case .error, .success, .warning:
                
                if _indicatorView.superview != nil {
                    _indicatorView.removeFromSuperview()
                }
                if _nativeIndicatorView.superview != nil {
                    _nativeIndicatorView.removeFromSuperview()
                }
                if _progressView.superview != nil {
                    _progressView.removeFromSuperview()
                }
                if _imageView.superview == nil {
                    self.addSubview(_imageView)
                }
                let image = UIImage(resource: stateType.path)
                _imageView.setImage(image, foregroundColor: color)
                break
                
            case .indicator:
                
                if _imageView.superview != nil {
                    _imageView.removeFromSuperview()
                }
                if _progressView.superview != nil {
                    _progressView.removeFromSuperview()
                }
                if self.animationType == .extended {
                    if _nativeIndicatorView.superview != nil {
                        _nativeIndicatorView.removeFromSuperview()
                    }
                    if _indicatorView.superview == nil {
                        self.addSubview(_indicatorView)
                        _indicatorView.color = self.color
                        _indicatorView.lineWidth = self.lineWidth
                    }
                    _indicatorView.startAnimating()
                } else {
                    if _indicatorView.superview != nil {
                        _indicatorView.removeFromSuperview()
                    }
                    if _nativeIndicatorView.superview == nil {
                        self.addSubview(_nativeIndicatorView)
                        let center = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
                        _nativeIndicatorView.center = center
                        self._nativeIndicatorView.color = self.color
                    }
                    _nativeIndicatorView.startAnimating()
                }
                break
                
            case .progress(let value):
                if _imageView.superview != nil {
                    _imageView.removeFromSuperview()
                }
                if _indicatorView.superview != nil {
                    _indicatorView.removeFromSuperview()
                }
                if _nativeIndicatorView.superview != nil {
                    _nativeIndicatorView.removeFromSuperview()
                }
                if _progressView.superview == nil {
                    self.addSubview(_progressView)
                    _progressView.color = color
                    _progressView.lineWidth = self.lineWidth
                }
                _progressView.update(progress: value)
                break
                
            case .custom(let image):
                
                if _indicatorView.superview != nil {
                    _indicatorView.removeFromSuperview()
                }
                if _progressView.superview != nil {
                    _progressView.removeFromSuperview()
                }
                if _imageView.superview == nil {
                    self.addSubview(_imageView)
                }
                _imageView.image = image
                break
            }
        }
    }
    
    // MARK: 基础控件
    private lazy var _indicatorView: ZVActivityIndicatorView = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let indicatorView = ZVActivityIndicatorView(frame: frame)
        indicatorView.hiddenWhenStopped = true
        indicatorView.lineWidth = 2.5
        return indicatorView
    }()
    
    private lazy var _nativeIndicatorView: UIActivityIndicatorView = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let indicatorView = UIActivityIndicatorView(frame: frame)
        indicatorView.activityIndicatorViewStyle = .whiteLarge
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    private lazy var _progressView: ZVProgressView = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let progressView = ZVProgressView(frame: frame)
        progressView.lineWidth = 2
        return progressView
    }()
    
    private lazy var _imageView: UIImageView = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let imageView = UIImageView(frame: frame)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // MARK: 初始化状态
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
}

// MARK: - 工具类

fileprivate extension UIImage {
    
    convenience init?(resource name: String) {
        let path = Bundle(for: ZVProgressHUD.self).bundlePath.appendingFormat("/Resource.bundle/%@", name)
        self.init(named: path)
    }
}

fileprivate extension UIImageView {
    
    func setImage(_ image: UIImage?, foregroundColor: UIColor?) {
        
        guard let img = image, let fgColor = foregroundColor else { return }
        let rect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, img.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        img.draw(in: rect)
        context.setFillColor(fgColor.cgColor)
        context.setBlendMode(CGBlendMode.sourceAtop)
        context.fill(rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = result
    }
}
