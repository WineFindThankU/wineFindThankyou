//
//  AFHandler.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/05.
//

import Foundation
import Alamofire
import SwiftyJSON

enum AfterSign {
    case success
    case fail
}

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
    class func signBySNS(_ params: [String:Any], done: ((AfterSign) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user"
        let userOptions = UserData.userOptions
        
        var dict = params
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
    
    class func getLeave(_ key: String, done:((Leave?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user"
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
    
    class func addWine(_ param: [String: Any], done: (() -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/wine"
        session.request(url, method: .get, parameters: param, encoding: URLEncoding.default).responseJSON { res in
//            switch res.result {
//            case .success(let nsDict):
//                guard let nsDict = nsDict as? NSDictionary
//                else { done?(nil); return }
//
//                let dict = JSON(nsDict)["data"]
//                print(dict)
//                done?()
//                return
//            default:
//                done?(nil); return
//            }
        }
    }
    
    class func deleteWine(_ key: String, done: (() -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/wine"
        let param = ["uw_no": key]
        session.request(url, method: .delete, parameters: param, encoding: URLEncoding.default).responseJSON { res in
        }
    }
}

//MARK: SHOP
extension AFHandler {
    class func shopList(_ lat: Double, _ lng: Double, done:(([Shop]) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop"
        let params = ["type":"location",
                      "latitude": lat,
                      "longitude":lng,
                      "radius": 2] as? [String : Any]
        session.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?([]); return }
                
                let responseJson = JSON(nsDict)
                print("responseJson: \(responseJson.count)")
                var shops = [Shop]()
                responseJson["data"].array?.forEach {
                    guard let key = $0["sh_no"].string,
                          let lat = $0["sh_latitude"].double,
                          let lng = $0["sh_longitude"].double
                    else { return }
                    
                    shops.append(Shop($0))
                }
                done?(shops)
            default:
                break
            }
        }
    }
    
    class func addFavoriteShop(_ key: String, _ isBookmarked: Bool, done: ((Bool) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop/\(key)/bookmark"
        let param = ["bookmark": isBookmarked]
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: param, options: [])
        } catch {
            print("http Body Error")
        }
        
        session.request(request).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(false); return }

                done?(true); return
            default:
                done?(false); return
            }
        }
    }
    
    class func getFavoritesShop(done: ((Bool) -> Void)?) {
//        let url = "http://125.6.36.157:3001/v1/shop/\(key)/bookmark"
    }
    
    class func shopDetail(_ key: String, done:((Shop?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop/\(key)"
        session.request(url, method: .get, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(nil); return }
                
                let dict = JSON(nsDict)["data"]
                done?(Shop(dict))
                return
            default:
                done?(nil); return
            }
        }
    }
    
    class func searchShop(byKeyword: String, done:(([Shop]) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop"
        let params = ["type":"keyword",
                      "keyword":byKeyword]
        session.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?([]); return }

                let responseJson = JSON(nsDict)
                print("responseJson: \(responseJson.count)")
                var shops = [Shop]()
                responseJson["data"].array?.forEach {
                    guard $0["sh_no"].string != nil,
                          $0["sh_latitude"].double != nil,
                          $0["sh_longitude"].double != nil
                    else { return }

                    shops.append(Shop($0))
                }
                done?(shops)
            default:
                break
            }
        }
    }
}

// MARK: Wine
extension AFHandler {
    class func searchWineInfo(byKeyword: String, done:((ReadWineInfo?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/wine"
        let param = ["keyword":byKeyword]
        session.request(url, method: .get, parameters: param, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(nil); return }
                
                let dict = JSON(nsDict)["data"]
                print(dict)
                done?(nil)
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


// MARK: Search View Controller
extension AFHandler {

    class func searchWineShop(byKeyword: String, done:((SearchShop?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop?type=keyword"
        let param = ["keyword":byKeyword]
        session.request(url, method: .get,
                        parameters: param,
                        encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(nil); return }
               let dict = JSON(nsDict)["data"]
               var searchingViewModel: [SearhingShopViewModel] = []

                dict["data"].array?.forEach { res in
                    searchingViewModel.append(SearhingShopViewModel(sh_no: res["sh_no"].string ?? "",
                                                               sh_name: res["sh_name"].string ?? ""))
                    
                }
                done?(nil)
                return
            default:
                done?(nil); return
            }
        }
    }
}
