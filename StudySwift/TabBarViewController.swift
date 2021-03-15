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
        homeNav.tabBarItem = UITabBarItem.init(title: "首页", image: R.image.home_unselected(), selectedImage: R.image.home_selected())
        
        let disVc = DiscoverViewController.init()
        let disNav = BaseNavigationController.init(rootViewController: disVc)
        disNav.tabBarItem = UITabBarItem.init(title: "发现", image: R.image.discovery_unselected(), selectedImage: R.image.discovery_selected())
        
        let mineVc = MineViewController.init()
        let mineNav = BaseNavigationController.init(rootViewController: mineVc)
        mineNav.tabBarItem = UITabBarItem.init(title: "我的", image: R.image.category_unselected(), selectedImage: R.image.category_selected())
        
        self.viewControllers = [homeNav,disNav,mineNav]
    }
}
