//
//  MathematicalAggregateOperatorsViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/26.
//

import UIKit
import RxCocoa
import RxSwift

//算术聚合操作符
struct MathematicalAggregateOperatorsDataListModel {
    let data = Observable.just(["ToArray","Reduce"])
}

class MathematicalAggregateOperatorsViewController: UIViewController {
    let disposeBag = DisposeBag()
    let dataList = MathematicalAggregateOperatorsDataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "MathematicalAggregateOperators"
        
        let tableView = UITableView.init(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data.bind(to: tableView.rx.items(cellIdentifier: "myCell")) { _ , model,cell in
            cell.textLabel?.text = model
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe ({ (event) in
            if let name = event.element {
                switch name {
                case "ToArray":
                    self.toArray()
                case "Reduce":
                    self.reduce()
                    
                default:
                    break
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func toArray() {
//        toArray
//        该操作符先把一个序列转成一个数组，并作为一个单一的事件发送，然后结束。
        Observable.of(1, 2, 3)
            .toArray()
            .subscribe({ log.debug($0) })
            .disposed(by: disposeBag)
//        结果 [1,2,3]
    }
    
    func reduce() {
//        reduce 接受一个初始值，和一个操作符号。
//        reduce 将给定的初始值，与序列里的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去
//        + - * ÷
        Observable.of(1, 2, 3, 4, 5)
            .reduce(0, accumulator: +)
            .subscribe(onNext: { log.debug($0) })
            .disposed(by: disposeBag)
//        结果 15
    }
}
