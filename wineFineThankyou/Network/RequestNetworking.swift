//
//  RequestNetworking.swift
//  wineFindThankyou
//
//  Created by suding on 2022/01/29.
//

import Foundation
import Alamofire

class RequestNetworking {
    
    
    func getShopsList() {
            let url = "http://125.6.36.157:3001/v1/shops"
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.default,
                       headers: ["Content-Type":"application/json", "Accept":"application/json"])
                .validate(statusCode: 200..<300)
                .responseJSON { (json) in
                    //여기서 가져온 데이터를 자유롭게 활용하세요.
                    print(json)
            }
        }
  
}
