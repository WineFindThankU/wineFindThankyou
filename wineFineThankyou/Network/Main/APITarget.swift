//
//  APITarget.swift
//  wineFindThankyou
//
//  Created by suding on 2022/02/27.
//

import Foundation
import Alamofire

enum APITarget {
    case shopList(ShopListModel.Request)
    case shopListKeyword(ShopListKeywordModel.Request)
}

extension APITarget: TargetType {

    var baseURL: String {
        return "http://125.6.36.157/v1"
    }

    var method: HTTPMethod {
        switch self {
        case .shopList: return .get
        case .shopListKeyword: return .get
        }
    }

    var path: String {
        switch self {
        case .shopList: return "/shop?type=location"
        case .shopListKeyword: return "/shop?type=keyword&"
        }
    }

    var parameters: RequestParams {
        switch self {
        case .shopList(let request): return .body(request as! Encodable)
        case .shopListKeyword(let request): return .body(request as! Encodable)
        }
    }

}
