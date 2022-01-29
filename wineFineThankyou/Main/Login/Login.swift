//
//  Login.swift
//  wineFindThankyou
//
//  Created by mun on 2022/01/29.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire

class Login {
    static let shared = Login()
    func loginByNaver(_ naverConnection: NaverThirdPartyLoginConnection?) {
        guard let isValidAccessToken = naverConnection?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            print("InvalidAccessToken")
            return
        }
        
        guard let tokenType = naverConnection?.tokenType else { return }
        guard let accessToken = naverConnection?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            print("\(result)")
            //TODO: result dictionary. 추후 localDB저장 혹은 서버 전송할 데이터
            //example
            /*
             [
                "resultcode": 00,
                "response": {
                    birthyear = 1901;
                    email = "gjansdyd@gmail.com";
                    id = "문자열";
                    nickname = "maj****";
                },
                "message": success
             ]
             */
        }
    }
}
