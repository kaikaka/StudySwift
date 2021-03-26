//
//  DataExtensions.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import UIKit

public extension Data {
    
    /// utf8字符串
    var utf8String: String? {
        guard count > 0 else { return nil }
        return String(data: self, encoding: .utf8)
    }
}
