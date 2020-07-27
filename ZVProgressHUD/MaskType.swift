//
//  MaskType.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2019/10/8.
//  Copyright © 2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

public enum MaskType {
    case none
    case clear
    case black
    case custom(color: UIColor)
    
    var backgroundColor: CGColor {
        switch self {
        case .none, .clear: return UIColor.clear.cgColor
        case .black: return UIColor.init(white: 0, alpha: 0.3).cgColor
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

#endif
