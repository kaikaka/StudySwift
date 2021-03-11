//
//  ApiType.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/7.
//
import Alamofire
import Moya

public protocol ApiType: TargetType {
    /// 参数字典
    var parameters: [String: Any]? { get }

    /// 字符串类型url，用于转换（代理）
    var baseUrlString: String { get }
    
    // 支持对个别接口单独设置是否校验、及校验的证书
    // --------------------------------------
    /// 是否要验证https证书
    var verifyCertificate: Bool { get }

    /// 证书名
    var certificateName: String? { get }
    // --------------------------------------
}

extension ApiType {
    
    private var proxyBaseUrlString: String {
        return baseUrlString
    }

    // MARK: - ApiType protocol

    public var baseUrlString: String {
        return Macros.apiServer
    }

    /// 无参数的，不用实现
    public var parameters: [String: Any]? {
        return [:]
    }

    /// 个别api不需要验证的 需单独实现
    public var verifyCertificate: Bool {
        return !Macros.debug
    }

    /// 目前只有一个证书，如有特殊需单独实现
    public var certificateName: String? {
        return "defaultCertificateName"
    }

    static var defaultHeaders: [String: String]? {
        return ["VersionName": Macros.versionName,
                "AppID": Macros.appId,
                "CityCode":"cityone",
                "Token": "token"]
    }

    // MARK: - TargetType protocol

    /// 应用所有请求统一的请求头.实体类没有额外请求头的不用实现
    public var headers: [String: String]? {
        return Self.defaultHeaders
    }

    /// 由baseUrlString转换 实体类不用实现
    public var baseURL: URL {
        return URL(string: proxyBaseUrlString)!
    }

    public var method: Moya.Method {
        return .get
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        return requestTaskWithParameters
    }

    public var requestTaskWithParameters: Task {
        var defaultParameters: [String: Any] = [:]
        if let parameters = self.parameters {
            for (key, value) in parameters {
                defaultParameters[key] = value
            }
        }
        return Task.requestParameters(parameters: defaultParameters, encoding: parameterEncoding)
    }
}
