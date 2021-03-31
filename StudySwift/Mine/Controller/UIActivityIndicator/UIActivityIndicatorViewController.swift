//
//  UIActivityIndicatorViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxSwift
import UIKit

class UIActivityIndicatorViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)

        title = "UIActivityIndicator"
        let activity = UIActivityIndicatorView(frame: CGRect(x: 200, y: 200, width: 50, height: 50))
        activity.color = .blue
        view.addSubview(activity)
        let switchBtn: UISwitch = UISwitch(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        view.addSubview(switchBtn)
        switchBtn.rx.value
            .bind(to: activity.rx.isAnimating)
            .disposed(by: disposeBag)

//        实际上是用UIApplication.shared.rx.isNetworkActivityIndicatorVisible 来检测网络指示器是否可见
//        switchBtn.rx.value
//            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
//            .disposed(by: disposeBag)
    }
}
