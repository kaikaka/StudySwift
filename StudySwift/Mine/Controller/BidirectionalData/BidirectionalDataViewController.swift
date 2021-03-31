//
//  BidirectionalDataViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxSwift
// 双向数据绑定
import UIKit

// 定义一个vm
struct UserViewModel {
    let userName = BehaviorRelay(value: "guset")

    lazy var userInfo = {
        self.userName.asObservable().map {
            $0 == "Admin" ? "你是管理员" : "你是普通用户"
        }.share(replay: 1)
    }()
}

class BidirectionalDataViewController: UIViewController {
//    然后我们写个简单的双向绑定
    let disposeBag = DisposeBag()
    var textField: UITextField!
    var lab: UILabel!
    var userVM = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BidirectionalData"
        view.backgroundColor = UIColor.white
        textField = UITextField(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        view.addSubview(textField)

        lab = UILabel(frame: CGRect(x: 50, y: 200, width: 200, height: 50))
        view.addSubview(lab)

//       1. 将用户名和textfield双向绑定
//        userVM.userName.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag)
//        textField.rx.text.orEmpty.bind(to: userVM.userName).disposed(by: disposeBag)
        
//   2. 自定义双向绑定操作符（见 operators.swift）
        _ = textField.rx.textInput <-> userVM.userName
//        将用户的信息绑定到lab上
        userVM.userInfo.asObservable().bind(to: lab.rx.text).disposed(by: disposeBag)
    }


}
