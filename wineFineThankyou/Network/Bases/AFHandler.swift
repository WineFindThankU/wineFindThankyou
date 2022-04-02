//
//  AFHandler.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/05.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

var defaultSession: Session {
    let interceptor = RequestInterceptor()
#if DEBUG
    return Alamofire.Session(interceptor: interceptor, eventMonitors: [EventMonitor()])
#else
    return Alamofire.Session(interceptor: interceptor)
#endif
}

class AFHandler {
    static let session = defaultSession
    static let queue = DispatchQueue(label: "AFHandlerQueue")
    class func signBySNS(_ params: [String:Any], done: ((AfterSign) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user"
        let userOptions = UserData.userOptions
        
        var dict = params
        dict["taste_type"] = UserData.userTasteType
        dict["taste_data"] = [
            "1": [ "value":  userOptions[0]],
            "2": [ "value": userOptions[1]],
            "3": [ "value": userOptions[2]]
        ]
                
        session.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let item):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                    let dic = try? JSONSerialization.jsonObject(with: dataJSON, options: []) as? [String : Any]
                    done?(.success)
                } catch {
                    print("error")
                    done?(.fail)
                }
            default:
                done?(.fail)
                break
            }
        }
    }
    
    class func loginBySNS(loginId: String, snsID: String, authType: String, done: ((AfterLogin) -> Void)?) {
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
        
        session.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let nsDict):
                if let nsDict = nsDict as? NSDictionary {
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: nsDict, options: .prettyPrinted)
                        let getData = try JSONDecoder().decode(LoginResponse.self, from: dataJSON)
                        UserData.accessToken = getData.data.accessToken
                        UserData.loginInfo = params
                        done?(.success)
                    } catch {
                        print("error")
                        done?(.fail)
                    }
                }
            case .failure(let error):
                print(error)
                done?(.fail)
            }
        }
    }
    
    class func loginBySNS(done: ((AfterLogin) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/auth/sign"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        guard let params = UserData.loginInfo
        else { done?(.fail); return }
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        session.request(request).responseJSON {(response) in
            switch response.result {
            case .success(let nsDict):
                if let nsDict = nsDict as? NSDictionary {
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: nsDict, options: .prettyPrinted)
                        let getData = try JSONDecoder().decode(LoginResponse.self, from: dataJSON)
                        UserData.accessToken = getData.data.accessToken
                        done?(.success)
                    } catch {
                        done?(.fail)
                    }
                }
            case .failure(let error):
                done?(.fail)
            }
        }
    }
    
    class func getLogout(_ key: String, done:((Logout?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/auth/sign"
        session.request(url, method: .delete, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(nil); return }
                return
            default:
                done?(nil); return
            }
        }
    }
    
    class func getLeave(_ key: String, done:((Bool) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user"
        session.request(url, method: .delete, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(true); return }
                return
            default:
                done?(false); return
            }
        }
    }
}

extension AFHandler {
    class func getMyPageData(done: ((MyPageData?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user/info"
        session.request(url, method: .get, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(nil); return }
                
                let bShops = JSON(nsDict)["data"]["bookmark"]["data"].array?.compactMap {
                    VisitedShop($0)
                } ?? []
                
                let vShops = JSON(nsDict)["data"]["shop"]["data"].array?.compactMap {
                    VisitedShop($0)
                } ?? []
                let bWines = JSON(nsDict)["data"]["wine"]["data"].array?.compactMap {
                    BoughtWine($0)
                } ?? []
                
                let user = User(JSON(nsDict)["data"]["user"])
                
                print(user)
                done?(MyPageData(user: user, boughtWines: bWines,
                                 visitedShops: vShops, bookmarkedShops: bShops))
                return
            default:
                done?(nil); return
            }
        }
    }
}

final class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        req.setValue("Bearer " + UserData.accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(req))
    }
}
