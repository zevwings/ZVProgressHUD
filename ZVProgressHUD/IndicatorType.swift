//
//  IndicatorType.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2019/10/8.
//  Copyright © 2019 zevwings. All rights reserved.
//

import UIKit

public enum IndicatorType {
    case none
    case error, success, warning
    case indicator(style: AnimationType)
    case progress(value: Float)
    case image(value: UIImage, dismissAtomically: Bool)
    case animation(value: [UIImage], duration: TimeInterval)
    
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
    
    var shouldHidden: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    var progressValueChecker: (Bool, Float) {
        switch self {
        case .progress(let value):
            return (true, value)
        default:
            return (false, 0.0)
        }
    }
    
    var showLogo: Bool {
        switch self {
        case .progress:
            return true
        case .indicator(let animationType):
            return animationType == .flat
        default:
            return false
        }
    }

}
