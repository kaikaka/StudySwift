//
//  MineViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/2.
//

import UIKit
import RxSwift
import RxCocoa

class MineViewController: UIViewController {

    let disposeBag = DisposeBag()
    let dataList = DataListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.title = "我的"
        
        let tableView = UITableView.init(frame: self.view.bounds)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dataList.data.bind(to: tableView.rx.items(cellIdentifier: "myCell")) { _ , model,cell in
            cell.textLabel?.text = model.name
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DataModel.self).subscribe ({ (event) in
            let vcClass = event.element?.className
            if let vc = vcClass {
                let lvc = vc.init()
                lvc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(lvc, animated: true)
            }
        }).disposed(by: disposeBag)

    }
}
