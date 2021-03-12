//
//  PopularViewModel.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/12.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

final class PopularViewModel: RefreshViewModel {
    // 记录当前的索引值
    var index: Int = 1
    var lastId = ""
    struct Input {
        let firstLoading: Driver<Void>
    }

    struct Output {
        let items: Driver<[HomePopularSection]>
    }
}

extension PopularViewModel: ViewModelable {
    func transform(input: PopularViewModel.Input) -> PopularViewModel.Output {
        let elements = BehaviorRelay<[HomePopularSection]>(value: [])
        let output = Output(items: elements.asDriver())
        var page: Int = 1

        let firstLoad = input.firstLoading.flatMapLatest { [unowned self] _ -> Driver<HomePopularRootClass> in
            self.request(position: page, lastId: self.lastId)
        }

        firstLoad.drive(onNext: { obj in
            let value = obj.data?.items ?? []
            self.lastId = ""
            elements.accept([HomePopularSection(items: value)])
        }).disposed(by: disposeBag)

        // 下拉刷新
        let loadNew = refreshOutput.headerRefreshing.then(page = 1)
            .flatMapLatest { [unowned self] _ -> Driver<HomePopularRootClass> in
                self.request(position: page, lastId: self.lastId)
            }
        // 上拉加载更多
        let loadMore = refreshOutput.footerRefreshing.then(page += 1)
            .flatMapLatest { [unowned self] _ in
                self.request(position: page, lastId: self.lastId)
            }
        // 数据源
        loadNew.drive(onNext: { [weak self] obj in
            guard self != nil else { return }
            let value = obj.data?.items ?? []
            self?.lastId = ""
            elements.accept([HomePopularSection(items: value)])
        }).disposed(by: disposeBag)

        loadMore.drive(onNext: { [weak self] obj in
            guard self != nil else { return }
            let value = (elements.value.first?.items ?? []) + (obj.data?.items ?? [])
            self?.lastId = obj.data?.lastId ?? ""
            elements.accept([HomePopularSection(items: value)])
        }).disposed(by: disposeBag)

        // success 下的刷新状态
        loadNew
            .mapTo(false)
            .drive(refreshInput.headerRefreshState)
            .disposed(by: disposeBag)

        /// 通过使用 merge 操作符你可以将多个 Observables 合并成一个
        Driver.merge(
            loadNew.map {
                var state: RxMJRefreshFooterState = .default
                if page == 1 && $0.data?.items?.isEmpty ?? false {
                    state = .hidden
                } else if $0.data?.items?.isEmpty ?? false {
                    state = .noMoreData
                } else {
                    state = .default
                }
                return state
            },

            loadMore.map {
                $0.data?.items?.isEmpty ?? false ? RxMJRefreshFooterState.noMoreData : RxMJRefreshFooterState.default
            })
            .startWith(.hidden)
            .drive(refreshInput.footerRefreshState)
            .disposed(by: disposeBag)
        return output
    }
}

extension PopularViewModel {
    func request(position: Int, lastId: String) -> Driver<HomePopularRootClass> {
        HomeApi.waterfall(position: position, lastId: lastId).requestObsApi()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.default))
            .mapObject(HomePopularRootClass.self)
            .debug()
            .trackActivity(loading)
            .trackError(refreshError)
            .trackError(error)
            .subscribeOn(MainScheduler.asyncInstance)
            .asDriverOnErrorJustComplete()
    }
}
