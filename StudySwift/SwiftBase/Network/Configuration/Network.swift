//
//  Network.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/11.
//
import Alamofire
import Moya

extension Network {
    /// 设置SessionManager
    static var defaultSessionManager: Session {
        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        var serverTrustMg: ServerTrustManager?
        if !Macros.debug { // debug环境不用校验证书
            serverTrustMg = ServerTrustManager.init(evaluators: ["httpbin.org": PinnedCertificatesTrustEvaluator()])
        }
        let manager = Alamofire.Session(configuration: configuration,
                                        startRequestsImmediately:false ,
                                        serverTrustManager: serverTrustMg)
        
        return manager
    }
}

open class Network {
    // 不校验https证书
    public static let `noVerifyDefault`: Network = {
        var configur = Configuration.init()
        configur.timeoutInterval = 60
        configur.plugins = [NetworkIndicatorPlugin(),
                            LogPlugin(),
                            BusinessPlugin()]
        configur.manager = MoyaProvider<MultiTarget>.defaultAlamofireSession()

        return Network(configuration: configur)
    }()
    
    // 校验https证书(默认证书)
    public static let `default`: Network = {
    
        var configur = Configuration.default
        configur.timeoutInterval = 60
        configur.plugins = [NetworkIndicatorPlugin(),
                            LogPlugin(),
                            BusinessPlugin()]
        // 也可以在这里配置
        /*
         configur.addingHeaders = { target in
             return Network.defaultHeaders!
         }
         configur.replacingTask = { target in
             switch target.task {
             case let .requestParameters(parameters, encoding):
                 var defaultParameters: [String: Any] = [:]
                 for (key, value) in parameters {
                     defaultParameters[key] = value
                 }
                 return .requestParameters(parameters: defaultParameters, encoding: encoding)
             default:
                 return target.task
             }
         }
          */
        configur.manager = Network.defaultSessionManager

        return Network(configuration: configur)
    }()

    public let provider: MoyaProvider<MultiTarget>

    public init(configuration: Configuration) {
        provider = MoyaProvider(configuration: configuration)
    }
    
    // 校验https证书(对应证书)
    public convenience init(certificateName: String) {
        let configuration = URLSessionConfiguration.default
        let serverTrustMg: ServerTrustManager? = ServerTrustManager.init(evaluators: ["httpbin.org": PinnedCertificatesTrustEvaluator()])
        
        let manager = Alamofire.Session(configuration: configuration,
                                        startRequestsImmediately:false ,
                                        serverTrustManager: serverTrustMg)
        
        let serverConfigur = Configuration.default
        serverConfigur.plugins = [NetworkIndicatorPlugin(),
                            LogPlugin(),
                            BusinessPlugin()]
        serverConfigur.manager = manager
        
        self.init(configuration: serverConfigur)
    }
}

public extension MoyaProvider {
    
    convenience init(configuration: Network.Configuration) {
        /// 网络请求的设置
        let requestClosure = { (endpoint: Endpoint, closure: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = configuration.timeoutInterval
                closure(.success(request))
            } catch let MoyaError.requestMapping(url) {
                closure(.failure(.requestMapping(url)))
            } catch let MoyaError.parameterEncoding(error) {
                closure(.failure(.parameterEncoding(error)))
            } catch {
                closure(.failure(.underlying(error, nil)))
            }
        }

        /// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
        let endpointClosure = { (target: Target) -> Endpoint in
            MoyaProvider.defaultEndpointMapping(for: target)
                .adding(newHTTPHeaderFields: configuration.addingHeaders(target))
                .replacing(task: configuration.replacingTask(target))
        }
        
        
        
        self.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            session: configuration.manager!,
            plugins: configuration.plugins
        )
    }
}
