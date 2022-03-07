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
class AFHandler {
    static let session = defaultSession
    class func signBySNS(_ params: [String:Any], done: ((AfterSign) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user"
        let userOptions = UserData.userOptions
        
        var dict = params
        dict["taste_data"] = [
            "1": [ "value":  userOptions[0]],
            "2": [ "value": userOptions[1] ],
            "3": [ "value": userOptions[2] ]
        ]
                
        session.request(url, method: .post, parameters: dict, encoding: JSONEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let item):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: item, options: .prettyPrinted)
                    let dic = try? JSONSerialization.jsonObject(with: dataJSON, options: []) as? [String : Any]
                    print("munyong > \(dic?["message"])")
                    print("munyong > \(dic?["statusCode"])")

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
    
    class func getLoginSNS(loginId: String, snsID: String, authType: String, done: ((AfterLogin) -> Void)?) {
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
    
    class func getShopList(_ lat: Double, _ lng: Double, done:(([ShopInfo]) -> Void)?) {
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
                var shopInfos = [ShopInfo]()
                responseJson["data"].array?.forEach {
                    guard let key = $0["sh_no"].string,
                          let lat = $0["sh_latitude"].double,
                          let lng = $0["sh_longitude"].double
                    else { return }
                    
                    shopInfos.append(ShopInfo($0))
                }
                done?(shopInfos)
            default:
                break
            }
        }
    }
    
    class func getShopDetail(_ key: String, done:((ShopInfo?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop/\(key)"
        session.request(url, method: .get, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(nil); return }
                
                let dict = JSON(nsDict)["data"]
                done?(ShopInfo(dict))
                return
            default:
                done?(nil); return
            }
        }
    }
    
    class func getShopByKeyword(_ keyword: String, done:(([ShopInfo]) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop"
        let params = ["type":"keyword",
                      "keyword":keyword]
        session.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?([]); return }

                let responseJson = JSON(nsDict)
                print("responseJson: \(responseJson.count)")
                var shopInfos = [ShopInfo]()
                responseJson["data"].array?.forEach {
                    guard $0["sh_no"].string != nil,
                          $0["sh_latitude"].double != nil,
                          $0["sh_longitude"].double != nil
                    else { return }

                    shopInfos.append(ShopInfo($0))
                }
                done?(shopInfos)
            default:
                break
            }
        }
    }
    
    class func getWineInfo(_ key: String, done:((ReadWineInfo?) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/wine"
        let param = ["keyword":key]
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
}

class ShopInfo {
    let key: String
    let homepage: String?
    let category: String?
    let address: String?
    let name: String?
    let tellNumber: String?
    let latitude: Double
    let longtitude: Double
    init(_ param: JSON) {
        self.key = param["sh_no"].string ?? ""
        self.homepage = param["sh_url"].string
        self.category = param["sh_category"].string
        self.address = param["sh_address"].string
        self.name = param["sh_name"].string
        self.tellNumber = param["sh_tell"].string
        self.latitude = param["sh_latitude"].double ?? 0.0
        self.longtitude = param["sh_longitude"].double ?? 0.0
    }
    
    var categoryType: StoreType {
        guard let category = category else {
            return .privateShop
        }

        switch category.uppercased() {
        case "CONVENIENCE":
            return .convenience
        case "PRIVATE":
            return .privateShop
        case "CHAIN":
            return .chain
        case "CONVENIENCE":
            return .convenience
        case "SUPERMARKET":
            return .mart
        case "WAREHOUSE":
            return .warehouse
        case "DEPARTMENT":
            return .department
        default:
            return .privateShop
        }
    }
}


var defaultSession: Session {
    let interceptor = RequestInterceptor()
#if DEBUG
    return Alamofire.Session(interceptor: interceptor, eventMonitors: [EventMonitor()])
#else
    return Alamofire.Session(interceptor: interceptor)
#endif
    
}

final class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        req.setValue("Bearer " + UserData.accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(req))
    }
}
