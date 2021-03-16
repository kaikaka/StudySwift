//
//  SubscribeViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/15.
//

import UIKit
import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Subscribe"
        
        let ob = Observable.of(1,2,3)
        ob.subscribe { (event) in
            log.info(event)
        }
        
        ob.subscribe { (event) in
            log.info(event)
        } onError: { (error) in
            log.info(error)
        } onCompleted: {
            log.info("Completed")
        } onDisposed: {
            log.info("Disposed")
        }

        
    }

}
