//
//  SubjectsViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/18.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectsViewController: UIViewController {

    let disposeBag = DisposeBag()
    //Subject 即是订阅者也是Observable
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Subjects"
        
        self.publishSubject()
        self.behaviorSubject()
        self.replaySubject()
        self.behaviorRelay()
    }
    
    func publishSubject() {
        //1.PublishSubject 不需要默认值就可以创建
        let subject = PublishSubject<String>()
        //没有订阅 不会接收到元素
        subject.onNext("00000")
        
        subject.subscribe { (value) in
            log.info("第一次订阅\(value)")
        } onError: { (error) in
            log.info("第一次订阅\(error)")
        } onCompleted: {
            log.info("第一次订阅onCompleted")
        } onDisposed: {
            log.info("第一次订阅onDisposed")
        }
        
        subject.onNext("111111")
        
        subject.subscribe { (value) in
            log.info("第二次订阅\(value)")
        } onError: { (error) in
            log.info("第二次订阅\(error)")
        } onCompleted: {
            log.info("第二次订阅onCompleted")
        } onDisposed: {
            log.info("第二次订阅onDisposed")
        }
        
        subject.onNext("2222")
        subject.onCompleted()
        //已完成状态 不会再接收到任何元素
        subject.onNext("3333333")
        
        subject.subscribe { (value) in
            log.info("第三次订阅\(value)")
        } onError: { (error) in
            log.info("第三次订阅\(error)")
        } onCompleted: {
            log.info("第三次订阅onCompleted")
        } onDisposed: {
            log.info("第三次订阅onDisposed")
        }
    }
    
    func behaviorSubject() {
        //2 BehaviorSubject需要一个默认值来创建
        let subject2 = BehaviorSubject(value: 111)
        subject2.subscribe { (event) in
            log.info(event)
        }.disposed(by: disposeBag)
        
        subject2.onNext(222)
        subject2.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        subject2.subscribe { (event) in
            log.info("BehaviorSubject的第二次订阅 \(event)")
        }.disposed(by: disposeBag)
    }
    
    func replaySubject() {
        //3 ReplaySubject  buffersize
        
        let subject3 = ReplaySubject<String>.create(bufferSize: 2)
        
        //        连续发3个事件
        subject3.onNext("111")
        subject3.onNext("222")
        subject3.onNext("333")
        
        subject3.subscribe { (event) in
            log.info("ReplaySubject 第一次订阅\(event)")
        }.disposed(by: disposeBag)
        
        subject3.onNext("444")
        
        
        subject3.subscribe { (event) in
            log.info("ReplaySubject 第二次订阅\(event)")
        }.disposed(by: disposeBag)
        
        subject3.onCompleted()
        // 缓冲区有数据，继续发送元素
        subject3.subscribe { (event) in
            log.info("ReplaySubject 第三次订阅\(event)")
        }.disposed(by: disposeBag)
    }
    
    func behaviorRelay() {
        //4 BehaviorRelay 它会把当前发出去的值保存为自己的状态 同时它会在销毁时自动发送 .complete 的 event,本身并没有 subscribe() , 内部是有一个 asObservable()
        let subject4 = BehaviorRelay(value: "11111")
        subject4.accept("2222")
        subject4.asObservable().subscribe { (event) in
            log.info("BehaviorRelay 第一次订阅\(event)")
        }.disposed(by: disposeBag)
        
        subject4.accept("3333")
        subject4.asObservable().subscribe { (event) in
            log.info("BehaviorRelay 第二次订阅\(event)")
        }.disposed(by: disposeBag)
        subject4.accept("4444444")
        subject4.asObservable().subscribe { (event) in
            log.info("BehaviorRelay 第三次订阅\(event)")
        }.dispose()
        subject4.accept("55555555")
    }
}
