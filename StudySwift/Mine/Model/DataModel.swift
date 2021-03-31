//
//  DataModel.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/15.
//
import RxSwift
import RxCocoa
import UIKit

struct DataModel {
    let className: UIViewController.Type?
    let name: String?
}

struct DataListModel {
    let data = Observable.just([DataModel(className: ObservableViewController.self, name: "Observable"),
                                DataModel(className: SubscribeViewController.self, name: "Subscribe"),
                                DataModel(className: DoOnViewController.self, name: "DoOn"),
                                DataModel(className: DisposeViewController.self, name: "Dispose"),
                                DataModel(className: BindViewController.self, name: "Bind"),
                                DataModel(className: UIExtensionViewController.self, name: "UIExtension"),
                                DataModel(className: SubjectsViewController.self, name: "Subjects"),
                                DataModel(className: TransformingViewController.self, name: "Transforming 变化操作符"),
                                DataModel(className: FilteringViewController.self, name: "Filtering 过滤操作符"),
                                DataModel(className: ConditionalBooleanOperatorsViewController.self, name: "ConditionalBooleanOperators 条件与布尔操作符"),
                                DataModel(className: CombiningViewController.self, name: "Combining 结合操作符"),
                                DataModel(className: MathematicalAggregateOperatorsViewController.self, name: "MathematicalAggregateOperators 算术聚合操作符"),
                                DataModel(className: ConnectableViewController.self, name: "Connectable 连接操作符"),
                                DataModel(className: UtilityOperatorsViewController.self, name: "UtilityOperators 其他操作符"),
                                DataModel(className: ErrorHandlingOperatorsViewController.self, name: "ErrorHandlingOperators 错误处理"),
                                DataModel(className: DebugViewController.self, name: "Debug 调试操作符"),
                                DataModel(className: TraitsViewController.self, name: "Traits 特征序列"),
                                DataModel(className: DriverViewController.self, name: "Driver 特征序列"),
                                DataModel(className: ControlPropertyViewController.self, name: "ControlProperty 特征序列"),
                                DataModel(className: SchedulersViewController.self, name: "Schedulers 调度器"),
                                DataModel(className: UILabelViewController.self, name: "UILable"),
                                DataModel(className: TextViewController.self, name: "TextView"),
                                DataModel(className: UIButtonViewController.self, name: "UIButton"),
                                DataModel(className: SwitchViewController.self, name: "UISwitch UISegemented"),
                                DataModel(className: UIActivityIndicatorViewController.self, name: "UIActivityIndicator"),
                                DataModel(className: UISliderViewController.self, name: "UISlider"),
                                DataModel(className: BidirectionalDataViewController.self, name: "Bidirectional 双向绑定"),
                                DataModel(className: UIGestureRecognizerViewController.self, name: "UIGestureRecognizer"),
                                DataModel(className: UIDatePickerViewController.self, name: "UIDatePicker"),
                                DataModel(className: UISearchBarViewController.self, name: "UISearchBar"),
                                DataModel(className: TableListViewController.self, name: "TableListView"),
                                DataModel(className: TableDataSourcesViewController.self, name: "TableView DataSources")])
}
