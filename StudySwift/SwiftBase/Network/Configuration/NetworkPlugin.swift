//
//  NetworkPlugin.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/7.
//
import Moya
import Moya_ObjectMapper
import Result
import Alamofire

public final class NetworkIndicatorPlugin: PluginType {
    /// 管理网络状态的插件
    private static var numberOfRequests: Int = 0 {
        didSet {
            if numberOfRequests > 1 { return }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfRequests > 0
            }
        }
    }
    
    public init() {}
    
    public func willSend(_ request: RequestType, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests += 1
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        NetworkIndicatorPlugin.numberOfRequests -= 1
    }
}

public final class LogPlugin: PluginType {
    public func willSend(_ request: RequestType, target: TargetType) {
        log.debug("\n---------------------------\n 准备请求: \(target.path)")
        log.debug("请求方式: \(target.method.rawValue)")
        if let params = (target as? ApiType)?.parameters {
            log.debug(params)
        }
        log.debug("\n")
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        log.debug("\n---------------------------\n 准备结束: \(target.path)")
        if let data = result.value?.data, let resutl = String(data: data, encoding: String.Encoding.utf8) {
            log.debug("请求结果: \(resutl)")
        }
        log.debug("\n")
    }
}

/// 相关处理（sentry日志、token判断、代理模式）
public final class BusinessPlugin: PluginType {
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        let url = target.baseURL.absoluteString + target.path
        var param: [String: Any] = [:]
        var error: Error?
        var response: Response?
        var isok = true
        if let api = target as? ApiType {
            param = api.parameters ?? [:]
        }
        switch result {
        case let .success(rsp):
            response = rsp
            if let mapResult = try? rsp.mapObject(BaseResponseJson<Any>.self) {
                isok = mapResult.isok == 1
            }
        case let .failure(myError):
            error = myError
        }
        
        if isok && error == nil { return }
        
        // 接口错误信息上传至sentry
//        FWExceptionReport.sendHttpRequestEvent(withUrl: url, parameter: param, message: "", error: error)
        
        // token校验
//        if let urlRsp = response?.response {
//            KServerTrustPolicyManager.verifyTokenStatus(withReponse: urlRsp)
//        }
        // 代理模式
//        FWHttpRequestProxyModeEngine.checkNetworkProxyNecessity()
    }
}
