//
//  RegexHelper.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import Foundation

/*
 自定义运算符
 参考资料: https://www.jianshu.com/p/75a5184ecb66
 */
struct RegexHelper {
    let regex: NSRegularExpression

    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: .caseInsensitive)
    }

    func match(input: String) -> Bool {
        let matches = regex.matches(in: input,
                                    options: [],
                                    range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}

infix operator =~: ATPrecedence
precedencegroup ATPrecedence { // 定义运算符优先级ATPrecedence
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

public func =~ (lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(input: lhs)
    } catch _ {
        return false
    }
}
