//
//  UICollectionView+Rx.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    var reloadEmptyDataSet: Binder<Void> {
        return Binder(base) { _, _ in
            // collectionView.reloadEmptyDataSet()
        }
    }

    var reloadData: Binder<Void> {
        return Binder(base) { collectionView, _ in
            collectionView.reloadData()
        }
    }

    func scrollToItem(at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) -> Binder<IndexPath> {
        return Binder(base) { collectionView, indexPath in

            collectionView.scrollToItem(at: indexPath,
                                        at: scrollPosition,
                                        animated: animated)
        }
    }
}
