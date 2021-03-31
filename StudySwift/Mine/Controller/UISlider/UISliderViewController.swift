//
//  UISliderViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxSwift
import UIKit

class UISliderViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UISlider"
        self.view.backgroundColor = UIColor.white

//        滑块
        let slider = UISlider(frame: CGRect(x: 100, y: 100, width: 100, height: 20))
        view.addSubview(slider)
        slider.value = 0.1
        slider.rx.value.asObservable()
            .subscribe(onNext: {
                log.debug("滑块当前值为：\($0)")
            })
            .disposed(by: disposeBag)

//        计步器
        let step = UIStepper(frame: CGRect(x: 100, y: 200, width: 100, height: 20))
        view.addSubview(step)
        step.rx.value.asObservable()
            .subscribe(onNext: {
                log.debug("计步器当前值为：\($0)")
            })
            .disposed(by: disposeBag)

//        现在我们使用滑块（slider）来控制 stepper 的步长。
        slider.rx.value
            .map { Double($0 == 0 ? 0.01 : $0) } // 由于slider值为Float类型，而stepper的stepValue为Double类型，因此需要转换
            .bind(to: step.rx.stepValue)
            .disposed(by: disposeBag)
        step.rx.value.asDriver().map({ Float($0)
        }).drive(slider.rx.value)
    }
}
