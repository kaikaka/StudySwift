//
//  DebugViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/30.
//

import UIKit
import RxCocoa
import RxSwift

//调试操作符
struct DebugDataListModel {
    let data = Observable.just(["Debug","ResourcesTotal"])
}

class DebugViewController: UIViewController {
    let disposeBag = DisposeBag()
    let dataList = DebugDataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Debug"
        
        let tableView = UITableView.init(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data.bind(to: tableView.rx.items(cellIdentifier: "myCell")) { _ , model,cell in
            cell.textLabel?.text = model
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe ({ (event) in
            if let name = event.element {
                switch name {
                case "Debug":
                    self.debug()
                case "ResourcesTotal":
                    self.resourcesTotal()
                    
                default:
                    break
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func debug() {
//        我们可以将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试。
//        debug() 方法还可以传入标记参数，这样当项目中存在多个 debug 时可以很方便地区分出来。
        Observable.of("2", "3")
            .startWith("1")
            .debug("调试")
            .subscribe(onNext: { log.debug($0) })
            .disposed(by: disposeBag)
    }

    func resourcesTotal() {
//        RxSwift.Resources.total
//        通过将 RxSwift.Resources.total 打印出来，我们可以查看当前 RxSwift 申请的所有资源数量。这个在检查内存泄露的时候非常有用。
        print(RxSwift.Resources.total)
        
        Observable.of("BBB", "CCC")
            .startWith("AAA")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        log.debug(RxSwift.Resources.total)
    }
}
