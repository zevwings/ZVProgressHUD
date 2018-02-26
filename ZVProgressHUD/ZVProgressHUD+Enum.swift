//
//  ZVProgressHUD+Enum.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2018/2/25.
//  Copyright © 2018年 zevwings. All rights reserved.
//

import Foundation

// MARK: - ZVProgressHUD.DisplayStyle

extension ZVProgressHUD {
    
    public enum DisplayType {
        case indicator(title: String?, type: IndicatorView.IndicatorType)
        case text(title: String)
    }
}

extension ZVProgressHUD.DisplayType {
    
    var dismissTimeInterval: TimeInterval {
        switch self {
        case .text(let title):
            return displayDuration(for: title)
        case .indicator(let title, let type):
            switch type {
            case .success, .error, .warning:
                return displayDuration(for: title)
            case .image(_, let dismissAtomically):
                return dismissAtomically ? displayDuration(for: title) : 0.0
            default:
                return 0.0
            }
        }
    }
    
    private func displayDuration(for title: String?) -> TimeInterval {
        let defaultDismissTimeInterval: TimeInterval = 2.5
        if let title = title, !title.isEmpty {
            return max(Double(title.count) * 0.06 + 0.5, defaultDismissTimeInterval)
        }
        return defaultDismissTimeInterval
    }
}

extension ZVProgressHUD {
    
    public enum DisplayStyle {
        case light
        case dark
        case custom(backgroundColor: UIColor, foregroundColor: UIColor)
    }
}

extension ZVProgressHUD.DisplayStyle {
    var foregroundColor: UIColor {
        switch self {
        case .dark:
            return .white
        case .light:
            return UIColor(white: 0.2, alpha: 1)
        case .custom(let color):
            return color.foregroundColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .dark:
            return UIColor(white: 0, alpha: 0.75)
        case .light:
            return .white
        case .custom(let color):
            return color.backgroundColor
        }
    }
}

// MARK: - ZVProgressHUD.MaskType

extension ZVProgressHUD {
    
    public enum MaskType {
        case none
        case clear
        case black
        case custom(color: UIColor)
    }
}

extension ZVProgressHUD.MaskType {
    
    var backgroundColor: CGColor {
        switch self {
        case .none, .clear: return UIColor.clear.cgColor
        case .black: return UIColor.init(white: 0.0, alpha: 0.3).cgColor
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
