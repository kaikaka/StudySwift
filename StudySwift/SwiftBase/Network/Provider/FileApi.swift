//
//  FileApi.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/11.
//

import Foundation
import Moya
import Result
import RxSwift
import Alamofire

/// 默认文档保存路径
private let assetDir: URL = {
    let directoryUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryUrls.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

/// 资源分类
public enum Asset {
    case logo // 普通图片
    case file // zip 压缩包
//    case video // 视频
    case other // 其他
}

extension Asset: ApiType {
    var asssetName: String {
        switch self {
        case .logo: return "logo.png"
        case .file: return "DealReportBgImage.zip"
        case .other: return "other.db"
        }
    }

    var localLocation: URL {
        return assetDir.appendingPathComponent(asssetName)
    }

    public var baseUrlString: String {
        return "www.xxx.com"
    }

    public var path: String {
        return "/download/mobile/\(asssetName)"
    }

    public var method: Moya.Method {
        return .get
    }

    var downloadDestiuation: DownloadDestination {
        return { _, _ in (self.localLocation, .removePreviousFile) }
    }

    public var task: Task {
        return .downloadDestination(downloadDestiuation)
    }

    public var validate: Bool {
        return false
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var headers: [String: String]? {
        return nil
    }
}

final class FileApi {
    init() { }
    
    func load(asset: Asset, completion: ((Result<Any, Error>) -> Void)? = nil) {
        if FileManager.default.fileExists(atPath: asset.localLocation.path) {
            completion?(.success(asset.localLocation))
            return
        }

        _ = Network.default.provider.rx
            .request(.target(asset))
            .subscribeOn(MainScheduler.asyncInstance)
            .subscribe({ result in
                switch result {
                case .success:
                    completion?(.success(asset.localLocation))
                case let .error(Error):
                    completion?(.failure(Error))
                }
            })
    }

    func load(asset: Asset, progress: ((Float) -> Void)?, completion: ((Result<Any, Error>) -> Void)? = nil) {
        if FileManager.default.fileExists(atPath: asset.localLocation.path) {
            completion?(.success(asset.localLocation))
            return
        }

//        let provider = Asset.provider
//        provider.requestWithProgress(asset).do { (response) in
//            print(response,response.progress,"response")
//        }.filterCompleted().subscribe { (json) in
//
//        }
    }
}

