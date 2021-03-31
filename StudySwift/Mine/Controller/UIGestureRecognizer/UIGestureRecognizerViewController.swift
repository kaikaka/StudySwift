//
//  UIGestureRecognizerViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxSwift
import UIKit

class UIGestureRecognizerViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIGestureRecognizer"
        view.backgroundColor = UIColor.white
        
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        view.addGestureRecognizer(swipe)

//        第一种写法 响应手势
//        swipe.rx.event
//            .subscribe(onNext: { [weak self] recognizer in
////                这个点是滑动的起点
//                let point = recognizer.location(in: recognizer.view)
//                self?.showAlert(title: "向上滑动", message: "\(point.x),\(point.y)")
//            }).disposed(by: disposeBag)

//        第二种写法
        swipe.rx.event
            .bind { [weak self] recognizer in
                let point = recognizer.location(in: recognizer.view)
                self?.showAlert(title: "向上滑动", message: "\(point.x),\(point.y)")
            }.disposed(by: disposeBag)
    }

    // 显示消息提示框
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        present(alert, animated: true)
    }
}
