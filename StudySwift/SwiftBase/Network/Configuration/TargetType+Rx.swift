//
//  TargetType+Rx.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/11.
//
import RxSwift
import Moya

public extension ApiType {
    /// 返回Single序列
    func requestApi() -> Single<Moya.Response> {
        let shouldVerify = self.verifyCertificate
        if shouldVerify {
            return Network.default.provider.rx.request(.target(self))
        }
        return Network.noVerifyDefault.provider.rx.request(.target(self))
    }

    /// 返回Observable序列
    func requestObsApi() -> Observable<Response> {
        return self.requestApi().asObservable()
    }

    /// 返回带进度条的序列
    func requestProgressApi() -> Observable<ProgressResponse> {
        let shouldVerify = self.verifyCertificate
        if shouldVerify {
            return Network.default.provider.rx.requestWithProgress(.target(self)).asObservable()
        }
        return Network.noVerifyDefault.provider.rx.requestWithProgress(.target(self)).asObservable()
    }
}

