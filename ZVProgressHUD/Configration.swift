//
//  Configration.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2018/2/13.
//  Copyright © 2018年 zevwings. All rights reserved.
//

import UIKit

public extension Notification.Name {
    static let ZVProgressHUDReceivedEventTouchUpInside = Notification.Name(rawValue: "com.zevwings.progresshud.touchup.inside")
    
    static let ZVProgressHUDWillAppear = Notification.Name("com.zevwings.progresshud.willAppear")
    static let ZVProgressHUDDidAppear = Notification.Name("com.zevwings.progresshud.didAppear")
    
    static let ZVProgressHUDWillDisappear = Notification.Name("com.zevwings.progresshud.willDisappear")
    static let ZVProgressHUDDidDisappear = Notification.Name("com.zevwings.progresshud.didDisappear")
}

extension UIImage {
    convenience init?(resource name: String) {
        guard let path = Bundle(for: ZVProgressHUD.self).path(forResource: "Resource", ofType: "bundle") else { return nil }
        let bundle = Bundle(path: path)
        guard let fileName = bundle?.path(forResource: name, ofType: "png") else { return nil }
        self.init(contentsOfFile: fileName)
    }
}

extension UILabel {
    
    func getTextWidth(with maxSize: CGSize) -> CGSize {
        guard let text = text, !text.isEmpty else { return .zero }
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
        return (text as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
}

