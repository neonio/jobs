//
//  CalendarConstant.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255
        let g = CGFloat((hex & 0xFF00) >> 8) / 255
        let b = CGFloat(hex & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
}

extension UILabel {
    func fontAwesome(size: CGFloat = 16, contentStr: String) -> UILabel {
        font = UIFont(name: "FontAwesome", size: size)
        text = contentStr
        return self
    }
}

struct CalendarConstant {
    struct `default` {
        static let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let fontColor = UIColor(white: 0, alpha: 1)
        static let disableFillColor = UIColor(hex: 0xF8F8F8)
        static let normalFillColor = UIColor.white
        static let monthLabelFont = UIFont.systemFont(ofSize: 11)
    }

    struct selectedStyle {
        static let fontColor = UIColor.white
        static let fillColor = UIColor(hex: 0x1072C9)
    }
}
