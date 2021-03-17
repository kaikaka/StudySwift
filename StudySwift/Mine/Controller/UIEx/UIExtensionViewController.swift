//
//  UIExtensionViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/17.
//

import UIKit
import RxCocoa
import RxSwift

class UIExtensionViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UIExtension"
        self.view.backgroundColor = UIColor.white
        
        let label = UILabel.init(frame: CGRect.init(x: 100, y: 200, width: 150, height: 30))
        label.textColor = UIColor.black
        label.text = "extension"
        self.view.addSubview(label)
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        observable.map { (value) -> CGFloat in
            CGFloat(value)
        }.bind(to: label.rx.fontSize).disposed(by: disposeBag)
    }

}

extension Reactive where Base: UILabel {
    public var fontSize:Binder<CGFloat> {
        return Binder(self.base) { lab,fontSize in
            lab.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
