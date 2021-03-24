//
//  TransformingViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/24.
//

import UIKit
import RxCocoa
import RxSwift

class TransformingViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Transforming"
        
        self.testBuffer()
    }
    
    func testBuffer() {
        // buffer 缓冲组合
        let subject = PublishSubject<String>()
        // 1秒会缓冲3个一起以数组方式抛出。如果缓存不足3个，也会发出。
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .debug()
            .subscribe { (event) in
                print(event.element)
            }.disposed(by: disposeBag)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
    }
    
    func testWindow() {
        let subject = PublishSubject<String>()
        
    }
    
}
