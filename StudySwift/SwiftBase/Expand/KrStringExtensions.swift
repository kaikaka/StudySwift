//
//  StringExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import Foundation
import UIKit

extension String {
    /// 根据字面量获取类的类型
    public func classType<T>(_ type: T.Type) -> T.Type? {
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }
        guard let nameSpaceClass = NSClassFromString(nameSpace + "." + self) else {
            return nil
        }
        guard let classType = nameSpaceClass as? T.Type else {
            return nil
        }
        return classType
    }

    /// 根据字面量获取类对象
    public func classObject<T: NSObject>(_ type: T.Type) -> T? {
        guard let classType = classType(T.self) else {
            return nil
        }
        return classType.init()
    }

    /// 填充range内的颜色
    /// - Parameters:
    ///   - foregroundColor: default black
    ///   - font: default 18size
    ///   - range: 范围
    /// - Returns: 富文本
    public func formatColorFontWithText(foregroundColor: UIColor = UIColor.black,
                                        font: UIFont = UIFont.systemFont(ofSize: 18),
                                        range: NSRange = NSRange(location: 0, length: 1)) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: foregroundColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font,
                                      value: font, range: range)
        return attributedString
    }

    // 返回第一次出现的指定子字符串在此字符串中的索引
    // （如果backwards参数设置为true，则返回最后出现的位置）
    public func positionOf(subStr: String, backwards: Bool = false) -> Int {
        var pos = -1
        if let range = range(of: subStr, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                pos = distance(from: startIndex, to: range.lowerBound)
            }
        }
        return pos
    }

    /// 截取 subStr 之后的字符串 到结尾
    /// print("https://common.ofo.com/about/openbike/?http://ofo.so/plate/36237472".subStringAfter(subStr: "plate/")) //36237472
    /// - Parameters:
    ///   - subStr: 固定的字符串之后
    ///   - backwards: 知否从字符串尾部开始搜索
    /// - Returns: 返回截取之后的字符串
    public func subStringAfter(subStr: String, backwards: Bool = false) -> String {
        let startPos = positionOf(subStr: subStr, backwards: backwards)
        // 没有找到就返回全部字符串
        if startPos == -1 {
            return self
        }
        return String(self[(startPos + subStr.count)...])
    }

    /// 从开头截取字符串到  subStr 之前的字符串
    ///
    /// print("https://common.ofo.com/about/openbike/?http://ofo.so/plate/36237472".subStringBefore(subStr: "plate/")) //https://common.ofo.com/about/openbike/?http://ofo.so/
    /// - Parameters:
    ///   - subStr: 固定的字符串之后
    ///   - backwards: 知否从字符串尾部开始搜索
    /// - Returns: 返回截取之后的字符串
    public func subStringBefore(subStr: String, backwards: Bool = false) -> String {
        let startPos = positionOf(subStr: subStr, backwards: backwards)
        // 没有找到就返回全部字符串
        if startPos == -1 {
            return self
        }
        return String(self[..<startPos])
    }
}

/*
 let text = "Hello world"
 text[...3] // "Hell"
 text[6..<text.count] // world
 text[NSRange(location: 6, length: 3)] // wor
 */
extension String {
    /*
     字符串截取
     let str00 = "hello world"
     let str01 = str00[1..<str00.count-1]
     print(str00)
     print(str01)
     */
    public subscript(value: NSRange) -> Substring {
        return self[value.lowerBound ..< value.upperBound]
    }

    /*
     闭合截取
     let str00 = "hello world"
     let str01 = str00[1...str00.count]
     */
    public subscript(value: CountableClosedRange<Int>) -> Substring {
        guard let upperIndex = index(at: value.upperBound) else {
            guard let lowerIndex = index(at: value.lowerBound) else {
                return self[startIndex ... endIndex]
            }
            return self[lowerIndex...]
        }
        guard let lowerIndex = index(at: value.lowerBound) else {
            /// 这块表示 截取最后一个字母
            if upperIndex >= endIndex {
                return self[startIndex...]
            } else {
                return self[startIndex ... upperIndex]
            }
        }
        /// 这块表示 截取最后一个字母
        if upperIndex >= endIndex {
            return self[lowerIndex...]
        } else {
            return self[lowerIndex ... upperIndex]
        }
    }

