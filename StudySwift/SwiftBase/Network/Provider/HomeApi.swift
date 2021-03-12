//
//  HomeProvider.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/12.
//

import Moya
enum HomeApi {
  //首页热门瀑布流
  case waterfall(position: Int, lastId: String)
}

extension HomeApi: ApiType {
    var baseURL: URL {
        
        return URL(string: Macros.apiServer)!
    }
    var path: String {
        switch self {
        case .waterfall:
            return "/feed/v1/feed/list"
        }
    }

    var method: Moya.Method{
        switch self {
        default:
            return .get
        }
    }

    var sampleData: Data {
         return "".data(using: String.Encoding.utf8)!
    }

    var task: Task {
        switch self {
            case let .waterfall(position, lastId):
                return .requestParameters(parameters:[
                "feedType": "hot",
                "needCommentInfo": 1,
                "needFavoriteInfo": 1,
                "needLikeInfo": 1,
                "needRelationInfo": 1,
                "position": position,
                "sort": "byTime",
                "lastId": lastId],
                encoding:  URLEncoding.default)
            }
        }
    var headers: [String : String]? {
        return nil
    }
}
