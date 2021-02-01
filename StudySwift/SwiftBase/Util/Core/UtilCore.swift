//
//  UtilCore.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/28.
//

import UIKit

/*
 项目区别码 : 10开始
 模块有：00
 界面层级显示: 1第一级 2第二级 3第三级 以及往下排序
 具体提示 000 开始
 */
var alert_msg:Dictionary<Int,(msgCode:Int,msgTitle:String,msgInfo:String)> = [ 100001111 : (msgCode:100001000,msgTitle:"网络错误",msgInfo:"在生产模式时把系统错误码为1的改为提示")]


public class UtilCore {
    public static var shareInstance: UtilCore {
        struct `Static` {
            static let instance: UtilCore = UtilCore()
        }
        let utilCore = Static.instance
        return utilCore
    }
    ///用于提供弹出信息
    static public var alertMsg:Dictionary<Int,(msgCode:Int,msgTitle:String,msgInfo:String)> {
        get {
            for dict in UtilCore.msg {
                alert_msg[dict.0] = dict.1
            }
            return alert_msg
        }
        set (newValue) {
            UtilCore.msg = newValue
        }
    }
    
    ///基础网络地址
    public var baseUrl:String = ""
    
    private static var msg:Dictionary<Int,(msgCode:Int,msgTitle:String,msgInfo:String)> = [:]
}
