//
//  RequestNetworking.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/29.
//

import Foundation
import Alamofire

final class RequestNetworking {

    /*
     
     미 완 성 
     
     */
    
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
