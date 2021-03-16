//
//  DisposeViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/16.
//

import UIKit
import RxCocoa
import RxSwift

class DisposeViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dispose"
        self.view.backgroundColor = UIColor.white
        
        let ob = Observable.of(1,2,3)
        let sub = ob.subscribe { (element) in
            log.info(element)
        }
        //手动释放
        sub.dispose()
        //会在合适的时机自动释放
        sub.disposed(by: disposeBag)
    }
}
