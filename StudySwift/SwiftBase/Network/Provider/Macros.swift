//
//  Macros.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/7.
//
import Foundation

struct Macros {
    static var apiServer: String {
        return "https://api.gotokeep.com"
    }
    
    static var debug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    static var appId: String {
        let infoDictionary = Bundle.main.infoDictionary
        if let appId = infoDictionary!["SoftID"] as? String {
            return appId
        }
        return "7"
    }
    
    static var versionName: String {
        let infoDictionary = Bundle.main.infoDictionary
        if let appVersion = infoDictionary!["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return ""
    }
    
    static var netWorkError: String {
        return "网络错误，请稍后重试"
    }
}

