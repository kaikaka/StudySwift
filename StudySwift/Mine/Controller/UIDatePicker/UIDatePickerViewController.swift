//
//  UIDatePickerViewController.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/31.
//

import RxCocoa
import RxSwift
import UIKit

class UIDatePickerViewController: UIViewController {
    let disposeBag = DisposeBag()

    var datePicker: UIDatePicker!
    var lab: UILabel!
    var startBtn: UIButton!

    var leftTime = BehaviorRelay(value: TimeInterval(180))

    // 当前倒计时是否结束
    let countDownStopped = BehaviorRelay(value: true)

//    日期格式化
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIDatePicker"
        view.backgroundColor = UIColor.white

        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 100, width: 375, height: 400))
        datePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        view.addSubview(datePicker)

        lab = UILabel(frame: CGRect(x: 0, y: 550, width: 400, height: 50))
        view.addSubview(lab)

//        self.datePicker.rx.date
//            .map{ [weak self] in
//                "当前选择的时间:" + self!.dateFormatter.string(from: $0)
//            }.bind(to: self.lab.rx.text).disposed(by: disposeBag)
        countDown()
    }

//    写一个通过时间选择器来实现倒计时
    func countDown() {
        startBtn = UIButton(type: .custom)
        startBtn.frame = CGRect(x: 0, y: 600, width: 400, height: 50)
        view.addSubview(startBtn)
        startBtn.setTitleColor(.red, for: .normal)
        startBtn.setTitleColor(.gray, for: .disabled)
        DispatchQueue.main.async {
            _ = self.datePicker.rx.countDownDuration <-> self.leftTime
        }

//        绑定按钮内容
        Observable.combineLatest(leftTime.asObservable(), countDownStopped.asObservable()) { leftTimeValue, countValue in
            if countValue {
                return "开始"
            } else {
                return "倒计时开始，还有 \(Int(leftTimeValue)) 秒..."
            }
        }.bind(to: startBtn.rx.title()).disposed(by: disposeBag)

        // 绑定button和datepicker状态（在倒计过程中，按钮和时间选择组件不可用)
        countDownStopped.asDriver().drive(startBtn.rx.isEnabled).disposed(by: disposeBag)
        countDownStopped.asDriver().drive(datePicker.rx.isEnabled).disposed(by: disposeBag)

        startBtn.rx.tap
            .bind { [weak self] in
                self?.startClicked()
            }.disposed(by: disposeBag)
    }

    // 开始倒计时
    func startClicked() {
        // 开始倒计时
        countDownStopped.accept(false)

        // 创建一个计时器
//        Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(countDownStopped.asObservable().filter { $0 }) // 倒计时结束时停止计时器
            .subscribe { _ in
                // 每次剩余时间减1
                let downTime = self.leftTime.value - 1
                self.leftTime.accept(downTime)
                // 如果剩余时间小于等于0
                if self.leftTime.value == 0 {
                    log.debug("倒计时结束！")
                    // 结束倒计时
                    self.countDownStopped.accept(true)
                    // 重制时间
                    self.leftTime.accept(180)
                }
            }.disposed(by: disposeBag)
    }
}
