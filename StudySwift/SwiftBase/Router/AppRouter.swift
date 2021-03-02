//
//  AppRouter.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/3.
//

import UIKit
import URLNavigator

public struct AppRouter {
    public static func initialize(navigator:NavigatorType) {
        //https://juejin.cn/post/6844903989289418765
        UtilCoreNavigatorMap.initialize(navigator: navigator)
        HouseRouter.initialize(navigator: navigator)
    }
}
