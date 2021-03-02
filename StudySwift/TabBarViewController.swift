//
//  TabBarViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/2.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVc = HouseViewController.init()
        let homeNav = BaseNavigationController.init(rootViewController: homeVc)
        homeNav.tabBarItem = UITabBarItem.init(title: "首页", image: nil, selectedImage: nil)
        
        let disVc = DiscoverViewController.init()
        let disNav = BaseNavigationController.init(rootViewController: disVc)
        disNav.tabBarItem = UITabBarItem.init(title: "发现", image: nil, selectedImage: nil)
        
        let mineVc = MineViewController.init()
        let mineNav = BaseNavigationController.init(rootViewController: mineVc)
        mineNav.tabBarItem = UITabBarItem.init(title: "我的", image: nil, selectedImage: nil)
        
        self.viewControllers = [homeNav,disNav,mineNav]
    }
}
