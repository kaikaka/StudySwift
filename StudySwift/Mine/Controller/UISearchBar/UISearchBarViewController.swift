//
//  UISearchBarViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class UISearchBarViewController: UIViewController {
    let disposeBag = DisposeBag()
    var myTable: UITableView!

    var startBtn: UIBarButtonItem!

    // 搜索栏
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UISearchBar"
        view.backgroundColor = UIColor.white

        myTable = UITableView(frame: CGRect(x: 0, y: 88, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 88), style: .plain)
        view.addSubview(myTable)
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        startBtn = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = startBtn

        // 创建表头的搜索栏
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,width: view.bounds.size.width, height: 56))
        myTable.tableHeaderView = searchBar

        let results = startBtn.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance) // 在主线程中操作，1秒内值若多次改变，取最后一次
            .startWith(()) // 加这个为了让一开始就能自动请求一次数据
            .flatMapLatest(getRandomResult) // flatMapLatest 的作用是当在短时间内（上一个请求还没回来）连续点击多次“刷新”按钮，虽然仍会发起多次请求，但表格只会接收并显示最后一次请求。避免表格出现连续刷新的现象。
            .flatMap(filterResult) // 筛选数据
            .share().retry(1)

        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
        <SectionModel<String, Int>>(configureCell: {
            _, tableview, indexPath, element in
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
            return cell
        })
        results.bind(to: myTable.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    // 获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        log.debug("正在请求数据......")
        let items = (0 ..< 5).map { _ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }

    // 过滤数据
    func filterResult(data: [SectionModel<String, Int>])
        -> Observable<[SectionModel<String, Int>]> {
        return searchBar.rx.text.orEmpty
            // .debounce(0.5, scheduler: MainScheduler.instance) //只有间隔超过0.5秒才发送
            .flatMapLatest {
                query -> Observable<[SectionModel<String, Int>]> in
                log.debug("正在筛选数据（条件为：\(query)）")
                // 输入条件为空，则直接返回原始数据
                if query.isEmpty {
                    return Observable.just(data)
                }
                // 输入条件为不空，则只返回包含有该文字的数据
                else {
                    var newData: [SectionModel<String, Int>] = []
                    for sectionModel in data {
                        let items = sectionModel.items.filter { "\($0)".contains(query) }
                        newData.append(SectionModel(model: sectionModel.model, items: items))
                    }
                    return Observable.just(newData)
                }
            }
    }
}
