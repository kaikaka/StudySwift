//
//  BaseResponseModel.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/11.
//

import ObjectMapper

/// BaseResponseModel 要求传的泛型 T 必须遵守Mappable eg: { BaseResponseModel<Usermodel> }
class BaseResponseModel<T: Mappable>: Mappable {
    var isok: Int = 0
    var msg: String = ""
    /// 数据
    var data: T?
    
    init() {  }

    required init?(map: Map) {}

    func mapping(map: Map) {
        isok <- map["isok"]
        msg <- map["msg"]
        data <- map["data"]
    }
}

/// BaseResponseJson 泛型T 可以为任意类型 可以理解为T = Any eg: { BaseResponseJson<Bool>}
class BaseResponseJson<T>: Mappable {
    var isok: Int = 0
    var msg: String = ""
    /// 数据
    var data: T?
    
    init() {  }

    required init?(map: Map) {}

    func mapping(map: Map) {
        isok <- map["isok"]
        msg <- map["msg"]
        data <- map["data"]
    }
}
