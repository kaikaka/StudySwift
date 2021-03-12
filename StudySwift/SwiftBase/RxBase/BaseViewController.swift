//
//  BaseBaseViewController.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import NSObject_Rx
import RxSwift
import RxCocoa
import RxSwiftExt

/// 继承时需指定 ViewModel 或其子类作为泛型。该类会自动懒加载指定类型的 VM 对象。
/// 该类实现了 UITableView / UICollectionView 数据源 nil 时的占位视图逻辑。
public class BaseViewController<VM: ViewModel>: UIViewController {

    // MARK: - Lazyload

    /// 不使用该对象时，不会被初始化
    lazy var viewModel: VM = {
        guard
            let classType = "\(VM.self)".classType(VM.self)
        else {
            return VM()
        }
        let viewModel = classType.init()
        viewModel
        .loading
        .drive(isLoading)
        .disposed(by: rx.disposeBag)

        viewModel
        .error
        .drive(rx.showError)
        .disposed(by: rx.disposeBag)
        
        return viewModel
    }()

    /// 监听网络状态改变
    lazy var reachability: Reachability? = Reachability()
    /// 是否正在加载
    let isLoading = BehaviorRelay(value: false)
    /// 当前连接的网络类型
    let reachabilityConnection = BehaviorRelay(value: Reachability.Connection.wifi)
    /// 数据源 nil 时点击了 view
    let emptyDataSetViewTap = PublishSubject<Void>()
    /// 根据数据源为空时 显示空白view
    let emptyDataSetView = BehaviorRelay(value: false)
    /// 数据源 nil 时显示的标题，默认 " "
    var emptyDataSetTitle: String = ""
    /// 数据源 nil 时显示的描述，默认 " "
    var emptyDataSetDescription: String = ""
    /// 数据源 nil 时显示的图片
    var emptyDataSetImage = UIImage()
    /// 没有网络时显示的图片
    var noConnectionImage = UIImage()
    /// 没有网络时显示的标题
    var noConnectionTitle: String = ""
    /// 没有网络时显示的描述
    var noConnectionDescription: String = ""
    /// 数据源 nil 时是否可以滚动，默认 true
    var emptyDataSetShouldAllowScroll: Bool = true
    /// 没有网络时是否可以滚动， 默认 false
    var noConnectionShouldAllowScroll: Bool = false

    // MARK: - LifeCycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? reachability?.startNotifier()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        bindViewModel()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        reachability?.stopNotifier()
    }

    // MARK: - override
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - deinit
    deinit {
        print("\(type(of: self)): Deinited")
    }

    // MARK: - didReceiveMemoryWarning
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(type(of: self)): Received Memory Warning")
    }

    // MARK: - init
    func makeUI() {
        view.backgroundColor = .white
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
    }

    // MARK: - 绑定网络请求Error
    func bindError() {
        viewModel.error.asObservable()
        .subscribe(onNext: { Error in
            log.info(Error.localizedDescription)
        })
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定当前网络类型
    func bindViewModel() {
         reachability?.rx.reachabilityChanged
            .mapAt(\.connection)
        .bind(to: reachabilityConnection)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定是否正在加载到BaseViewController上
    func bindLoadingToIndicator() {
        viewModel
        .loading
        .drive(rx.isAnimatingViewController)
        .disposed(by: rx.disposeBag)
    }

    // MARK: - 绑定是否正在加载到Window上
    func bindLoadingToIndicatorToWindow() {
        viewModel
        .loading
        .drive(rx.isAnimatingWindow)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - EmptyDataSetSource
extension BaseViewController: EmptyDataSetSource {
    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var title = ""
        switch reachabilityConnection.value {
        case .none:
            title = noConnectionTitle
        case .cellular:
            title = emptyDataSetTitle
        case .wifi:
            title = emptyDataSetTitle
        }
        return NSAttributedString(string: title)
    }

    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var description = ""
        switch reachabilityConnection.value {
        case .none:
            description = noConnectionDescription
        case .cellular:
            description = emptyDataSetDescription
        case .wifi:
            description = emptyDataSetDescription
        }
        return NSAttributedString(string: description)
    }

    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        switch reachabilityConnection.value {
        case .none:
            return noConnectionImage
        case .cellular:
            return emptyDataSetImage
        case .wifi:
            return emptyDataSetImage
        }
    }

    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return .clear
    }
}

// MARK: - EmptyDataSetDelegate
extension BaseViewController: EmptyDataSetDelegate {
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        // 如果没有网络
        if self.reachability?.connection == Reachability.Connection.none {
            // 直接显示空白页
            return true
        }
        // 如果有网络，网络未加载完毕
        if isLoading.value == false {
            return false
        }
        return self.emptyDataSetView.value
    }

    public func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        emptyDataSetViewTap.onNext(())
    }

    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        switch reachabilityConnection.value {
        case .none:
            return noConnectionShouldAllowScroll
        case .cellular:
            return emptyDataSetShouldAllowScroll
        case .wifi:
            return emptyDataSetShouldAllowScroll
        }
    }
}
