//
//  UtilCoreNavigatorMap.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/28.
//

import UIKit
import URLNavigator
import Toast_Swift
import RxSwift
import RxCocoa

public protocol NavProtocol {
    static var scheme:String { get set }
    static var that:NavigatorType? { get set }
}

extension Navigator: NavProtocol {
    public static var that: NavigatorType? = nil
    public static var scheme: String = "appscheme"
}

extension String {
    public func formatScheme() -> String {
        return "\(Navigator.scheme)://\(self)"
    }
    
    ///返回路由路径
    public func getUrlString(param:[String:String]? = nil) -> String {
        let that = self.removingPercentEncoding ?? self
        let appScheme = Navigator.scheme
        let relUrl = "\(appScheme)://\(that)"
        guard param != nil else { return relUrl }
        var paramArr:[String] = []
        for (key , value) in param! {
            paramArr.append("\(key)=\(value)")
        }
        let rel = paramArr.joined(separator: "&")
        guard rel.count > 0 else { return relUrl }
        return relUrl + "?\(rel)"
    }
    ///直接通过路径和参数跳转到界面
    public func openURL(_ param:[String:String]? = nil) -> Bool {
        let that = self.removingPercentEncoding ?? self
        /// 为了使html的文件通用 需要判断是否以http或者https开头
        guard that.hasPrefix("http") || that.hasPrefix("https") || that.hasPrefix("\(Navigator.scheme)://") else {
            var url = ""
            ///如果以 '/'开头则需要加上本服务域名
            if that.hasPrefix("/") {
                url = UtilCore.shareInstance.baseUrl + that
            } else {
                url = that.getUrlString(param: param)
            }
            let isPushed = Navigator.that?.push(url) != nil
            if isPushed {
                return true
            } else {
                return Navigator.that?.open(url) ?? false
            }
        }
        /// 首先需要判断跳转的目标是否是界面还是处理事件 如果是界面需要: push 如果是事件则需要用:open
        let isPushed = Navigator.that?.push(that) != nil
        if isPushed {
            return true
        } else {
            return Navigator.that?.open(that) ?? false
        }
    }
}

public struct UtilCoreNavigatorMap {
    
    public static func initialize(navigator: NavigatorType) {
        Navigator.that = navigator
        
        //闭包 alert错误信息
        navigator.handle("alert".formatScheme()) { (url, values, context) in
            let title = url.queryParameters["title"]
            let message = url.queryParameters["message"]
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
        
        //弹出错误提示信息
        navigator.handle("alerterror".formatScheme()) { (url, values, context) -> Bool in
            guard let fromVc = UIViewController.topMost else { return false }
            let message = url.queryParameters["message"]
            fromVc.view.toast(message ?? "网络错误")
            return true
        }
    }
    
}

extension UIView {
    //根据url处理跳转
    public var rx_openUrl: AnyObserver<(url:String,param:[String:String]?)> {
        return Binder(self) { view ,tr in
            _ = tr.url.openURL(tr.param)
        }.asObserver()
    }
}

public func alertMsg(_ title:String = "提示", message:String?) -> Void {
    _ = "alert".openURL(["title":title,"message":message ?? ""])
}

public func showMsg(_ message:String?) -> Void {
    _ = "alerterror".openURL(["message":message ?? ""])
}

public func showMsg(_ codeMsg:Int) -> Void {
    showMsg(UtilCore.alertMsg[codeMsg]?.msgTitle ?? "")
}
