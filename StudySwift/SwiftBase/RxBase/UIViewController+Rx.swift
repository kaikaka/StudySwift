//
//  UIViewController+Rx.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import RxSwift
import RxCocoa
import Toast_Swift

public extension Reactive where Base: UIViewController {
    func push(_ viewController: @escaping @autoclosure () -> UIViewController,
              animated: Bool = true)
        -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.pushViewController(viewController(), animated: animated)
        }
    }

    func pop(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popViewController(animated: animated)
        }
    }

    func popToRoot(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.navigationController?.popToRootViewController(animated: animated)
        }
    }

    func present(_ viewController: @escaping @autoclosure () -> UIViewController,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil)
        -> Binder<Void> {
        return Binder(base) { this, _ in
            this.present(viewController(), animated: animated, completion: completion)
        }
    }

    func dismiss(animated: Bool = true) -> Binder<Void> {
        return Binder(base) { this, _ in
            this.dismiss(animated: animated, completion: nil)
        }
    }

    var showError: Binder<Error> {
        return Binder(base) { this , _ in
            /*
             this, error in
             获取请求code 可用来处理不同请求状态
             let moyaError: MoyaError? = error as? MoyaError
             let response : Response? = moyaError?.response
             log.info(response?.statusCode)
             */
            this.view.makeToast("网络错误，请稍后再试~")
        }
    }
}

public extension UIViewController {
    ///延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - closure: 延迟执行的闭包
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
