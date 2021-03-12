//
//  NVActivityIndicatorView+Rx.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

class HUDManager {
    static let shared = HUDManager()
    var hud: MBProgressHUD?
}

extension Reactive where Base: UIViewController {
    public var isAnimatingViewController: Binder<Bool> {
        return Binder(base) { vc, active in
            if active {
                HUDManager.shared.hud = HUD.showLoading(v: vc.view)
            } else {
                HUDManager.shared.hud?.hide(animated: true)
            }
        }
    }

    public var isAnimatingWindow: Binder<Bool> {
        return Binder(base) { _, active in
            if active {
                HUDManager.shared.hud = HUD.showLoading(v: nil)
            } else {
                HUDManager.shared.hud?.hide(animated: true)
            }
        }
    }
}

extension Reactive where Base: UIView {
    public var isAnimatingView: Binder<Bool> {
        return Binder(base) { view, active in
            if active {
                HUDManager.shared.hud = HUD.showLoading(v: view)
            } else {
                HUDManager.shared.hud?.hide(animated: true)
            }
        }
    }

    public var isAnimatingWindow: Binder<Bool> {
        return Binder(base) { _, active in
            if active {
                HUDManager.shared.hud = HUD.showLoading(v: nil)
            } else {
                HUDManager.shared.hud?.hide(animated: true)
            }
        }
    }
}
