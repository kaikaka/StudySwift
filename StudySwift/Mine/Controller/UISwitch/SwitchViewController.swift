//
//  SwitchViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxSwift
import UIKit

class SwitchViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Switch UISegmented"

//        UISwitch 用法
        let switchBtn: UISwitch = UISwitch(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
        view.addSubview(switchBtn)
        switchBtn.rx.isOn.asObservable().subscribe(onNext: { on in
            log.debug(on)
        }).disposed(by: disposeBag)
        UISegmented()
    }

    func UISegmented() {
        let seg = UISegmentedControl(items: ["one", "two"])
        seg.frame = CGRect(x: 100, y: 300, width: 200, height: 50)
        view.addSubview(seg)
//        seg.rx.selectedSegmentIndex.asObservable()
//            .subscribe(onNext: { (index) in
//                log.debug(index)
//            }).disposed(by: disposeBag)
        seg.selectedSegmentIndex = 0
        let imageView = UIImageView(frame: CGRect(x: 100, y: 351, width: 50, height: 50))
        view.addSubview(imageView)
        // 创建一个当前需要显示的图片的可观察序列
        let imageObser: Observable<UIImage> = seg.rx.selectedSegmentIndex.asObservable()
            .map({
                let images = ["img_operation_failure", "img_operation_success"]
                return UIImage(named: images[$0])!
            })

        imageObser.bind(to: imageView.rx.image).disposed(by: disposeBag)
    }
}
