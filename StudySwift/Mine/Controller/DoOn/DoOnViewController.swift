//
//  DoOnViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/16.
//

import UIKit
import RxSwift
import RxCocoa

class DoOnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "DoOn"
        // doOn 是用来监听事件的生命周期的，它会在每一次事件发送前和发送后调用
        // doOn 和 subscribe 是一样的
        // do(onNext:) 会在 subscribe(onNext:) 前调用
        // do(onCompleted:) 会在 subscribe(onCompleted:) 前面调用
        let observable = Observable.of(1,2,3)
        observable.do { (element) in
            log.info("do -> \(element)")
        } afterNext: { (element) in
            log.info("afterNext - > \(element)")
        } onError: { (error) in
            log.info(error)
        } afterError: { (error) in
            log.info("afterError -> \(error)")
        } onCompleted: {
            log.info("onCompleted")
        } afterCompleted: {
            log.info("afterCompleted")
        } onSubscribe: {
            log.info("onSubscribe")
        } onSubscribed: {
            log.info("onSubscribed")
        } onDispose: {
            log.info("onDispose")
        }.subscribe { (element) in
            log.info("now -> \(element)")
        } onError: { (error) in
            log.info("now -> \(error)")
        } onCompleted: {
            log.info("now ->onCompleted")
        } onDisposed: {
            log.info("now ->onDisposed")
        }

    }
}
