//
//  ObservableViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/15.
//
import UIKit
import RxSwift
import RxCocoa

enum myError: Error {
    case errorA
    case errorB
}

class ObservableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Observable";
        self.view.backgroundColor = UIColor.white
        //1.just()  需要一个初始值
        let observable = Observable<String>.just("5")
        //2.of() 这个方法可以接受可变数量的参数(一定是同类型)
        let observable2 = Observable.of("a","b","c")
        //3.from() 这个方法需要一个数组
        let observable3 = Observable.from(["a","b","c"])
        //4.empty() 是一个空内容的序列
        let observable4 = Observable<String>.empty()
        //5.never() 是永远不会发出的event，也不会终止，多用于异常 返回等
        let observable5 = Observable<Int>.never()
        //6.error() 发送一个错误的序列
        let observable6 = Observable<Int>.error(myError.errorA)
        //7.range() 创建一个范围的序列
        let observable7 = Observable.range(start: 1, count: 5)
        //8.repeatElement() 无限发出给定元素的Event (永不终止)
        let observable8 = Observable.repeatElement(1)
        //9.generate 判断条件为true，才会执行序列 (0,2,4,6,8,10)
        let observable9 = Observable.generate(initialState: 0) { $0 <= 10 } iterate: { $0 + 2}
        
        //10.create() 方法，必须接受一个block形式的参数
        let observable10 = Observable<String>.create { (ob) -> Disposable in
            ob.onNext("next")
            ob.onCompleted()
            return Disposables.create()
        }
        
        //11.deferred() 创建一个工厂
        var isOdd = true
        
        let factory:Observable<Int> = Observable.deferred {
            isOdd = !isOdd
            if isOdd {
                return Observable.of(1,3,5,7)
            } else {
                return Observable.of(2,4,6,8)
            }
        }
        
        factory.subscribe { event in
            print("\(isOdd)",event)
        }
        
        factory.subscribe { event in
            print("\(isOdd)",event)
        }
        
        //12.interval 每间隔1秒生成一个元素
        let observable12 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable12.subscribe {event in
            print(event)
        }
        
        //13.timer 创建一个经过设定的一段时间后，产生唯一的元素
        let observable13 = Observable<Int>.timer(3, scheduler: MainScheduler.instance)
        observable13.subscribe { (event) in
            print(event)
        }
        
        //就是经过设定一段时间，每隔一段时间产生一个元素 第一个参数就是等待5秒，第二个参数为每个1秒产生一个元素
        let observable14 = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
        observable14.subscribe { (event) in
            print(event)
        }
    }
}
