//
//  BaseNavigationController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/1.
//

import UIKit

public class BaseNavigationController: UINavigationController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        return true
    }
    
}
