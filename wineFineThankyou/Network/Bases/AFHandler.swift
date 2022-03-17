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
    static let queue = DispatchQueue(label: "AFHandlerQueue")
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
    
    class func addWine(_ param: [String: Any], done: ((Bool) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/wine"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: param, options: [])
        } catch {
            done?(false); return
        }
        
        session.request(request).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(false); return }
                
                done?(true)
                return
            default:
                done?(false); return
            }
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
    
    class func getFavoritesShop(done: (([FavoriteShop]) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user/bookmark"
        let params = ["page":"1"]
        session.request(url, method: .get, parameters: params,
                        encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary,
                      let shopList = JSON(nsDict)["data"]["list"].array
                else { done?([]); return }
                var favorites: [FavoriteShop] = []
                shopList.forEach { data in
                    guard let wineCnt = data["uh_wine_cnt"].int,
                          let key = data["shop"]["sh_no"].string,
                          let name = data["shop"]["sh_name"].string,
                          let type = data["shop"]["sh_category"].string,
                          let bookmark = data["uh_bookmark"].bool
                    else { return }
                    favorites.append(FavoriteShop(wineCnt: wineCnt, shopSummary: ShopSummary(key: key, name: name, categoryType: type), isBookmark: bookmark))
                }
                
                done?(favorites)
                return
            default:
                done?([]); return
            }
        }
    }
    
    class func searchShop(byKeyword: String, done:(([SearchingShopViewModel]) -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/shop"
        let params = ["type":"keyword",
                      "keyword":byKeyword]
        session.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary,
                      let shopList = JSON(nsDict)["data"].array
                else { done?([]); return }
                let responseJson = JSON(nsDict)
                var shops = [Shop]()
                var searchingShopViewModel: [SearchingShopViewModel] = []
                
                shopList.forEach { data in
                  //  let dict = responseJson["data"]
                    guard let key = data["sh_no"].string,
                          let name = data["sh_name"].string
                    else {
                        return
                    }
                    searchingShopViewModel.append(SearchingShopViewModel(sh_no: key, sh_name: name))
                }
                done?(searchingShopViewModel)
            default:
                break
            }
        }
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
}
class User {
    let id: String
    let nick: String
    let number: String
    let tasteType: String
    init(_ param: JSON) {
        self.id = param["us_id"].string ?? ""
        let nickAndNum = param["us_nick"].string?.components(separatedBy: "-")
        self.nick = nickAndNum?.first ?? ""
        self.number = nickAndNum?.last ?? ""
        self.tasteType = param["taste_type"].string ?? ""
    }
}

class ShopDetail {
    let key: String
    let name: String
    let shopType: ShopType
    let url: String
    let time: String
    init(_ param: JSON) {
        self.key = param["sh_no"].string ?? ""
        self.name = param["sh_name"].string ?? ""
        self.url = param["sh_url"].string ?? ""
        self.time = param["sh_time"].string ?? ""
        let typeStr = param["sh_category"].string ?? ""
        self.shopType = ShopType.allOfCases.first(where:  { $0.typeStr == typeStr }) ?? .privateShop
    }
}

class BoughtWine {
    let key: String
    let name: String
    let from: String
    let vintage: String
    let date: String
    let shopDetail: ShopDetail?
    init(_ param: JSON) {
        self.key = param["uw_no"].string ?? ""
        self.name = param["uw_name"].string ?? ""
        self.from = param["uw_country"].string ?? ""
        self.vintage = param["uw_vintage"].string ?? ""
        self.date = param["purchased_at"].string ?? ""
        self.shopDetail = ShopDetail(param["shop"])
    }
}

class VisitedShop {
    let bookmark: Bool
    let wineCount: Int
    let shopDetail: ShopDetail?
    init(_ param: JSON) {
        self.bookmark = param["uh_bookmark"].bool ?? false
        self.wineCount = param["uh_wine_cnt"].int ?? 0
        self.shopDetail = ShopDetail(param["shop"])
    }
}

struct MyPageData {
    let user: User
    let boughtWine: [BoughtWine]
    let visitedShops: [VisitedShop]
    let bookmarkedShops: [VisitedShop]
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
                bShops.forEach({
                    print("\($0.bookmark), \($0.wineCount), \($0.shopDetail?.key), \($0.shopDetail?.name), \($0.shopDetail?.time), \($0.shopDetail?.url), \($0.shopDetail?.shopType)")
                })
                
                let vShops = JSON(nsDict)["data"]["shop"]["data"].array?.compactMap {
                    VisitedShop($0)
                } ?? []
                print(vShops)
                let bWines = JSON(nsDict)["data"]["wine"]["data"].array?.compactMap {
                    BoughtWine($0)
                } ?? []
                print(bWines)
                let user = User(JSON(nsDict)["data"]["user"])
                
                print(user)
                done?(MyPageData(user: user, boughtWine: bWines,
                                 visitedShops: vShops, bookmarkedShops: bShops))
                return
            default:
                done?(nil); return
            }
        }
    }
}

// MARK: Wine
extension AFHandler {
    class func searchWine(byKeyword: String, done:((ReadWineInfo?) -> Void)?) {
        guard !byKeyword.isEmpty else { done?(nil); return }
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
    
    class func getBoughtWine(_ pageNumber: Int, done: (() -> Void)?) {
        let url = "http://125.6.36.157:3001/v1/user/wine"
        let param = ["page":pageNumber]
        session.request(url, method: .get, parameters: param, encoding: URLEncoding.default).responseJSON { res in
            switch res.result {
            case .success(let nsDict):
                guard let nsDict = nsDict as? NSDictionary
                else { done?(); return }
                
                let dict = JSON(nsDict)["data"]
                print(dict)
                done?()
                return
            default:
                done?(); return
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
