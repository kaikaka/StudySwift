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
    let data = Observable.just([DataModel(className: ObservableViewController.self, name: "Observable")])
}
