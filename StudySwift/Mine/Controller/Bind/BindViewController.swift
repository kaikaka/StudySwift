//
//  BindViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/17.
//

import UIKit
import RxCocoa
import RxSwift

class BindViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bind"
        self.view.backgroundColor = UIColor.white
        
        let label = UILabel.init(frame: CGRect.init(x: 100, y: 100, width: 150, height: 30))
        label.textColor = UIColor.black
        self.view.addSubview(label)
        
        let _:AnyObserver<String> = AnyObserver.init { (event) in
            switch event {
            case .next(let text):
                label.text = text
            default:
                break
            }
        }
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        observable.map { (value) -> String in
            "当前索引：\(value)"
        }.bind(to: label.rx.text).disposed(by: disposeBag)
        
    }

}
