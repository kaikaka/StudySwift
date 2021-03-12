//
//  ErrorTracker.swift
//  Foowwphone
//
//  Created by Yoon on 2020/10/30.
//  Copyright © 2020 Fooww. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Result

extension ObservableType {
    /**
     Dismiss errors and complete the sequence instead
     
     - returns: An observable sequence that never errors and completes when an error occurs in the underlying sequence
     */
    public func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
}

final class ErrorTracker: SharedSequenceConvertibleType {
    typealias SharingStrategy = DriverSharingStrategy

    private let _subject = PublishSubject<Error>()

    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        return _subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asObservable() -> Observable<Error> {
        return _subject.asObservable()
    }

    private func onError(_ error: Error) {
        _subject.onNext(error)
    }

    deinit {
        _subject.onCompleted()
    }
}

extension ObservableConvertibleType {
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
}
