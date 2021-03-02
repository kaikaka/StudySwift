//
//  ToastExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/28.
//

import UIKit
import Toast_Swift

extension UIView {
    
    /// 一般的弹出显示信息 默认居中
    public func toast(_ message:String) {
        self.makeToast(message, duration: 2.0, position: .center)
    }
    
    /// 通过错误code弹出中心提示窗
    public func toastErrorCode(_ errorCode:Int) {
        self.toast(UtilCore.alertMsg[errorCode]!.msgTitle)
    }
    
    /// 显示底部提示
    public func toastBottom(_ message:String) {
        self.makeToast(message, duration: 2.0, position: .bottom)
    }
    
    /// 通过错误code弹出底部提示窗
    public func toastButtomErrorCode(_ errorCode:Int) {
        self.toastBottom(UtilCore.alertMsg[errorCode]!.msgTitle)
    }
    
    ///  提示框消失后回调
    /// - Parameters:
    ///   - message: 提示语
    ///   - position: 位置
    ///   - completion: 回调函数
    public func toastCompletion(_ message:String,position:ToastPosition = .center,completion: ((_ didTap: Bool) -> Void)?) {
        self.makeToast(message, duration: 2.0, position: position, title: nil, image: nil, completion: completion)
    }
}
