//
//  ViewModel.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import UIKit
import RxCocoa
import NSObject_Rx

/// 轻量级 ViewModel，只包含了 error 和耗时操作状态
public class ViewModel {

    /// 是否正在加载
    let loading = ActivityIndicator()
    /// track error
    let error = ErrorTracker()
    
    required init() {}

    deinit {
        print("\(type(of: self)): Deinited")
    }
}

extension ViewModel: HasDisposeBag {}
