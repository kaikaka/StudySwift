//
//  OnCache.swift
//  RxNetwork
//
//  Created by Pircate(swifter.dev@gmail.com) on 2018/6/14.
//  Copyright © 2018年 Pircate. All rights reserved.
//

import Moya
import RxSwift

public struct OnCache<Target: ApiType, C: Codable>
where Target: Cacheable, Target.ResponseType == Moya.Response {
    
    public let target: Target
    
    private let keyPath: String?
    
    private let decoder: JSONDecoder
    
    public init(target: Target, keyPath: String?, decoder: JSONDecoder) {
        self.target = target
        self.keyPath = keyPath
        self.decoder = decoder
    }
    
    public func request() -> Single<C> {
        return target.requestApi()
            .storeCachedResponse(for: target)
            .map(C.self, atKeyPath: keyPath, using: decoder)
    }
}
