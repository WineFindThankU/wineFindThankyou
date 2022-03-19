//
//  AFHandler+Shop.swift
//  wineFindThankyou
//
//  Created by mun on 2022/03/19.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

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
