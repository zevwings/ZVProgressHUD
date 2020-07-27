//
//  DisplayType.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2019/10/8.
//  Copyright © 2019 zevwings. All rights reserved.
//

#if !os(macOS)

import UIKit

public enum DisplayType {
    case indicator(title: String?, type: IndicatorType)
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
    
    var indicatorType: IndicatorType {
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

#endif
