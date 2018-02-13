//
//  ZVStateView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

// MARK: - 状态指示

public class IndicatorView: UIView {

    public enum IndicatorType {

        case error, success, warning
        case indicator(style: AnimationType)
        case progress(value: Float)
        case custom(image: UIImage)
    }
    
    public enum AnimationType {
        case flat
        case native
    }
    
    private var imageIndicaotorView: UIImageView?
    private var nativeActivityIndicatorView: UIActivityIndicatorView?
    private var flatActivityIndicatorView: ZVActivityIndicatorView?
    private var progressIndicatorView: UIProgressView?
    
    internal var indcatorType: IndicatorType = .success {
        didSet {
            switch indcatorType {
            case .error, .success, .warning:
                setImageIndicatorView()
                let image = UIImage(resource: indcatorType.resource)?.withRenderingMode(.alwaysTemplate)
                imageIndicaotorView?.image = image;
                break
            case .indicator(let style):
                switch (style) {
                case .native:
                    setNativeActivityIndicatorView()
                    break
                case .flat:
                    setFlatActivityIndicatorView()
                    break
                }
                break
            case .progress(let value):
                setProgressIndicatorView()
                self.progressIndicatorView?.progress = value
                break
            case .custom(let image):
                setImageIndicatorView()
                imageIndicaotorView?.image = image
                break
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Method

extension IndicatorView {
    
    private func setImageIndicatorView() {
        
        if imageIndicaotorView == nil {
            imageIndicaotorView = UIImageView(frame: .zero)
            imageIndicaotorView?.tintColor = tintColor
            imageIndicaotorView?.isUserInteractionEnabled = false
        }
        
        if imageIndicaotorView?.superview == nil {
            addSubview(imageIndicaotorView!)
        }
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        progressIndicatorView?.removeFromSuperview()
    }
    
    private func setProgressIndicatorView() {
        
        if progressIndicatorView == nil {
            
        }
    }
    
    private func setNativeActivityIndicatorView() {
        
        if nativeActivityIndicatorView == nil {
            nativeActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            nativeActivityIndicatorView?.color = tintColor
            nativeActivityIndicatorView?.hidesWhenStopped = true
            nativeActivityIndicatorView?.startAnimating()
        }
        
        if nativeActivityIndicatorView?.superview == nil {
            addSubview(nativeActivityIndicatorView!)
        }
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        imageIndicaotorView?.removeFromSuperview()
        progressIndicatorView?.removeFromSuperview()
    }
    
    private func setFlatActivityIndicatorView() {
        
        if flatActivityIndicatorView == nil {
            flatActivityIndicatorView = ZVActivityIndicatorView()
            flatActivityIndicatorView?.tintColor = tintColor
            flatActivityIndicatorView?.hidesWhenStopped = true
            flatActivityIndicatorView?.strokeWidth = 3.0
            flatActivityIndicatorView?.startAnimating()
        }
        
        if flatActivityIndicatorView?.superview == nil {
            addSubview(flatActivityIndicatorView!)
        }
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        imageIndicaotorView?.removeFromSuperview()
        progressIndicatorView?.removeFromSuperview()
    }
    
}

// MARK: - Override

extension IndicatorView {
    
    override public var tintColor: UIColor! {
        didSet {
            imageIndicaotorView?.tintColor = tintColor
            nativeActivityIndicatorView?.color = tintColor
            flatActivityIndicatorView?.tintColor = tintColor
            progressIndicatorView?.tintColor = tintColor
        }
    }
    
//    override public func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//
//        guard newSuperview != nil else { return }
//
//    }
//
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = CGSize(width: frame.width, height: frame.height)
        let subViewFrame = CGRect(origin: .zero, size: size)
        
        imageIndicaotorView?.frame = subViewFrame
        flatActivityIndicatorView?.frame = subViewFrame
        nativeActivityIndicatorView?.frame = subViewFrame
        progressIndicatorView?.frame = subViewFrame

    }
}

// MARK: - IndicatorView.IndicatorType

extension IndicatorView.IndicatorType : Equatable {
    
    public static func ==(lhs: IndicatorView.IndicatorType, rhs: IndicatorView.IndicatorType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension IndicatorView.IndicatorType : Hashable {
    
    public var hashValue: Int {
        switch self {
        case .error:
            return 0
        case .success:
            return 1
        case .warning:
            return 2
        case .indicator:
            return 3
        case .progress:
            return 4
        case .custom(let image):
            return image.hashValue
        }
    }
}

extension IndicatorView.IndicatorType {
    
    var resource: String {
        switch self {
        case .error:
            return "error"
        case .success:
            return "success"
        case .warning:
            return "warning"
        default:
            return ""
        }
    }
}

