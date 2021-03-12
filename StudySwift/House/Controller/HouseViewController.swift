//
//  HouseViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/1/2.
//

import RxCocoa
import RxDataSources
import UIKit
import MJRefresh

class HouseViewController: CollectionViewController<PopularViewModel> {
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<HomePopularSection>!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        
    }
    
    override func makeUI() {
        super.makeUI()
        let layout = WaterfallMutiSectionFlowLayout.init()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1)
        collectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: "PopularCollectionViewCell1")
        view.addSubview(collectionView)
        collectionView.refreshHeader = RefreshHeader()
        collectionView.refreshFooter = RefreshFooter()
        setUpEmptyDataSet()
        emptyDataSetTitle = "还没有数据~"
        emptyDataSetImage = R.image.home_selected()!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindError()
        bindLoadingToIndicatorToWindow()
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        let input = PopularViewModel.Input.init(firstLoading: Driver.just({}()))
        
        let output = viewModel.transform(input: input)
        // 创建数据源
        dataSource = RxCollectionViewSectionedReloadDataSource
        <HomePopularSection>(
            configureCell: { _, collectionView, indexPath, element in
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCollectionViewCell1", for: indexPath) as? PopularCollectionViewCell {
                    cell.item = element
                    return cell
                }
                return UICollectionViewCell.init()
            }
        )
        // 绑定单元格数据
        output.items.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
        // 设置代理
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        
    }
}

extension HouseViewController: WaterfallMutiSectionDelegate {
    // 设置单元格尺寸
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        return dataSource?[indexPath].entry?.itemHeight ?? 200.0
    }

    func insetForSection(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func lineSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        return 5
    }

    func interitemSpacing(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        return 5
    }

    func spacingWithLastSection(collectionView collection: UICollectionView, layout: WaterfallMutiSectionFlowLayout, section: Int) -> CGFloat {
        return 15
    }
}

extension HouseViewController: UIScrollViewDelegate {
}
