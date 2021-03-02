//
//  UIColorExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import UIKit

extension UIColor {
    /// 十六进制值解析
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /**
     根据RGB生成颜色

     - parameter r: red
     - parameter g: green
     - parameter b: blue
     - parameter alpha: 透明度

     - returns: 颜色
     */
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }

    /// 返回对应颜色的图片
    ///
    /// - Returns:
    public func getImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        if let context = context {
            context.setFillColor(cgColor)
            context.fill(rect)
        }
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }

    /// 随机生成颜色
    public static func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 100) / 100.0
        let saturation = CGFloat(arc4random() % 50) / 100 + 0.5
        let brightness = CGFloat(arc4random() % 50) / 100 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
