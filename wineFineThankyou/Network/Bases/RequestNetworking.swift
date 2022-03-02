//
//  RequestNetworking.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/29.
//

import Foundation
import Alamofire

final class RequestNetworking {
    // MARK: 로그인 체크 API
    func getLoginAPI() {
            let url = "http://125.6.36.157:3001/v1/auth/sign"
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    print(json)
            }
        }
    
    // MARK: 로그인 API
    func getLoginCheckAPI() {
            let url = "http://125.6.36.157:3001/v1/auth/sign"
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    print(json)
            }
        }
    
    // MARK: 가게목록 API
    func getShopsList(longitude: Double, latitude: Double) {
            let url = "http://125.6.36.157:3001/v1/shop?longitude=\(longitude)&latitude=\(latitude)"
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    print(json)
            }
        }
    
}

extension RequestNetworking {
    static let accessToken = "AccessToken"
    class func doWhat() {
        let url = "http://125.6.36.157:3001/v1/shop"
        let params = ["longitude":37.10, "latitude":12.7]
        defaultSession.request(url, method: .get, parameters: params).responseJSON { (res) in
            print(res)
        }
    }
}

var defaultSession: Session {
    let interceptor = RequestInterceptor()
    #if DEBUG
    return Alamofire.Session(interceptor: interceptor, eventMonitors: [APIEventLogger()])
    #else
    return Alamofire.Session(interceptor: interceptor)
    #endif
}

final class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        req.setValue(UserDefaults.standard.string(forKey: RequestNetworking.accessToken), forHTTPHeaderField: "x-auth-token")
        completion(.success(req))
    }
}

