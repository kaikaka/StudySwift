//
//  TransformingViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/24.
//

import UIKit
import RxCocoa
import RxSwift

struct TransDataListModel {
    let data = Observable.just(["Buffer","Window","Map","FlatMap","FlatMapLatest","ConcatMap","Scan","GroupBy"])
}
//变化操作符
class TransformingViewController: UIViewController {

    let disposeBag = DisposeBag()
    let dataList = TransDataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Transforming"
        
        let tableView = UITableView.init(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data.bind(to: tableView.rx.items(cellIdentifier: "myCell")) { _ , model,cell in
            cell.textLabel?.text = model
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe ({ (event) in
            if let name = event.element {
                switch name {
                case "Buffer":
                    self.testBuffer()
                case "Window":
                    self.testWindow()
                case "Map":
                    self.testMap()
                case "FlatMap":
                    self.testFlatMap()
                case "FlatMapLatest":
                    self.testFlatMapLatest()
                case "ConcatMap":
                    self.testConcatMap()
                case "Scan":
                    self.testScan()
                case "GroupBy":
                    self.testGroupBy()
                default:
                    break
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func testBuffer() {
        // buffer 缓冲组合
        let subject = PublishSubject<String>()
        // 1秒会缓冲3个一起以数组方式抛出。如果缓存不足3个，也会发出。
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .debug()
            .subscribe { (event) in
                log.info(event.element)
            }.disposed(by: disposeBag)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            subject.dispose()
        }
    }
    
    func testWindow() {
        let subject = PublishSubject<String>()
        // window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
        //        同时 buffer要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列。
        subject.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .debug()
            .subscribe({ (event) in
                log.info("testWindow:\(event) ")
            }).disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        log.debug("Resources.total 1111 = \(RxSwift.Resources.total)")
        
        subject.onNext("1")
        log.debug("Resources.total 2222= \(RxSwift.Resources.total)")
        
        subject.onNext("2")
        subject.onNext("3")
        log.debug("Resources.total 3333= \(RxSwift.Resources.total)")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            subject.dispose()
        }
    }
    
    func testMap() {
//        该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
//        相当于返回一个10倍的新序列
        Observable.of(1, 2, 3)
            .map { $0 * 10}
            .subscribe(onNext: { log.debug($0) })
            .disposed(by: disposeBag)
    }
    
    func testFlatMap() {
//        map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。简单理解就是把一个普通数组升维到二维数组
//        而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
//        这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
//        相当于合并了两个
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        let subject3 = BehaviorSubject(value: "中文")
        
        let behaviorRelay = BehaviorRelay(value: subject1)
        
        behaviorRelay.asObservable()
            .flatMap { $0 }
//            .map { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        subject1.onNext("C")
        
        behaviorRelay.accept(subject2)//效果：log:1
        //subject1 依然是有效的
        subject1.onNext("D")
        subject1.onNext("E")
        
        //加了后，log出E,3,4 behaviorRelay.accept 时候会将value的最后一个元素发出
        behaviorRelay.accept(subject1)
        subject2.onNext("3")
        subject2.onNext("4")
        
        //再加了后，subject1依然是有效 会再次打印最后一个元素
        behaviorRelay.accept(subject1)
        subject2.onNext("3")
        subject2.onNext("4")
        
        behaviorRelay.accept(subject3)
        subject3.onNext("中文2")
        
        //所以，666依旧会导引出来。此时，subject1、subject2、subject3都是有效的observers
        subject2.onNext("666")
    }
    
    func testFlatMapLatest() {
//        flatMapLatest与flatMap 的唯一区别是：flatMapLatest只会接收最新的value 事件。
//        这样最终就只会输出subject2，subject1就不会输出了
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let behaviorRelay = BehaviorRelay(value:subject1)
        
        behaviorRelay.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { log.info($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        behaviorRelay.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    func testConcatMap() {
//        concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
//        如果subject1不发送onCompleted，subject2永远不会输出
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let behaviorRelay = BehaviorRelay(value:subject1)
        
        behaviorRelay.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { log.info($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        subject2.onNext("2")
        subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
        behaviorRelay.accept(subject2)//注意这里，只会发送当前Observable的最后一个元素
        subject2.onNext("3")
        subject1.onNext("C")
        
    }
    
    func testScan() {
//        scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
//        输出为1，3，6，10，15
//        acum 为新值  elem为下一个值
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, elem in
                acum + elem
            }
            .subscribe(onNext: { log.debug($0) })
            .disposed(by: disposeBag)
        
    }
    
    func testGroupBy()  {
        //        groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
        //        也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
        //将奇数偶数分成两组
        Observable<Int>.of(0, 1, 2, 3, 4, 5)
            .groupBy(keySelector: { (element) -> String in
                return element % 2 == 0 ? "偶数" : "基数"
            })
            .subscribe { (event) in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({ (event) in
                        log.debug("key：\(group.key)    event：\(event)")
                    }).disposed(by: self.disposeBag)
                default:
                    log.debug("")
                }
            }
            .disposed(by: disposeBag)
    }
}