    /*
     非闭合截取
     let str00 = "hello world"
     let str01 = str00[1..<str00.count]
     */
    public subscript(value: CountableRange<Int>) -> Substring {
        guard let upperIndex = index(at: value.upperBound) else {
            guard let lowerIndex = index(at: value.lowerBound) else {
                return self[startIndex ..< endIndex]
            }
            return self[lowerIndex ..< endIndex]
        }
        guard let lowerIndex = index(at: value.lowerBound) else {
            return self[startIndex ..< upperIndex]
        }
        return self[lowerIndex ..< upperIndex]
    }

    /*
     非闭合截取
     let str00 = "hello world"
     let str01 = str00[..<str00.count]
     */
    public subscript(value: PartialRangeUpTo<Int>) -> Substring {
        guard let index = index(at: value.upperBound) else {
            return self[..<endIndex]
        }
        return self[..<index]
    }

    /*
     闭合截取
     let str00 = "hello world"
     let str01 = str00[...str00.count]
     */
    public subscript(value: PartialRangeThrough<Int>) -> Substring {
        guard let index = index(at: value.upperBound) else {
            return self[..<endIndex]
        }
        return self[...index]
    }

    /*
     闭合截取
     let str00 = "hello world"
     let str01 = str00[3...]
     */
    public subscript(value: PartialRangeFrom<Int>) -> Substring {
        guard let index = index(at: value.lowerBound) else {
            return self[startIndex...]
        }
        /// 这块表示 截取最后一个字母
        if index >= endIndex {
            return self[startIndex...]
        }
        return self[index...]
    }

    func index(at offset: Int) -> String.Index? {
        if count < offset {
            return nil
        }
        return index(startIndex, offsetBy: offset)
    }
}

/// 字符串的处理
extension String {
    public var length: Int {
        return count
    }

    public func indexOf(_ target: String) -> Int? {
        let range = (self as NSString).range(of: target)

        return range.location
    }

    public func lastIndexOf(target: String) -> Int? {
        let range = (self as NSString).range(of: target, options: NSString.CompareOptions.backwards)
        return length - range.location - 1
    }

    public func contains(s: String) -> Bool {
        return (range(of: s) != nil) ? true : false
    }

    /// 解析html文本
    public func stringFromHTML(_ string: String) -> String? {
        do {
            let str = try NSAttributedString(data: string.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                             options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return str.string
        } catch {
            print("html error\n", error)
        }
        return nil
    }

    /// 转换utf-8
    var utf8Data: Data? {
        return data(using: .utf8)
    }

    /// 是否是电话号码
    public func checkPhoneNumInput() -> Bool {
        let phoneRegex: NSString = "[1][345678]\\d{9}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }

    /// 是否是数字
    public func isNumberString() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }

    /// 是否是电子邮箱
    public func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    /// url字符串编码
    func urlEncodeString() -> String? {
        return addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    /// 生成UUID
    static func UUID() -> String {
        let uuid = CFUUIDCreate(nil)
        let str = CFUUIDCreateString(nil, uuid)!
        return str as String
    }
}

// MARK: - 根据文字计算高度

extension String {
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

// MARK: - 转换汉字为拼音

extension String {
    public func transformToPinYin() -> String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }
}

// MARK: - Path
public extension String {
    /// Documents目录路径
    static var documentsDirectoryPath: String {
        return URL.documentsDirectoryUrl.path
    }
    
    /// Caches目录路径
    static var cachesDirectoryPath: String {
        return URL.cachesDirectoryUrl.path
    }
    
    /// Library目录路径
    static var libraryDirectoryPath: String {
        return URL.libraryDirectoryUrl.path
    }
    
    /// tmp目录路径
    static var tmpDirectoryPath: String {
        return NSTemporaryDirectory()
    }
}

public extension String {
    /// 返回组成字符串的字符数组
    var charactersArray: [Character] {
        return Array(self)
    }
    
    
    /// 去掉字符串首尾的空格换行，中间的空格和换行忽略
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 是否不为空
    ///
    /// "", "  ", "\n", "  \n   "都视为空
    /// 不为空返回true， 为空返回false
    var isNotBlank: Bool {
        return !trimmed.isEmpty
    }
    
    
    /// 字符串的全部范围
    var rangeOfAll: NSRange {
        return NSRange(location: 0, length: count)
    }
    
    /// NSRange转换为当前字符串的Range
    ///
    /// - Parameter range: NSRange对象
    /// - Returns: 当前字符串的范围
    func range(for range: NSRange) -> Range<String.Index>? {
        return Range(range, in: self)
    }
}
