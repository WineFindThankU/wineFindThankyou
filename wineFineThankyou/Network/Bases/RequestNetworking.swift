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
    // MARK: 로그인 API
    
    func doLoginAPI(loginId: String, snsID: String, authType: String) {
        let url = "http://125.6.36.157:3001/v1/auth/sign"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        let params = ["id":"\(loginId)",
                      "sns_id":"\(snsID)",
                      "type":"\(authType)"] as Dictionary
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
                
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
