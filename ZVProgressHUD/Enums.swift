//
//  DisplayType.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2019/10/8.
//  Copyright © 2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

// MARK: - ZVProgressHUD.DisplayType

public extension ZVProgressHUD {

    enum DisplayType {
        case indicator(title: String?, type: ZVIndicatorView.IndicatorType)
        case text(value: String)

        var dismissAtomically: Bool {
            switch self {
            case .text:
                return true
            case .indicator(_, let type):
                switch type {
                case .success, .error, .warning:
                    return true
                case .image(_, let dismissAtomically):
                    return dismissAtomically
                default:
                    return false
                }
            }
        }

        var title: String {
            switch self {
            case .text(let value): return value
            case .indicator(let title, _): return title ?? ""
            }
        }

        var indicatorType: ZVIndicatorView.IndicatorType {
            switch self {
            case .text: return .none
            case .indicator(_, let type): return type
            }
        }

        func getDisplayTimeInterval(
            _ minimumDismissTimeInterval: TimeInterval,
            _ maximumDismissTimeInterval: TimeInterval
        ) -> TimeInterval {

            var displayTimeInterval: TimeInterval = dismissAtomically ? 3.0 : 0

            guard displayTimeInterval > 0 else { return 0 }

            displayTimeInterval = max(Double(title.count) * 0.06 + 0.5, minimumDismissTimeInterval)
            displayTimeInterval = min(displayTimeInterval, maximumDismissTimeInterval)

            return displayTimeInterval
        }
    }
}

// MARK: - ZVProgressHUD.DisplayStyle

public extension ZVProgressHUD {

    enum DisplayStyle {
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
}

// MARK: - ZVProgressHUD.MaskType

public extension ZVProgressHUD {

    enum MaskType {
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
}

// MARK: - ZVIndicatorView.IndicatorType

public extension ZVIndicatorView {

    enum IndicatorType {
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
}

#endif
