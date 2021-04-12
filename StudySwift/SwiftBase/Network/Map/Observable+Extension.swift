//
//  Observable+Extension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/11.
//

//import Result
import ObjectMapper
import Moya
import RxSwift
import SwiftyJSON

enum ApiError: Swift.Error {
    case Error(info:String)
}

extension Swift.Error {
    func rawString() -> String {
        guard let err = self as? ApiError else { return self.localizedDescription }
        switch err {
        case let .Error(info):
            return info
        }
    }
}

// MARK: - JSON解析
extension Observable where Element: Moya.Response {
    
    //过滤HTTP 错误，例如超时，请求失败等
    func filterHttpError() -> Observable<Element> {
        return filter { (response) -> Bool in
            if (200 ... 209) ~= response.statusCode {
                return true
            }
            print("网络错误")
            throw ApiError.Error(info: Macros.netWorkError)
        }
    }
    
    // 过滤逻辑错误，例如协议返回 错误Code isok
    func filterResponseError() -> Observable<JSON> {
        return filterHttpError().map({(response) -> JSON in
            var json: JSON
            do {
                json = try JSON.init(data: response.data)
            } catch {
                json = JSON.init(NSNull())
            }
            var code = 200
            var msg = ""
            if let codeStr = json["isok"].rawString(), let c = Int(codeStr) { code = c }
            if json["msg"].exists() { msg = json["msg"].rawString()! }
            if code == 200 || code == 1 {
                return json
            }
            switch code {
            default:throw ApiError.Error(info: msg)
            }
        })
    }
    
    /// 将Response 转换成 JSON Model
    /// - Parameters:
    ///   - typeName: 要转换的Model Class
    ///   - dataPath: 从哪个节点开始转换，例如 ["data"]
    /// - Returns: T OR ERROR
    func mapResponseToObj<T: Mappable>(_ typeName: T.Type , dataPath:[String] = []) -> Observable<T> {
        return filterResponseError().map { (json) in
            var rootJson = json
            if dataPath.count > 0 {
                rootJson = rootJson[dataPath]
            }
            if let model: T = self.resultFromJSON(json: rootJson) {
                return model
            } else {
                throw ApiError.Error(info: "json 转换失败！！！")
            }
        }
    }
    
    /// 将Response 转换成 JSON Model Array
    /// - Parameters:
    ///   - type: 要转换的Model Class
    /// - Returns: T OR ERROR
    func mapResponseToObjArray<T: Mappable>(_ type: T.Type) -> Observable<[T]> {
        return filterResponseError().map { json in
            let rootJson = json["data"]
            var result = [T]()
            guard let jsonArray = rootJson.array else { return result }
            for json in jsonArray {
                if let jsonModel: T = self.resultFromJSON(json: json) {
                    result.append(jsonModel)
                } else {
                    throw ApiError.Error(info: "json 转换失败！！！")
                }
            }
            return result
        }
    }
    
    private func resultFromJSON<T: Mappable>(jsonString: String) -> T? {
        return T(JSONString: jsonString)
    }
    
    private func resultFromJSON<T: Mappable>(json:JSON) -> T? {
        if let str = json.rawString() {
            return resultFromJSON(jsonString: str)
        }
        return nil
    }
    
}
