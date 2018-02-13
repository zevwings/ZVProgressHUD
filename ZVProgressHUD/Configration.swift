//
//  Configration.swift
//  ZVProgressHUD
//
//  Created by 张伟 on 2018/2/13.
//  Copyright © 2018年 zevwings. All rights reserved.
//

import UIKit

public extension Notification.Name {
    struct ZVProgressHUD {
        static let ReceivedTouchEvent = Notification.Name(rawValue: "com.zevwings.progresshud.touchup.inside")
    }
}

extension UIImage {
    convenience init?(resource name: String) {
        guard let path = Bundle(for: IndicatorView.self).path(forResource: "Resource", ofType: "bundle") else { return nil }
        let bundle = Bundle(path: path)
        guard let fileName = bundle?.path(forResource: name, ofType: "png") else { return nil }
        self.init(contentsOfFile: fileName)
    }
}

