//
//  ConnectableViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/26.
//

import UIKit
import RxCocoa
import RxSwift

//连接操作符
struct ConnectableDataListModel {
    let data = Observable.just(["Test","Publish","Replay","Multicast",
                                "RefCount","Share"])
}

class ConnectableViewController: UIViewController {
    let disposeBag = DisposeBag()
    let dataList = ConnectableDataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Connectable"
        
//        可连接的序列
//        （1）可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect()之后才会开始发送值。
//        （2）可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息。
        
        let tableView = UITableView.init(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data.bind(to: tableView.rx.items(cellIdentifier: "myCell")) { _ , model,cell in
            cell.textLabel?.text = model
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe ({ (event) in
            if let name = event.element {
                switch name {
                case "Test":
                    self.test()
                case "Publish":
                    self.publish()
                case "Replay":
                    self.replay()
                case "Multicast":
                    self.multicast()
                case "RefCount":
                    self.refCount()
                case "Share":
                    self.share()
                    
                default:
                    break
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func test() {
//      先看下普通序列的
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { log.debug("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //第二个订阅者（延迟5秒开始订阅）
        aDelay(5) {
            _ = interval
                .subscribe(onNext: { log.debug("订阅2: \($0)") }).disposed(by: self.disposeBag)
           
        }
//
    }

    ///延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - closure: 延迟执行的闭包
    public func aDelay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    func publish() {
//        publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { log.debug("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
    
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { log.debug("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    
    func replay()  {
//        replay 同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
//        replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）。
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .replay(5)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { log.debug("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { log.debug("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    
    func multicast() {
//        multicast 方法同样是将一个正常的序列转换成一个可连接的序列。
//        同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送
        //创建一个Subject（后面的multicast()方法中传入）
        let subject = PublishSubject<Int>()
        
        //这个Subject的订阅
        _ = subject
            .subscribe(onNext: { log.debug("Subject: \($0)") }).disposed(by: disposeBag)
        
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .multicast(subject)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { log.debug("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { log.debug("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    
    func refCount() {
//        refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
//        即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接。
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
            .refCount()
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { log.debug("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { log.debug("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
    
    func share() {
//        share(relay:)
//        该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
//        简单来说 shareReplay 就是 replay 和 refCount 的组合。
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .share(replay: 5)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { log.debug("订阅1: \($0)") }).disposed(by: disposeBag)
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { log.debug("订阅2: \($0)") }).disposed(by: self.disposeBag)
        }
    }
}
