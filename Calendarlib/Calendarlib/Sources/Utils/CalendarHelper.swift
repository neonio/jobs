//
//  CalendarConstant.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript(i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[start..<end])
    }

    func strHash() -> UInt64 {
        var result = UInt64(5381)
        let buf = [UInt8](utf8)
        for b in buf {
            result = 127 * (result & 0x00FFFFFFFFFFFFFF) + UInt64(b)
        }
        return result
    }

    func short() -> String {
        var result = ""
        let nameSet = self.split(separator: " ")
        if let pre = nameSet.first?.first {
            result += String(pre)
        }
        
        
        if nameSet.count > 1, let last = nameSet.last?.first {
            result += String(last)
        }
        return result.uppercased()
    }
    
    func color() -> UIColor {
        if isEmpty {
            return UIColor.white
        } else {
            var val = strHash() % 1000000
            let red = CGFloat(val % 100) / 100.0
            val = val / 100
            let green = CGFloat(val % 100) / 100.0
            val = val / 100
            let blue = CGFloat(val % 100) / 100.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
    }
}

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

extension UIBarButtonItem {
    @discardableResult
    func fontAwesome(size: CGFloat) -> UIBarButtonItem {
        setTitleTextAttributes([NSAttributedString.Key.font: IconFont.font(size: size)], for: UIControl.State.normal)
        setTitleTextAttributes([NSAttributedString.Key.font: IconFont.font(size: size)], for: UIControl.State.highlighted)
        setTitleTextAttributes([NSAttributedString.Key.font: IconFont.font(size: size)], for: UIControl.State.selected)
        setTitleTextAttributes([NSAttributedString.Key.font: IconFont.font(size: size)], for: UIControl.State.disabled)
        return self
    }
}

extension UILabel {
    @discardableResult
    func fontAwesome(size: CGFloat = 16) -> UILabel {
        font = IconFont.font(size: size)
        return self
    }
}

extension UIImage {
    static func image(withColor: UIColor, size: CGSize = CGSize(width: 4, height: 4), cornerRadius: CGFloat = 0, strokeWidth: CGFloat? = nil, strokeColor: UIColor? = nil) -> UIImage? {
        let opaque = cornerRadius == 0.0
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(withColor.cgColor)
        if cornerRadius > 0 {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
            path.addClip()
            path.fill()
            if let strokeWidth = strokeWidth, let strokeColor = strokeColor {
                context?.setStrokeColor(strokeColor.cgColor)
                path.lineWidth = strokeWidth
                path.stroke()
            }
        } else {
            context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }

    static func image(string: String, size: CGSize, color: UIColor, font: UIFont, fontColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        let baseRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: baseRect, cornerRadius: size.width / 2)
        path.addClip()
        path.fill()
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                                    NSAttributedString.Key.foregroundColor: fontColor]
        let str = NSString(string: string)
        let stringSize = str.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: attrs, context: nil)
        str.draw(at: CGPoint(x: (size.width - stringSize.width) / 2, y: (size.height - stringSize.height) / 2 ), withAttributes: attrs)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

struct CalendarConstant {
    struct `default` {
        static let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let black = UIColor(white: 0, alpha: 0.8)
        static let fontColor = UIColor(white: 0, alpha: 0.6)
        static let disableFillColor = UIColor(hex: 0xF8F8F8)
        static let normalFillColor = UIColor.white
        static let monthLabelFont = UIFont.systemFont(ofSize: 11)
    }

    struct selectedStyle {
        static let fontColor = UIColor.white
        static let fillColor = UIColor(hex: 0x1072C9)
        static let fillBackgroundColor = UIColor(hex: 0x0078D6)
    }

    struct tableview {
        static let darkColor = UIColor(white: 0, alpha: 1)
        static let grayColor = UIColor(hex: 0x8E8D92)
    }
}
