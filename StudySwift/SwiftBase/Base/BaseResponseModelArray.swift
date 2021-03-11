//
//  BaseResponseModelArray.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/11.
//

import ObjectMapper

/// BaseResponseModelArray 要求传的泛型 T 必须遵守Mappable,不然无法解析传入的model eg: { BaseResponseModelArray<Usermodel> }
class BaseResponseModelArray<T: Mappable>: Mappable {
    var isok: Int = 0
    var msg: String = ""
    /// 数据
    var dataArray: [T]?
    
    init() {  }

    required init?(map: Map) {}

    func mapping(map: Map) {
        isok <- map["isok"]
        msg <- map["msg"]
        dataArray <- map["data"]
    }
}

