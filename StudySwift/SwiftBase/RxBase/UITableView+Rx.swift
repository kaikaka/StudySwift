//
//  UITableView+Rx.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    var reloadEmptyDataSet: Binder<Void> {
        return Binder(base) { _, _ in
            // tableView.reloadEmptyDataSet()
        }
    }

    var reloadData: Binder<Void> {
        return Binder(base) { tableView, _ in
            tableView.reloadData()
        }
    }

    func scrollToRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Binder<IndexPath> {
        return Binder(base) { tableView, indexPath in
            tableView.scrollToRow(at: indexPath,
                                  at: scrollPosition,
                                  animated: animated)
            tableView.layoutIfNeeded()
        }
    }
}
