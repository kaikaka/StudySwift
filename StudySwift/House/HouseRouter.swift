//
//  HouseRouter.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/29.
//

import Foundation
import URLNavigator

public struct HouseRouter {
    public static func initialize(navigator: NavigatorType) {
        navigator.register("HouseViewController".formatScheme()) { url, values, context in
            let houseVc = HouseViewController.init()
            return houseVc
        }
    }
}
