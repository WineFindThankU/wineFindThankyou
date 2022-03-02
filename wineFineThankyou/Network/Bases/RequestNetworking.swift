//
//  RequestNetworking.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/29.
//

import Foundation
import Alamofire

final class RequestNetworking {
    class func getLoginCheckAPI() {
        let url = "http://125.6.36.157:3001/v1/auth/sign"
        defaultSession.request(url, method: .post).responseJSON { (res) in
            print(res)
        }
    }
    
}

extension RequestNetworking {
    static let accessToken = "AccessToken"
    
    // MARK: 와인샵 API
    class func doWhat() {
        let url = "http://125.6.36.157:3001/v1/shop"
        let params = ["longitude":37.10, "latitude":12.7]
        defaultSession.request(url, method: .get, parameters: params).responseJSON { (res) in
            print(res)
        }
    }
    
    // MARK: 로그인 API
    func getLoginCheckAPI() {
        let url = "http://125.6.36.157:3001/v1/auth/sign"
        AF.request(url, method: .post,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json",
                                 "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    print(json)
        }        
//        AF.request(url, method: .get, parameters: [:],
//                   encoding: URLEncoding.default,
//                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
//                    .validate(statusCode: 200..<300)
//                    .responseJSON { (response) in
//                        if let JSON = response.response
//                    {
//                        print(JSON)
//                    }
//                }
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

