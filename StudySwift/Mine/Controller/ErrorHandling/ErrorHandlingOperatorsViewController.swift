//
//  ErrorHandlingOperatorsViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/30.
//

import UIKit
import RxCocoa
import RxSwift

//错误处理操作符
struct ErrorHandlingDataListModel {
    let data = Observable.just(["CatchErrorJustReturn","CatchError","Retry"])
}

class ErrorHandlingOperatorsViewController: UIViewController {
    
    enum MyError: Error {
        case A
        case B
    }
    
    let disposeBag = DisposeBag()
    let dataList = ErrorHandlingDataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "ErrorHandling"
        
        let tableView = UITableView.init(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data.bind(to: tableView.rx.items(cellIdentifier: "myCell")) { _ , model,cell in
            cell.textLabel?.text = model
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe ({ (event) in
            if let name = event.element {
                switch name {
                case "CatchErrorJustReturn":
                    self.catchErrorJustReturn()
                case "CatchError":
                    self.catchError()
                case "Retry":
                    self.retry()
                    
                default:
                    break
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func catchErrorJustReturn() {
//        当遇到 error 事件的时候，就返回指定的值，然后结束。
        let sequenceThatFails = PublishSubject<String>()
        
        sequenceThatFails
            .catchErrorJustReturn("错误")
            .subscribe(onNext: { log.debug($0) })
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("a")
        sequenceThatFails.onNext("b")
        sequenceThatFails.onNext("c")
        sequenceThatFails.onError(MyError.A)
        sequenceThatFails.onNext("d")
    }
 
    func catchError() {
//        该方法可以捕获 error，并对其进行处理。
//        同时还能返回另一个 Observable 序列进行订阅（切换到新的序列）。
        let sequenceThatFails = PublishSubject<String>()
        let recoverySequence = Observable.of("1", "2", "3")
        
        sequenceThatFails
            .catchError {
                print("Error:", $0)
                return recoverySequence
            }
            .subscribe(onNext: { log.debug($0) })
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("a")
        sequenceThatFails.onNext("b")
        sequenceThatFails.onNext("c")
        sequenceThatFails.onError(MyError.A)
        sequenceThatFails.onNext("d")
    }
    
    func retry() {
//        使用该方法当遇到错误的时候，会重新订阅该序列。比如遇到网络请求失败时，可以进行重新连接。
//        retry() 方法可以传入数字表示重试次数。不传的话只会重试一次。
        var count = 1
        
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("a")
            observer.onNext("b")
            
            //让第一个订阅时发生错误
            if count == 1 {
                observer.onError(MyError.A)
                print("Error encountered")
                count += 1
            }
            
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        sequenceThatErrors
            .retry(2)  //重试2次（参数为空则只重试一次）
            .subscribe(onNext: { log.debug($0) })
            .disposed(by: disposeBag)
    }
}
