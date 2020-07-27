//
//  DisplayStyle.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2019/10/8.
//  Copyright © 2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

public enum DisplayStyle {
    case light
    case dark
    case custom((backgroundColor: UIColor, foregroundColor: UIColor))
    
    var foregroundColor: UIColor {
        switch self {
        case .dark: return .white
        case .light: return UIColor(white: 0.2, alpha: 1)
        case .custom(let (foregroundColor, _)): return foregroundColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .dark: return UIColor(white: 0, alpha: 0.75)
        case .light: return .white
        case .custom(let (_, backgroundColor)): return backgroundColor
        }
    }
}

#endif
