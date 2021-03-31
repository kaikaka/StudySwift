//
//  ControlPropertyViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxSwift
import UIKit

// 特征序列

class ControlPropertyViewController: UIViewController {
    let disposeBag = DisposeBag()

    let myTextField: UITextField = UITextField(frame: CGRect(x: 10, y: 100, width: 375, height: 50))
    let myLabel: UILabel = UILabel(frame: CGRect(x: 10, y: 200, width: 375, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "ControlProperty"
        ControlProperty()
        ControlEvent()
    }

    /**
      在RxCocoa中，拥有ControlProperty这个属性的控件都是被观察者
      那么我们如果想让一个 textField 里输入内容实时地显示在另一个 label 上，即前者作为被观察者，后者作为观察者。

      (1）ControlProperty 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者（Observable）。
     （2）ControlProperty 具有以下特征：

      不会产生 error 事件
      一定在 MainScheduler 订阅（主线程订阅）
      一定在 MainScheduler 监听（主线程监听）
      共享状态变化
      */
    func ControlProperty() {
        myTextField.backgroundColor = .red
        myLabel.backgroundColor = .orange
        view.addSubview(myLabel)
        view.addSubview(myTextField)
        // 将textField输入的文字绑定到label上
        myTextField.rx.text
            .bind(to: myLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func ControlEvent() {
        let btn: UIButton = UIButton(type: .custom)
        btn.frame = CGRect(x: 30, y: 150, width: 50, height: 50)
        btn.setTitle("点击字体变大", for: .normal)
        btn.backgroundColor = .red
        view.addSubview(btn)
        var fSize = 15
        
        btn.rx.tap
            .subscribe(onNext: {
                fSize = fSize + 1
                let observable = Observable.just(fSize)
                observable.map{CGFloat($0)}.bind(to: self.myLabel.rx.fontSize).dispose()
            }).disposed(by: disposeBag)
        
    }
}

// 扩展label属性
extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
